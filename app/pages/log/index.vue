<script setup>
const apiBase = useRuntimeConfig().public.apiBase;
import { ref, reactive, onMounted } from 'vue';
import { IconSearch } from "@tabler/icons-vue";
import { formatDateTimeID } from "~/utils/formatDate.js";

definePageMeta({
  title: "Log Aktifitas",
});

useSeoMeta({
  title: "Log Aktifitas",
});

const isLoading = ref(true);
const logList = ref([]);
const pagination = ref({ page: 1, limit: 10, total: 0, total_pages: 1 });

const filters = reactive({
  search: '',
  tanggal_dari: '',
  tanggal_sampai: '',
  page: 1,
  limit: 10,
});

let searchDebounceTimer = null;
const onSearchInput = (value) => {
  filters.search = value;
  filters.page = 1;
  clearTimeout(searchDebounceTimer);
  searchDebounceTimer = setTimeout(() => fetchLogs(), 400);
};

const fetchLogs = async () => {
  isLoading.value = true;
  try {
    const token = useCookie('auth_token');
    const query = {
      page: filters.page,
      limit: filters.limit,
    };
    if (filters.search) query.search = filters.search;
    if (filters.tanggal_dari) query.tanggal_dari = filters.tanggal_dari;
    if (filters.tanggal_sampai) query.tanggal_sampai = filters.tanggal_sampai;

    const response = await $fetch(`${apiBase}/api/log`, {
      headers: { Authorization: `Bearer ${token.value}` },
      query
    });
    logList.value = response.data || [];
    if (response.pagination) pagination.value = response.pagination;
  } catch (error) {
    console.error('Gagal mengambil data log:', error);
  } finally {
    isLoading.value = false;
  }
};

const onFilterChange = () => {
  filters.page = 1;
  fetchLogs();
};

const goToPage = (page) => {
  if (page < 1 || page > pagination.value.total_pages) return;
  filters.page = page;
  fetchLogs();
};

const visiblePages = (current, total) => {
  const range = [];
  const start = Math.max(1, current - 2);
  const end = Math.min(total, current + 2);
  for (let i = start; i <= end; i++) range.push(i);
  return range;
};

onMounted(() => {
  fetchLogs();
});
</script>

<template>
  <div class="card">
    <div class="card-header">
      <div class="d-flex gap-2 ms-auto flex-wrap">
        <input
          type="date"
          class="form-control"
          style="width: 160px"
          v-model="filters.tanggal_dari"
          @change="onFilterChange"
        />
        <input
          type="date"
          class="form-control"
          style="width: 160px"
          v-model="filters.tanggal_sampai"
          @change="onFilterChange"
        />
        <div class="input-group" style="width: 220px">
          <input
            type="text"
            class="form-control"
            placeholder="Cari Data ..."
            :value="filters.search"
            @input="onSearchInput($event.target.value)"
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
            <th>Nama User</th>
            <th>Modul/Aktivitas</th>
            <th>Keterangan</th>
            <th>Timestamp</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="isLoading">
            <td colspan="5" class="text-center py-4">Memuat data...</td>
          </tr>
          <tr v-else-if="logList.length === 0">
            <td colspan="5" class="text-center py-4">Belum ada log aktivitas.</td>
          </tr>
          <tr v-else v-for="(item, index) in logList" :key="item.id">
            <td class="text-center">{{ (pagination.page - 1) * pagination.limit + index + 1 }}</td>
            <td>{{ item.nama_user || 'Tidak diketahui' }}</td>
            <td>{{ item.title }}</td>
            <td>{{ item.content }}</td>
            <td>{{ formatDateTimeID(item.created_at) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="card-footer d-flex align-items-center justify-content-between">
      <div class="text-secondary small">
        Menampilkan {{ logList.length }} dari {{ pagination.total }} data
      </div>
      <ul class="pagination m-0">
        <li class="page-item" :class="{ disabled: pagination.page <= 1 }">
          <a class="page-link" href="#" @click.prevent="goToPage(pagination.page - 1)">Sebelumnya</a>
        </li>
        <li
          v-for="p in visiblePages(pagination.page, pagination.total_pages)"
          :key="p"
          class="page-item"
          :class="{ active: p === pagination.page }"
        >
          <a class="page-link" href="#" @click.prevent="goToPage(p)">{{ p }}</a>
        </li>
        <li class="page-item" :class="{ disabled: pagination.page >= pagination.total_pages }">
          <a class="page-link" href="#" @click.prevent="goToPage(pagination.page + 1)">Berikutnya</a>
        </li>
      </ul>
    </div>
  </div>
</template>