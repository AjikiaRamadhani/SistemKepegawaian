<script setup>
const apiBase = useRuntimeConfig().public.apiBase;
import { ref, onMounted } from 'vue';
import { IconCircleCheckFilled, IconXboxXFilled } from "@tabler/icons-vue";

definePageMeta({
  title: "Hak Akses",
});

useSeoMeta({
  title: "Hak Akses",
});

const route = useRoute();
const roleId = route.params.id;

const isLoading = ref(true);
const roleInfo = ref(null);
const permissions = ref([]);

const fetchDetail = async () => {
  isLoading.value = true;
  try {
    const token = useCookie('auth_token');
    const response = await $fetch(`${apiBase}/api/role/${roleId}`, {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    roleInfo.value = response.data.role;
    permissions.value = response.data.permissions || [];
  } catch (error) {
    console.error('Gagal mengambil detail hak akses:', error);
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  fetchDetail();
});
</script>

<template>
  <div>
    <div class="card mb-3">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-4 col-lg-3">
            <label class="form-label">Nama Role</label>
            <input type="text" class="form-control" :value="roleInfo?.nama_role || ''" readonly disabled />
          </div>
          <div class="col-md-8 col-lg-6">
            <label class="form-label">Deskripsi</label>
            <textarea class="form-control" readonly disabled rows="1">{{ permissions.map(p => p.modul_fitur).join(', ') }}</textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="table-responsive card-body p-0">
        <table class="table table-vcenter">
          <thead>
            <tr>
              <th width="5">No</th>
              <th>Modul/Fitur</th>
              <th class="text-center">Akses</th>
              <th class="text-center">Create</th>
              <th>Read</th>
              <th>Update</th>
              <th>Delete</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="isLoading">
              <td colspan="7" class="text-center py-4">Memuat data...</td>
            </tr>
            <tr v-else-if="permissions.length === 0">
              <td colspan="7" class="text-center py-4">Role ini belum memiliki hak akses apapun.</td>
            </tr>
            <tr v-else v-for="(item, index) in permissions" :key="item.modul_fitur">
              <td class="text-center">{{ index + 1 }}</td>
              <td>{{ item.modul_fitur }}</td>
              <td class="text-center">
                <IconCircleCheckFilled v-if="item.akses" class="text-green" />
                <IconXboxXFilled v-else class="text-red" />
              </td>
              <td class="text-center">
                <IconCircleCheckFilled v-if="item.create" class="text-green" />
                <IconXboxXFilled v-else class="text-red" />
              </td>
              <td>{{ item.read }}</td>
              <td>{{ item.update }}</td>
              <td>{{ item.delete }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>