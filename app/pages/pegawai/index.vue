<script setup>
const apiBase = useRuntimeConfig().public.apiBase;
import { ref, reactive, onMounted } from 'vue';
import {
  IconPencil,
  IconPlus,
  IconSearch,
  IconTrash,
  IconFileDescription,
  IconCloudDownload,
  IconArrowUp,
  IconArrowDown,
  IconArrowsSort,
} from "@tabler/icons-vue";

import { formatDateID } from "~/utils/formatDate.js";

definePageMeta({
  title: "Data Pegawai",
  layout: false,
});

useSeoMeta({
  title: "Data Pegawai",
});

// === STATE MANAGEMENT ===
const pegawaiList = ref([]);
const isLoading = ref(true);
const idHapus = ref(null);
const userRole = ref(null); // Menyimpan role user yang login
const jabatanOptions = ref([]); // Untuk dropdown filter jabatan (multi select)

// State search/filter/sort/pagination
const filters = reactive({
  search: '',
  jabatan: [],        // array of id_jabatan (multi select)
  status_kontrak: '',
  masa_kerja_min: '',
  masa_kerja_max: '',
  sort_by: 'tanggal_masuk',
  sort_dir: 'desc',
  page: 1,
  limit: 10,
});

const pagination = ref({
  page: 1,
  limit: 10,
  total: 0,
  total_pages: 1,
});

// Debounce search supaya tidak fetch di setiap ketikan huruf
let searchDebounceTimer = null;
const onSearchInput = (value) => {
  filters.search = value;
  filters.page = 1;
  clearTimeout(searchDebounceTimer);
  searchDebounceTimer = setTimeout(() => {
    fetchPegawai();
  }, 400);
};

// === FUNGSI API ===
const fetchPegawai = async () => {
  isLoading.value = true;
  try {
    const token = useCookie('auth_token');

    const query = {
      page: filters.page,
      limit: filters.limit,
      sort_by: filters.sort_by,
      sort_dir: filters.sort_dir,
    };
    if (filters.search) query.search = filters.search;
    if (filters.jabatan.length > 0) query.jabatan = filters.jabatan.join(',');
    if (filters.status_kontrak) query.status_kontrak = filters.status_kontrak;
    if (filters.masa_kerja_min !== '') query.masa_kerja_min = filters.masa_kerja_min;
    if (filters.masa_kerja_max !== '') query.masa_kerja_max = filters.masa_kerja_max;

    const response = await $fetch(`${apiBase}/api/pegawai`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${token.value}`
      },
      query
    });
    pegawaiList.value = response.data || [];
    if (response.pagination) {
      pagination.value = response.pagination;
    }
  } catch (error) {
    console.error('Gagal mengambil data pegawai:', error);
  } finally {
    isLoading.value = false;
  }
};

const fetchJabatanOptions = async () => {
  try {
    const token = useCookie('auth_token');
    const response = await $fetch(`${apiBase}/api/pegawai/master/jabatan`, {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    jabatanOptions.value = response.data || [];
  } catch (error) {
    console.error('Gagal mengambil daftar jabatan:', error);
  }
};

const konfirmasiHapus = async () => {
  if (!idHapus.value) return;
  
  try {
    const token = useCookie('auth_token');
    await $fetch(`${apiBase}/api/pegawai/${idHapus.value}`, {
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${token.value}`
      }
    });
    
    await fetchPegawai();
    idHapus.value = null;
  } catch (error) {
    console.error('Gagal menghapus data:', error);
  }
};

// === SORTING ===
const sortableColumns = [
  { key: 'nip', label: 'NIP' },
  { key: 'nama_pegawai', label: 'Nama' },
  { key: 'nama_jabatan', label: 'Jabatan' },
  { key: 'tanggal_masuk', label: 'Tanggal Masuk' },
  { key: 'masa_kerja_tahun', label: 'Masa Kerja' },
];

const toggleSort = (columnKey) => {
  if (filters.sort_by === columnKey) {
    filters.sort_dir = filters.sort_dir === 'asc' ? 'desc' : 'asc';
  } else {
    filters.sort_by = columnKey;
    filters.sort_dir = 'asc';
  }
  filters.page = 1;
  fetchPegawai();
};

// === FILTER CHANGE HANDLERS ===
const onFilterChange = () => {
  filters.page = 1;
  fetchPegawai();
};

const toggleJabatanFilter = (id) => {
  const idx = filters.jabatan.indexOf(id);
  if (idx === -1) {
    filters.jabatan.push(id);
  } else {
    filters.jabatan.splice(idx, 1);
  }
  onFilterChange();
};

// === PAGINATION ===
const goToPage = (page) => {
  if (page < 1 || page > pagination.value.total_pages) return;
  filters.page = page;
  fetchPegawai();
};

// Hasilkan daftar nomor halaman yang ditampilkan (maks 5 nomor di sekitar halaman aktif)
const visiblePages = (current, total) => {
  const range = [];
  const start = Math.max(1, current - 2);
  const end = Math.min(total, current + 2);
  for (let i = start; i <= end; i++) range.push(i);
  return range;
};

// === INISIALISASI & CEK RBAC ===
onMounted(() => {
  const userData = useCookie('user_data');
  if (userData.value) {
    const parsed = typeof userData.value === 'string' ? JSON.parse(userData.value) : userData.value;
    userRole.value = parsed.id_role || parsed.role;

    // RBAC: Blokir akses Superadmin ke halaman ini
    if (userRole.value === 1 || userRole.value === 'Superadmin') {
      alert("Akses Ditolak! Superadmin tidak memiliki akses ke Modul Data Pegawai.");
      navigateTo('/'); 
      return; // Hentikan eksekusi script selanjutnya
    }
  }

  fetchJabatanOptions();
  fetchPegawai();
});
</script>

<template>
  <NuxtLayout name="default">
    <template #actions>
      <!-- RBAC: Hanya Admin HRD (Role 3) yang bisa Tambah Data -->
      <NuxtLink v-if="userRole === 3 || userRole === 'Admin HRD'" to="/pegawai/form" class="btn btn-primary">
        <IconPlus stroke="{3}" size="20" />Tambah
      </NuxtLink>
    </template>
    <div class="card">
      <div class="card-header">
        <div class="d-flex gap-2 ms-auto flex-wrap">
          <div class="d-flex align-items-center gap-1">
            <span class="text-nowrap">Masa Kerja</span>
            <input
              type="number"
              min="0"
              class="form-control"
              style="width: 70px"
              placeholder="Min"
              v-model="filters.masa_kerja_min"
              @change="onFilterChange"
            />
            -
            <input
              type="number"
              min="0"
              class="form-control"
              style="width: 70px"
              placeholder="Max"
              v-model="filters.masa_kerja_max"
              @change="onFilterChange"
            />
          </div>

          <!-- Filter Jabatan: multi select via dropdown checkbox -->
          <div class="dropdown">
            <button
              class="btn btn-outline-secondary dropdown-toggle"
              type="button"
              data-bs-toggle="dropdown"
              style="width: 180px; text-align: left"
            >
              {{ filters.jabatan.length === 0 ? 'Semua Jabatan' : `${filters.jabatan.length} Jabatan dipilih` }}
            </button>
            <ul class="dropdown-menu p-2" style="min-width: 220px">
              <li v-for="j in jabatanOptions" :key="j.id">
                <label class="form-check d-flex align-items-center gap-2 px-2 py-1">
                  <input
                    type="checkbox"
                    class="form-check-input"
                    :checked="filters.jabatan.includes(j.id)"
                    @change="toggleJabatanFilter(j.id)"
                  />
                  <span class="form-check-label">{{ j.nama }}</span>
                </label>
              </li>
              <li v-if="jabatanOptions.length === 0" class="px-2 py-1 text-secondary small">
                Tidak ada data jabatan
              </li>
            </ul>
          </div>

          <select
            class="form-select"
            style="width: 180px"
            v-model="filters.status_kontrak"
            @change="onFilterChange"
          >
            <option value="">Semua Status Kontrak</option>
            <option value="PKWTT">PKWTT</option>
            <option value="PKWT">PKWT</option>
            <option value="Magang">Magang</option>
          </select>

          <div class="input-group" style="width: 220px">
            <input
              type="text"
              class="form-control"
              placeholder="Cari nama/NIP/jabatan..."
              :value="filters.search"
              @input="onSearchInput($event.target.value)"
            />
            <button class="btn" type="button" @click="fetchPegawai">
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
              <th width="15" class="text-center">Aksi</th>
              <th
                v-for="col in sortableColumns"
                :key="col.key"
                class="cursor-pointer user-select-none"
                @click="toggleSort(col.key)"
              >
                <span class="d-flex align-items-center gap-1">
                  {{ col.label }}
                  <IconArrowUp v-if="filters.sort_by === col.key && filters.sort_dir === 'asc'" size="14" />
                  <IconArrowDown v-else-if="filters.sort_by === col.key && filters.sort_dir === 'desc'" size="14" />
                  <IconArrowsSort v-else size="14" class="text-secondary" />
                </span>
              </th>
              <th>Jenis Kelamin</th>
              <th>Status Kontrak</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="isLoading">
              <td colspan="9" class="text-center py-4">Memuat data dari database...</td>
            </tr>
            
            <tr v-else-if="pegawaiList.length === 0">
              <td colspan="9" class="text-center py-4">Belum ada data pegawai yang cocok.</td>
            </tr>

            <tr v-else v-for="(item, index) in pegawaiList" :key="item.id">
              <td class="text-center">{{ (pagination.page - 1) * pagination.limit + index + 1 }}</td>
              <td class="text-nowrap">
                <div class="d-flex gap-2">
                  <!-- RBAC: Hanya Admin HRD (Role 3) yang bisa Edit Data -->
                  <NuxtLink v-if="userRole === 3 || userRole === 'Admin HRD'" :to="`/pegawai/form?id=${item.id}`" class="text-dark">
                    <span data-bs-toggle="tooltip" title="Edit">
                      <IconPencil stroke="{1}" size="20" />
                    </span>
                  </NuxtLink>

                  <!-- Detail dan Download bisa dilihat oleh Manager dan Admin HRD -->
                  <NuxtLink :to="`/pegawai/${item.id}`" class="text-dark">
                    <span data-bs-toggle="tooltip" title="Detail">
                      <IconFileDescription stroke="{1}" size="20" />
                    </span>
                  </NuxtLink>

                  <a href="#" class="text-dark">
                    <span data-bs-toggle="tooltip" title="Download">
                      <IconCloudDownload stroke="{1}" size="20" />
                    </span>
                  </a>

                  <!-- RBAC: Hapus data dihilangkan karena Admin & Manager dilarang menghapus (v-if="false") -->
                  <a
                    v-if="false" 
                    href="#"
                    class="text-danger"
                    data-bs-toggle="modal"
                    data-bs-target="#modal-hapus"
                    @click="idHapus = item.id"
                  >
                    <span data-bs-toggle="tooltip" title="Hapus">
                      <IconTrash stroke="{1}" size="20" />
                    </span>
                  </a>
                </div>
              </td>
              <td>{{ item.nip }}</td>
              <td>{{ item.nama_pegawai }}</td>
              <td>{{ item.nama_jabatan || '-' }}</td>
              <td>{{ item.tanggal_masuk ? formatDateID(item.tanggal_masuk) : '-' }}</td>
              <td>{{ item.masa_kerja_tahun !== null && item.masa_kerja_tahun !== undefined ? item.masa_kerja_tahun + ' tahun' : '-' }}</td>
              <td>{{ item.jenis_kelamin }}</td>
              <td>
                <span class="badge" :class="item.status_kontrak === 'PKWTT' ? 'bg-success text-white' : 'bg-warning text-dark'">
                  {{ item.status_kontrak }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="card-footer d-flex align-items-center justify-content-between">
        <div class="text-secondary small">
          Menampilkan {{ pegawaiList.length }} dari {{ pagination.total }} data
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

      <!-- Modal Hapus dibiarkan utuh di kode, tapi tombol pemicunya sudah di-hidden -->
      <div class="modal modal-blur fade" id="modal-hapus">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
          <div class="modal-content">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-status bg-danger"></div>
            <div class="modal-body text-center py-4">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mb-2 text-danger icon-lg">
                <path d="M12 9v4"></path>
                <path d="M10.363 3.591l-8.106 13.534a1.914 1.914 0 0 0 1.636 2.871h16.214a1.914 1.914 0 0 0 1.636 -2.87l-8.106 -13.536a1.914 1.914 0 0 0 -3.274 0z"></path>
                <path d="M12 16h.01"></path>
              </svg>
              <h3 class="mb-1">Hapus Data</h3>
              <div class="text-secondary">Apakah kamu ingin menghapus data ini ?</div>
            </div>
            <div class="modal-footer">
              <div class="w-100">
                <div class="row">
                  <div class="col">
                    <a href="#" class="btn btn-3 w-100" data-bs-dismiss="modal">Batal</a>
                  </div>
                  <div class="col">
                    <a href="#" class="btn btn-danger btn-4 w-100" data-bs-dismiss="modal" @click="konfirmasiHapus">
                      Hapus
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </NuxtLayout>
</template>

<style scoped>
.cursor-pointer {
  cursor: pointer;
}
</style>