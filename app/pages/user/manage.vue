<script setup>
const apiBase = useRuntimeConfig().public.apiBase;
import { ref, reactive, onMounted, computed } from 'vue';
import { IconPencil, IconPlus, IconSearch, IconTrash, IconToggleLeft, IconToggleRight } from "@tabler/icons-vue";

definePageMeta({
  title: "Manajemen User",
  layout: false,
});

useSeoMeta({
  title: "Manajemen User",
});

const isLoading = ref(true);
const userList = ref([]);
const roleOptions = ref([]); // dari /api/user/roles
const currentUserId = ref(null); // id user yang sedang login (untuk cegah self-delete/disable di UI)

// === FILTER STATE ===
const filters = reactive({
  search: '',
  id_role: '',
  status: '',
});

let searchDebounceTimer = null;
const onSearchInput = (value) => {
  filters.search = value;
  clearTimeout(searchDebounceTimer);
  searchDebounceTimer = setTimeout(() => fetchUsers(), 400);
};

// === FETCH DATA ===
const fetchUsers = async () => {
  isLoading.value = true;
  try {
    const token = useCookie('auth_token');
    const query = {};
    if (filters.search) query.search = filters.search;
    if (filters.id_role) query.id_role = filters.id_role;
    if (filters.status) query.status = filters.status;

    const response = await $fetch(`${apiBase}/api/user`, {
      headers: { Authorization: `Bearer ${token.value}` },
      query
    });
    userList.value = response.data || [];
  } catch (error) {
    console.error('Gagal mengambil daftar user:', error);
  } finally {
    isLoading.value = false;
  }
};

const fetchRoles = async () => {
  try {
    const token = useCookie('auth_token');
    const response = await $fetch(`${apiBase}/api/user/roles`, {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    roleOptions.value = response.data || [];
  } catch (error) {
    console.error('Gagal mengambil daftar role:', error);
  }
};

// === MODAL TAMBAH USER ===
const showAddModal = ref(false);
const addForm = reactive({
  namaSearch: '',     // teks yang diketik user di kolom autosuggest
  id_pegawai: null,   // terisi setelah user memilih dari hasil autosuggest
  nama_pegawai: '',   // nama yang ditampilkan setelah dipilih
  username: '',
  id_role: '',
});
const pegawaiSuggestions = ref([]);
const showSuggestions = ref(false);
const isSearchingPegawai = ref(false);
const addErrorMessage = ref('');
const isSubmittingAdd = ref(false);

let suggestDebounceTimer = null;
const onNamaSearchInput = (value) => {
  addForm.namaSearch = value;
  addForm.id_pegawai = null; // reset pilihan kalau user mengetik ulang
  clearTimeout(suggestDebounceTimer);

  if (value.trim().length < 2) {
    pegawaiSuggestions.value = [];
    showSuggestions.value = false;
    return;
  }

  suggestDebounceTimer = setTimeout(async () => {
    isSearchingPegawai.value = true;
    try {
      const token = useCookie('auth_token');
      const response = await $fetch(`${apiBase}/api/user/pegawai-suggest`, {
        headers: { Authorization: `Bearer ${token.value}` },
        query: { q: value.trim() }
      });
      pegawaiSuggestions.value = response.data || [];
      showSuggestions.value = true;
    } catch (error) {
      console.error('Gagal mengambil saran pegawai:', error);
    } finally {
      isSearchingPegawai.value = false;
    }
  }, 350);
};

const pilihPegawai = (pegawai) => {
  addForm.id_pegawai = pegawai.id;
  addForm.namaSearch = pegawai.nama_pegawai;
  addForm.nama_pegawai = pegawai.nama_pegawai;
  showSuggestions.value = false;
};

// Validasi username real-time (sesuai soal: min 6 char, huruf kecil & angka, tanpa spasi)
const usernameValid = computed(() => /^[a-z0-9]{6,}$/.test(addForm.username));

const resetAddForm = () => {
  addForm.namaSearch = '';
  addForm.id_pegawai = null;
  addForm.nama_pegawai = '';
  addForm.username = '';
  addForm.id_role = '';
  pegawaiSuggestions.value = [];
  showSuggestions.value = false;
  addErrorMessage.value = '';
};

const openAddModal = () => {
  resetAddForm();
  showAddModal.value = true;
};

// === MODAL HASIL (menampilkan password yang digenerate, hanya muncul sekali) ===
const showResultModal = ref(false);
const resultData = ref(null); // {username, generated_password}

const submitAddUser = async () => {
  addErrorMessage.value = '';

  if (!addForm.id_pegawai) {
    addErrorMessage.value = 'Pilih nama pegawai dari daftar saran yang muncul. Tidak boleh mengetik nama secara bebas.';
    return;
  }
  if (!usernameValid.value) {
    addErrorMessage.value = 'Username tidak valid. Minimal 6 karakter, huruf kecil dan angka saja, tanpa spasi.';
    return;
  }
  if (!addForm.id_role) {
    addErrorMessage.value = 'Pilih role untuk user ini.';
    return;
  }

  isSubmittingAdd.value = true;
  try {
    const token = useCookie('auth_token');
    const response = await $fetch(`${apiBase}/api/user`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token.value}` },
      body: {
        id_pegawai: addForm.id_pegawai,
        username: addForm.username,
        id_role: parseInt(addForm.id_role, 10)
      }
    });

    showAddModal.value = false;
    resultData.value = response.data;
    showResultModal.value = true;

    await fetchUsers();
  } catch (error) {
    console.error('Gagal membuat user:', error);
    addErrorMessage.value = error?.data?.message || 'Gagal membuat user. Silakan coba lagi.';
  } finally {
    isSubmittingAdd.value = false;
  }
};

// === EDIT ROLE / STATUS ===
const showEditModal = ref(false);
const editForm = reactive({ id: null, nama: '', id_role: '', disabled: 0 });
const editErrorMessage = ref('');
const isSubmittingEdit = ref(false);

const openEditModal = (user) => {
  editForm.id = user.id;
  editForm.nama = user.nama;
  editForm.id_role = user.id_role;
  editForm.disabled = user.disabled;
  editErrorMessage.value = '';
  showEditModal.value = true;
};

const submitEditUser = async () => {
  isSubmittingEdit.value = true;
  editErrorMessage.value = '';
  try {
    const token = useCookie('auth_token');
    await $fetch(`${apiBase}/api/user/${editForm.id}`, {
      method: 'PUT',
      headers: { Authorization: `Bearer ${token.value}` },
      body: {
        id_role: parseInt(editForm.id_role, 10),
        disabled: editForm.disabled
      }
    });
    showEditModal.value = false;
    await fetchUsers();
  } catch (error) {
    console.error('Gagal memperbarui user:', error);
    editErrorMessage.value = error?.data?.message || 'Gagal memperbarui user.';
  } finally {
    isSubmittingEdit.value = false;
  }
};

// === TOGGLE STATUS CEPAT ===
const toggleStatus = async (user) => {
  if (user.id === currentUserId.value) {
    alert('Anda tidak dapat mengubah status akun Anda sendiri.');
    return;
  }
  try {
    const token = useCookie('auth_token');
    await $fetch(`${apiBase}/api/user/${user.id}/toggle-status`, {
      method: 'PATCH',
      headers: { Authorization: `Bearer ${token.value}` }
    });
    await fetchUsers();
  } catch (error) {
    console.error('Gagal mengubah status:', error);
    alert(error?.data?.message || 'Gagal mengubah status user.');
  }
};

// === HAPUS USER ===
const userToDelete = ref(null);

const confirmDelete = (user) => {
  if (user.id === currentUserId.value) {
    alert('Anda tidak dapat menghapus akun Anda sendiri.');
    return;
  }
  userToDelete.value = user;
};

const executeDelete = async () => {
  if (!userToDelete.value) return;
  try {
    const token = useCookie('auth_token');
    await $fetch(`${apiBase}/api/user/${userToDelete.value.id}`, {
      method: 'DELETE',
      headers: { Authorization: `Bearer ${token.value}` }
    });
    userToDelete.value = null;
    await fetchUsers();
  } catch (error) {
    console.error('Gagal menghapus user:', error);
    alert(error?.data?.message || 'Gagal menghapus user.');
  }
};

onMounted(() => {
  const userData = useCookie('user_data');
  if (userData.value) {
    const parsed = typeof userData.value === 'string' ? JSON.parse(userData.value) : userData.value;
    currentUserId.value = parsed.id;
  }
  fetchRoles();
  fetchUsers();
});
</script>

<template>
  <NuxtLayout name="default">
    <template #actions>
      <button class="btn btn-primary" @click="openAddModal">
        <IconPlus stroke="{3}" size="20" />Tambah
      </button>
    </template>
    <div class="card">
      <div class="card-header">
        <div class="d-flex gap-2 ms-auto">
          <select v-model="filters.id_role" class="form-select" style="width: 160px" @change="fetchUsers">
            <option value="">Semua Role</option>
            <option v-for="r in roleOptions" :key="r.id" :value="r.id">{{ r.nama_role }}</option>
          </select>

          <select v-model="filters.status" class="form-select" style="width: 150px" @change="fetchUsers">
            <option value="">Semua Status</option>
            <option value="aktif">Aktif</option>
            <option value="nonaktif">Nonaktif</option>
          </select>

          <div class="input-group" style="width: 220px">
            <input
              type="text"
              class="form-control"
              placeholder="Cari Nama/Username ..."
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
              <th width="15">Action</th>
              <th>Nama Pengguna</th>
              <th>Username</th>
              <th>Jabatan</th>
              <th>Departemen</th>
              <th>Role</th>
              <th class="text-center">Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="isLoading">
              <td colspan="8" class="text-center py-4">Memuat data...</td>
            </tr>
            <tr v-else-if="userList.length === 0">
              <td colspan="8" class="text-center py-4">Belum ada data user.</td>
            </tr>
            <tr v-else v-for="(item, index) in userList" :key="item.id">
              <td class="text-center">{{ index + 1 }}</td>
              <td class="text-nowrap">
                <div class="d-flex gap-2">
                  <a href="#" class="text-dark" @click.prevent="openEditModal(item)">
                    <span data-bs-toggle="tooltip" title="Edit">
                      <IconPencil stroke="{1}" size="20" />
                    </span>
                  </a>
                  <a
                    href="#"
                    class="text-dark"
                    :class="{ 'opacity-25': item.id === currentUserId }"
                    @click.prevent="toggleStatus(item)"
                    :title="item.id === currentUserId ? 'Tidak dapat mengubah status sendiri' : 'Toggle Status'"
                  >
                    <IconToggleRight v-if="!item.disabled" stroke="{1}" size="20" />
                    <IconToggleLeft v-else stroke="{1}" size="20" />
                  </a>
                  <a
                    href="#"
                    class="text-danger"
                    :class="{ 'opacity-25': item.id === currentUserId }"
                    @click.prevent="confirmDelete(item)"
                  >
                    <span data-bs-toggle="tooltip" title="Hapus">
                      <IconTrash stroke="{1}" size="20" />
                    </span>
                  </a>
                </div>
              </td>
              <td>{{ item.nama }}</td>
              <td>{{ item.username }}</td>
              <td>{{ item.nama_jabatan || '-' }}</td>
              <td>{{ item.nama_departemen || '-' }}</td>
              <td>{{ item.nama_role || '-' }}</td>
              <td class="text-center">
                <span class="badge" :class="!item.disabled ? 'bg-success text-white' : 'bg-secondary text-white'">
                  {{ !item.disabled ? 'Aktif' : 'Nonaktif' }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- MODAL TAMBAH USER -->
    <div class="modal modal-blur fade" :class="{ show: showAddModal }" :style="showAddModal ? 'display: block' : ''" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Form Manajemen User</h5>
            <button type="button" class="btn-close" @click="showAddModal = false"></button>
          </div>
          <div class="modal-body">
            <div v-if="addErrorMessage" class="alert alert-danger">{{ addErrorMessage }}</div>

            <!-- AUTOSUGGEST NAMA PEGAWAI -->
            <div class="mb-3 position-relative">
              <label class="form-label required">Nama Pegawai</label>
              <input
                type="text"
                class="form-control"
                placeholder="Ketik minimal 2 karakter..."
                :value="addForm.namaSearch"
                @input="onNamaSearchInput($event.target.value)"
                autocomplete="off"
              />
              <div v-if="showSuggestions && pegawaiSuggestions.length > 0" class="list-group position-absolute w-100 shadow" style="z-index: 1060; max-height: 200px; overflow-y: auto;">
                <button
                  v-for="p in pegawaiSuggestions"
                  :key="p.id"
                  type="button"
                  class="list-group-item list-group-item-action"
                  @click="pilihPegawai(p)"
                >
                  {{ p.nama_pegawai }} <span class="text-secondary small">({{ p.nip }})</span>
                </button>
              </div>
              <div v-else-if="showSuggestions && pegawaiSuggestions.length === 0 && !isSearchingPegawai" class="text-secondary small mt-1">
                Tidak ada pegawai yang cocok (atau pegawai sudah memiliki akun).
              </div>
              <div class="form-text">Pilih nama dari daftar yang muncul. Tidak bisa mengetik nama bebas.</div>
            </div>

            <!-- USERNAME -->
            <div class="mb-3">
              <label class="form-label required">Username</label>
              <input
                type="text"
                class="form-control"
                :class="{ 'is-invalid': addForm.username && !usernameValid }"
                v-model="addForm.username"
                placeholder="contoh: budisantoso"
              />
              <div class="form-text">Minimal 6 karakter, huruf kecil & angka saja, tanpa spasi.</div>
            </div>

            <!-- ROLE -->
            <div class="mb-3">
              <label class="form-label required">Role</label>
              <select v-model="addForm.id_role" class="form-select">
                <option value="" disabled>Pilih terlebih dahulu</option>
                <option v-for="r in roleOptions" :key="r.id" :value="r.id">{{ r.nama_role }}</option>
              </select>
            </div>

            <div class="form-text">
              Password akan digenerate otomatis oleh sistem setelah user dibuat.
            </div>
          </div>
          <div class="modal-footer">
            <div class="d-flex gap-2 ms-auto">
              <button type="button" class="btn" @click="showAddModal = false">Kembali</button>
              <button type="button" class="btn btn-primary" :disabled="isSubmittingAdd" @click="submitAddUser">
                {{ isSubmittingAdd ? 'Menyimpan...' : 'Simpan' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showAddModal" class="modal-backdrop fade show"></div>

    <!-- MODAL HASIL (PASSWORD DIGENERATE) -->
    <div class="modal modal-blur fade" :class="{ show: showResultModal }" :style="showResultModal ? 'display: block' : ''" tabindex="-1">
      <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-status bg-success"></div>
          <div class="modal-body text-center py-4">
            <h3 class="mb-3">User Berhasil Dibuat</h3>
            <div class="mb-2">
              <div class="text-secondary small">Username</div>
              <div class="fw-bold">{{ resultData?.username }}</div>
            </div>
            <div class="mb-2">
              <div class="text-secondary small">Password (catat sekarang, tidak akan ditampilkan lagi)</div>
              <div class="fw-bold font-monospace">{{ resultData?.generated_password }}</div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary w-100" @click="showResultModal = false">Tutup</button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showResultModal" class="modal-backdrop fade show"></div>

    <!-- MODAL EDIT ROLE/STATUS -->
    <div class="modal modal-blur fade" :class="{ show: showEditModal }" :style="showEditModal ? 'display: block' : ''" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Edit User: {{ editForm.nama }}</h5>
            <button type="button" class="btn-close" @click="showEditModal = false"></button>
          </div>
          <div class="modal-body">
            <div v-if="editErrorMessage" class="alert alert-danger">{{ editErrorMessage }}</div>
            <div class="mb-3">
              <label class="form-label">Role</label>
              <select v-model="editForm.id_role" class="form-select">
                <option v-for="r in roleOptions" :key="r.id" :value="r.id">{{ r.nama_role }}</option>
              </select>
            </div>
            <div>
              <label class="form-check">
                <input class="form-check-input" type="checkbox" :checked="!editForm.disabled" @change="editForm.disabled = editForm.disabled ? 0 : 1" />
                <span class="form-check-label">Aktif</span>
              </label>
            </div>
          </div>
          <div class="modal-footer">
            <div class="d-flex gap-2 ms-auto">
              <button type="button" class="btn" @click="showEditModal = false">Kembali</button>
              <button type="button" class="btn btn-primary" :disabled="isSubmittingEdit" @click="submitEditUser">
                {{ isSubmittingEdit ? 'Menyimpan...' : 'Simpan' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showEditModal" class="modal-backdrop fade show"></div>

    <!-- MODAL HAPUS -->
    <div class="modal modal-blur fade" :class="{ show: !!userToDelete }" :style="userToDelete ? 'display: block' : ''" tabindex="-1">
      <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
          <button type="button" class="btn-close" @click="userToDelete = null"></button>
          <div class="modal-status bg-danger"></div>
          <div class="modal-body text-center py-4">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon mb-2 text-danger icon-lg">
              <path d="M12 9v4"></path>
              <path d="M10.363 3.591l-8.106 13.534a1.914 1.914 0 0 0 1.636 2.871h16.214a1.914 1.914 0 0 0 1.636 -2.87l-8.106 -13.536a1.914 1.914 0 0 0 -3.274 0z"></path>
              <path d="M12 16h.01"></path>
            </svg>
            <h3 class="mb-1">Hapus User</h3>
            <div class="text-secondary">Apakah kamu ingin menghapus user "{{ userToDelete?.nama }}"?</div>
          </div>
          <div class="modal-footer">
            <div class="w-100">
              <div class="row">
                <div class="col">
                  <button type="button" class="btn btn-3 w-100" @click="userToDelete = null">Batal</button>
                </div>
                <div class="col">
                  <button type="button" class="btn btn-danger btn-4 w-100" @click="executeDelete">Hapus</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-if="userToDelete" class="modal-backdrop fade show"></div>
  </NuxtLayout>
</template>