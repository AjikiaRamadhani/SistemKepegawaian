<script setup>
import { ref, onMounted, computed } from 'vue';
import { IconSearch } from "@tabler/icons-vue";
import { formatRupiah } from "~/utils/formatRupiah.js";

definePageMeta({
  title: "Detail Tunjangan Transport",
});

const route = useRoute();
const bulan = parseInt(route.params.bulan, 10);
const tahun = parseInt(route.params.tahun, 10);

const NAMA_BULAN = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];
const namaBulanIni = NAMA_BULAN[bulan - 1] || '';

useSeoMeta({
  title: `Detail Tunjangan Transport - ${namaBulanIni} ${tahun}`,
});

// === STATE ===
const isLoading = ref(true);
const isSubmitting = ref(false);
const sudahDihitung = ref(false);
const search = ref('');

// Mode "belum dihitung": daftar pegawai PKWTT + input jumlah hari kerja per orang
const daftarPegawai = ref([]); // [{id, nip, nama_pegawai, jarak_rumah_kantor, jumlah_hari}]

// Mode "sudah dihitung": hasil perhitungan
const dataBulanan = ref(null); // {id, bulan, tahun, total_penerima, total_nominal}
const dataDetail = ref([]);    // [{id_pegawai, nama_pegawai, jarak_km, jumlah_hari, nominal}]

const errorMessage = ref('');

// === FETCH STATUS BULAN ===
const fetchStatus = async () => {
  isLoading.value = true;
  errorMessage.value = '';
  try {
    const token = useCookie('auth_token');
    const response = await $fetch(`http://localhost:5000/api/tunjangan/cek/${bulan}/${tahun}`, {
      headers: { Authorization: `Bearer ${token.value}` }
    });

    sudahDihitung.value = response.sudah_dihitung;

    if (response.sudah_dihitung) {
      dataBulanan.value = response.bulanan;
      dataDetail.value = response.detail || [];
    } else {
      // Siapkan input jumlah_hari = 0 untuk tiap pegawai PKWTT
      daftarPegawai.value = (response.pegawai || []).map(p => ({
        ...p,
        jumlah_hari: 0
      }));
    }
  } catch (error) {
    console.error('Gagal memeriksa status bulan:', error);
    errorMessage.value = 'Gagal memuat data. Silakan coba muat ulang halaman.';
  } finally {
    isLoading.value = false;
  }
};

// === HITUNG TUNJANGAN ===
const hitungTunjangan = async () => {
  isSubmitting.value = true;
  errorMessage.value = '';
  try {
    const token = useCookie('auth_token');
    const kehadiran = daftarPegawai.value.map(p => ({
      id_pegawai: p.id,
      jumlah_hari: parseInt(p.jumlah_hari, 10) || 0
    }));

    await $fetch('http://localhost:5000/api/tunjangan/hitung', {
      method: 'POST',
      headers: { Authorization: `Bearer ${token.value}` },
      body: { bulan, tahun, kehadiran }
    });

    // Setelah berhasil, ambil ulang status (sekarang harusnya sudah_dihitung = true)
    await fetchStatus();
  } catch (error) {
    console.error('Gagal menghitung tunjangan:', error);
    errorMessage.value = error?.data?.message || 'Gagal menghitung tunjangan. Silakan coba lagi.';
  } finally {
    isSubmitting.value = false;
  }
};

// === SEARCH (untuk kedua mode) ===
const daftarPegawaiTersaring = computed(() => {
  if (!search.value.trim()) return daftarPegawai.value;
  const term = search.value.trim().toLowerCase();
  return daftarPegawai.value.filter(p => p.nama_pegawai.toLowerCase().includes(term));
});

const dataDetailTersaring = computed(() => {
  if (!search.value.trim()) return dataDetail.value;
  const term = search.value.trim().toLowerCase();
  return dataDetail.value.filter(d => d.nama_pegawai.toLowerCase().includes(term));
});

onMounted(() => {
  fetchStatus();
});
</script>

<template>
  <div>
    <h3 class="card-title">Bulan {{ namaBulanIni }} {{ tahun }}</h3>

    <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>

    <div class="card">
      <div class="card-header">
        <!-- Tombol Hitung hanya tampil jika belum dihitung -->
        <button
          v-if="!sudahDihitung && !isLoading"
          class="btn btn-primary"
          :disabled="isSubmitting"
          @click="hitungTunjangan"
        >
          {{ isSubmitting ? 'Menghitung...' : 'Hitung Tunjangan' }}
        </button>
        <span v-else-if="sudahDihitung" class="badge bg-success text-white">Sudah Dihitung</span>

        <div class="ms-auto">
          <div class="input-group">
            <input
              v-model="search"
              type="text"
              class="form-control"
              placeholder="Cari Nama Pegawai ..."
            />
            <button class="btn" type="button">
              <IconSearch stroke="{2}" />
            </button>
          </div>
        </div>
      </div>

      <div v-if="isLoading" class="card-body text-center py-4">
        Memuat data...
      </div>

      <!-- MODE: BELUM DIHITUNG -> form input jumlah hari kerja per pegawai PKWTT -->
      <div v-else-if="!sudahDihitung" class="table-responsive card-body p-0">
        <table class="table table-vcenter">
          <thead>
            <tr>
              <th width="5">No</th>
              <th>NIP</th>
              <th>Nama Pegawai</th>
              <th class="text-center">Jarak Rumah-Kantor (km)</th>
              <th class="text-center" style="width: 160px">Jumlah Hari Kerja</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="daftarPegawaiTersaring.length === 0">
              <td colspan="5" class="text-center py-4">Tidak ada pegawai PKWTT aktif.</td>
            </tr>
            <tr v-for="(item, index) in daftarPegawaiTersaring" :key="item.id">
              <td class="text-center">{{ index + 1 }}</td>
              <td>{{ item.nip }}</td>
              <td>{{ item.nama_pegawai }}</td>
              <td class="text-center">{{ item.jarak_rumah_kantor ?? '-' }}</td>
              <td class="text-center">
                <input
                  type="number"
                  min="0"
                  max="31"
                  class="form-control text-center"
                  v-model="item.jumlah_hari"
                />
              </td>
            </tr>
          </tbody>
        </table>
        <div class="card-footer text-secondary small">
          Catatan: tunjangan hanya diberikan untuk pegawai PKWTT dengan minimal 19 hari kerja,
          jarak rumah-kantor lebih dari 5 km, dan dibatasi maksimal 25 km.
        </div>
      </div>

      <!-- MODE: SUDAH DIHITUNG -> tampilkan hasil -->
      <div v-else class="table-responsive card-body p-0">
        <table class="table table-vcenter">
          <thead>
            <tr>
              <th width="5">No</th>
              <th>Nama Penerima</th>
              <th class="text-center">Kilometer</th>
              <th class="text-center">Jumlah Hari</th>
              <th class="text-center">Nominal</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="dataDetailTersaring.length === 0">
              <td colspan="5" class="text-center py-4">
                Tidak ada pegawai yang memenuhi syarat menerima tunjangan bulan ini.
              </td>
            </tr>
            <tr v-for="(item, index) in dataDetailTersaring" :key="item.id">
              <td class="text-center">{{ index + 1 }}</td>
              <td>{{ item.nama_pegawai }}</td>
              <td class="text-center">{{ item.jarak_km }}</td>
              <td class="text-center">{{ item.jumlah_hari }}</td>
              <td class="text-end">{{ formatRupiah(item.nominal) }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="dataBulanan" class="card-footer d-flex justify-content-between text-secondary small">
          <span>Total Penerima: {{ dataBulanan.total_penerima }}</span>
          <span>Total Tunjangan: {{ formatRupiah(dataBulanan.total_nominal) }}</span>
        </div>
      </div>
    </div>
  </div>
</template>