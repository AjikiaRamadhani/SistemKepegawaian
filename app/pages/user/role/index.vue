<script setup>
import { ref, onMounted, computed } from 'vue';
import { IconSearch } from "@tabler/icons-vue";

definePageMeta({
  title: "Manajemen Role",
});

useSeoMeta({
  title: "Manajemen Role",
});

const isLoading = ref(true);
const roleList = ref([]);
const search = ref('');

const fetchRoles = async () => {
  isLoading.value = true;
  try {
    const token = useCookie('auth_token');
    const response = await $fetch('http://localhost:5000/api/role', {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    roleList.value = response.data || [];
  } catch (error) {
    console.error('Gagal mengambil daftar role:', error);
  } finally {
    isLoading.value = false;
  }
};

const roleTersaring = computed(() => {
  if (!search.value.trim()) return roleList.value;
  const term = search.value.trim().toLowerCase();
  return roleList.value.filter(r => r.nama_role.toLowerCase().includes(term));
});

onMounted(() => {
  fetchRoles();
});
</script>

<template>
  <div class="card">
    <div class="card-header">
      <div class="d-flex gap-2 ms-auto">
        <div class="input-group" style="width: 220px">
          <input v-model="search" type="text" class="form-control" placeholder="Cari Role ..." />
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
            <th>Role</th>
            <th>Deskripsi</th>
            <th class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="isLoading">
            <td colspan="4" class="text-center py-4">Memuat data...</td>
          </tr>
          <tr v-else-if="roleTersaring.length === 0">
            <td colspan="4" class="text-center py-4">Tidak ada role yang cocok.</td>
          </tr>
          <tr v-else v-for="(item, index) in roleTersaring" :key="item.id">
            <td class="text-center">{{ index + 1 }}</td>
            <td>{{ item.nama_role }}</td>
            <td>{{ item.deskripsi }}</td>
            <td class="text-center">
              <NuxtLink :to="`/user/role/hak-akses/${item.id}`" class="btn btn-sm btn-primary">
                Hak Akses
              </NuxtLink>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>