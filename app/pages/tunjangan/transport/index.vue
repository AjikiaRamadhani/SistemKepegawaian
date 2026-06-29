<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import { IconSearch } from "@tabler/icons-vue";
import { formatRupiah } from "~/utils/formatRupiah.js";

definePageMeta({
  title: "Tunjangan Transport",
});

useSeoMeta({
  title: "Tunjangan Transport",
});

const NAMA_BULAN = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

const isLoading = ref(true);
const riwayat = ref([]); // data mentah dari /api/tunjangan/riwayat
const filterTahun = ref(new Date().getFullYear());
const search = ref('');

// Daftar tahun untuk dropdown (tahun sekarang +- beberapa tahun ke belakang)
const tahunOptions = computed(() => {
  const current = new Date().getFullYear();
  const years = [];
  for (let y = current; y >= current - 4; y--) years.push(y);
  return years;
});

const fetchRiwayat = async () => {
  isLoading.value = true;
  try {
    const token = useCookie('auth_token');
    const response = await $fetch('http://localhost:5000/api/tunjangan/riwayat', {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    riwayat.value = response.data || [];
  } catch (error) {
    console.error('Gagal mengambil riwayat tunjangan:', error);
  } finally {
    isLoading.value = false;
  }
};

// Gabungkan 12 bulan (untuk tahun terpilih) dengan data riwayat yang sudah dihitung.
// Bulan yang belum dihitung tetap muncul di list (totalnya 0, status "Belum Dihitung"),
// supaya HRD bisa klik dan langsung menghitungnya dari halaman detail.
const daftarBulan = computed(() => {
  const list = NAMA_BULAN.map((nama, index) => {
    const bulanKe = index + 1;
    const existing = riwayat.value.find(
      r => r.bulan === bulanKe && r.tahun === filterTahun.value
    );
    return {
      bulan: bulanKe,
      tahun: filterTahun.value,
      nama_bulan: nama,
      total_penerima: existing ? existing.total_penerima : 0,
      total_nominal: existing ? existing.total_nominal : 0,
      sudah_dihitung: !!existing,
    };
  });

  if (!search.value.trim()) return list;
  const term = search.value.trim().toLowerCase();
  return list.filter(item => item.nama_bulan.toLowerCase().includes(term));
});

onMounted(() => {
  fetchRiwayat();
});
</script>

<template>
  <div class="card">
    <div class="card-header">
      <div class="d-flex gap-2 ms-auto">
        <!-- Filter Tahun -->
        <select v-model="filterTahun" class="form-select" style="width: 150px">
          <option v-for="y in tahunOptions" :key="y" :value="y">{{ y }}</option>
        </select>

        <!-- Search nama bulan -->
        <div class="input-group" style="width: 220px">
          <input
            v-model="search"
            type="text"
            class="form-control"
            placeholder="Cari nama bulan ..."
          />
          <button class="btn" type="button">
            <IconSearch stroke="{2}" />
          </button>
        </div>
      </div>
    </div>
    <div class="table-responsive card-body p-0">
      <table class="table table-vcenter">
        <thead>
          <tr>
            <th width="5">No</th>
            <th>Nama Bulan</th>
            <th class="text-center">Total Penerima</th>
            <th class="text-center">Total Tunjangan Transport</th>
            <th class="text-center">Status</th>
            <th class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="isLoading">
            <td colspan="6" class="text-center py-4">Memuat data...</td>
          </tr>
          <tr v-else v-for="(item, index) in daftarBulan" :key="`${item.bulan}-${item.tahun}`">
            <td class="text-center">{{ index + 1 }}</td>
            <td>{{ item.nama_bulan }} {{ item.tahun }}</td>
            <td class="text-center">{{ item.total_penerima }}</td>
            <td class="text-end">{{ formatRupiah(item.total_nominal) }}</td>
            <td class="text-center">
              <span class="badge" :class="item.sudah_dihitung ? 'bg-success text-white' : 'bg-secondary text-white'">
                {{ item.sudah_dihitung ? 'Sudah Dihitung' : 'Belum Dihitung' }}
              </span>
            </td>
            <td class="text-center">
              <NuxtLink
                :to="`/tunjangan/transport/detail/${item.bulan}/${item.tahun}`"
                class="btn btn-primary btn-sm"
              >Detail</NuxtLink>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>