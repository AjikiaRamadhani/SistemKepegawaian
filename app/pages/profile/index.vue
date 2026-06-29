<script setup>
import { ref, onMounted } from 'vue';
import { formatDateTimeID } from "~/utils/formatDate.js";

definePageMeta({
  title: "My Profile",
});

useSeoMeta({
  title: "My Profile",
});

const isLoading = ref(true);
const profile = ref(null);
const errorMessage = ref('');

const fetchProfile = async () => {
  isLoading.value = true;
  try {
    const token = useCookie('auth_token');
    const response = await $fetch('http://localhost:5000/api/profile', {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    profile.value = response.data;
  } catch (error) {
    console.error('Gagal mengambil profil:', error);
    errorMessage.value = 'Gagal memuat data profil.';
  } finally {
    isLoading.value = false;
  }
};

// === FORM UPDATE ===
const emailForm = ref('');
const isSubmittingEmail = ref(false);
const emailMessage = ref('');
const emailError = ref(false);

const submitEmail = async () => {
  isSubmittingEmail.value = true;
  emailMessage.value = '';
  try {
    const token = useCookie('auth_token');
    await $fetch('http://localhost:5000/api/profile', {
      method: 'PUT',
      headers: { Authorization: `Bearer ${token.value}` },
      body: { email: emailForm.value }
    });
    emailError.value = false;
    emailMessage.value = 'Email berhasil diperbarui.';
    await fetchProfile();
  } catch (error) {
    emailError.value = true;
    emailMessage.value = error?.data?.message || 'Gagal memperbarui email.';
  } finally {
    isSubmittingEmail.value = false;
  }
};

const passwordForm = ref({ current_password: '', new_password: '', confirm_password: '' });
const isSubmittingPassword = ref(false);
const passwordMessage = ref('');
const passwordError = ref(false);

// Validasi real-time sesuai aturan soal: minimal 8 karakter, tanpa spasi,
// minimal 1 huruf besar, 1 huruf kecil, 1 karakter khusus
const passwordRuleValid = (pwd) => /^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>])(?!.*\s).{8,}$/.test(pwd);

const submitPassword = async () => {
  passwordMessage.value = '';

  if (!passwordForm.value.current_password || !passwordForm.value.new_password) {
    passwordError.value = true;
    passwordMessage.value = 'Password saat ini dan password baru wajib diisi.';
    return;
  }
  if (!passwordRuleValid(passwordForm.value.new_password)) {
    passwordError.value = true;
    passwordMessage.value = 'Password baru minimal 8 karakter, tanpa spasi, harus ada huruf besar, huruf kecil, dan karakter khusus.';
    return;
  }
  if (passwordForm.value.new_password !== passwordForm.value.confirm_password) {
    passwordError.value = true;
    passwordMessage.value = 'Konfirmasi password baru tidak cocok.';
    return;
  }

  isSubmittingPassword.value = true;
  try {
    const token = useCookie('auth_token');
    await $fetch('http://localhost:5000/api/profile', {
      method: 'PUT',
      headers: { Authorization: `Bearer ${token.value}` },
      body: {
        current_password: passwordForm.value.current_password,
        new_password: passwordForm.value.new_password
      }
    });
    passwordError.value = false;
    passwordMessage.value = 'Password berhasil diperbarui.';
    passwordForm.value = { current_password: '', new_password: '', confirm_password: '' };
  } catch (error) {
    passwordError.value = true;
    passwordMessage.value = error?.data?.message || 'Gagal memperbarui password.';
  } finally {
    isSubmittingPassword.value = false;
  }
};

onMounted(() => {
  fetchProfile();
});
</script>

<template>
  <div v-if="isLoading" class="text-center py-5">Memuat profil...</div>

  <div v-else-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>

  <div v-else-if="profile" class="row g-3">
    <div class="col-12">
      <NuxtLink to="/" class="btn btn-outline-primary">
        <i class="bi bi-arrow-left me-2"></i>Kembali ke Dashboard
      </NuxtLink>
    </div>

    <!-- INFO PROFIL (Read Only) -->
    <div class="col-lg-6">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Informasi Akun</h3>
        </div>
        <div class="card-body">
          <div class="row g-4">
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Nama</div>
                <div class="datagrid-content">{{ profile.nama || '-' }}</div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Username</div>
                <div class="datagrid-content">{{ profile.username }}</div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Email</div>
                <div class="datagrid-content">{{ profile.email || '-' }}</div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Role</div>
                <div class="datagrid-content">{{ profile.nama_role || '-' }}</div>
              </div>
            </div>
            <div class="col-md-6" v-if="profile.nip">
              <div class="datagrid-item">
                <div class="datagrid-title">NIP</div>
                <div class="datagrid-content">{{ profile.nip }}</div>
              </div>
            </div>
            <div class="col-md-6" v-if="profile.nama_jabatan">
              <div class="datagrid-item">
                <div class="datagrid-title">Jabatan</div>
                <div class="datagrid-content">{{ profile.nama_jabatan }}</div>
              </div>
            </div>
            <div class="col-md-6" v-if="profile.nama_departemen">
              <div class="datagrid-item">
                <div class="datagrid-title">Departemen</div>
                <div class="datagrid-content">{{ profile.nama_departemen }}</div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Login Terakhir</div>
                <div class="datagrid-content">
                  {{ profile.last_login ? formatDateTimeID(profile.last_login) : '-' }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- FORM UPDATE -->
    <div class="col-lg-6">
      <!-- UPDATE EMAIL -->
      <div class="card mb-3">
        <div class="card-header">
          <h3 class="card-title">Ubah Email</h3>
        </div>
        <div class="card-body">
          <div v-if="emailMessage" :class="emailError ? 'alert alert-danger' : 'alert alert-success'">
            {{ emailMessage }}
          </div>
          <div class="mb-3">
            <label class="form-label">Email Baru</label>
            <input
              type="email"
              class="form-control"
              v-model="emailForm"
              :placeholder="profile.email"
            />
          </div>
          <button class="btn btn-primary" :disabled="isSubmittingEmail || !emailForm" @click="submitEmail">
            {{ isSubmittingEmail ? 'Menyimpan...' : 'Simpan Email' }}
          </button>
        </div>
      </div>

      <!-- UPDATE PASSWORD -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Ubah Password</h3>
        </div>
        <div class="card-body">
          <div v-if="passwordMessage" :class="passwordError ? 'alert alert-danger' : 'alert alert-success'">
            {{ passwordMessage }}
          </div>
          <div class="mb-3">
            <label class="form-label required">Password Saat Ini</label>
            <input type="password" class="form-control" v-model="passwordForm.current_password" />
          </div>
          <div class="mb-3">
            <label class="form-label required">Password Baru</label>
            <input type="password" class="form-control" v-model="passwordForm.new_password" />
            <div class="form-text">
              Minimal 8 karakter, tanpa spasi, harus ada huruf besar, huruf kecil, dan karakter khusus.
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label required">Konfirmasi Password Baru</label>
            <input type="password" class="form-control" v-model="passwordForm.confirm_password" />
          </div>
          <button class="btn btn-primary" :disabled="isSubmittingPassword" @click="submitPassword">
            {{ isSubmittingPassword ? 'Menyimpan...' : 'Simpan Password' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>