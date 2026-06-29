<template>
  <div class="login-container">
    <form @submit.prevent="handleLogin">
      
      <div class="mb-3">
        <label class="form-label required">Username / Email / No. HP</label>
        <input 
          type="text" 
          class="form-control" 
          v-model="form.identifier" 
          placeholder="Masukkan username, email, atau No. HP" 
          required 
        />
      </div>
      
      <div class="mb-3">
        <label class="form-label required">Password</label>
        <input 
          type="password" 
          class="form-control" 
          v-model="form.password" 
          required 
        />
      </div>

      <div class="mb-3">
        <label class="form-label required">Captcha</label>
        <div class="d-flex align-items-center gap-3 mb-2">
          <div 
            class="captcha-box fs-3 fw-bold text-decoration-line-through fst-italic px-4 py-2 bg-light border text-primary user-select-none"
            style="letter-spacing: 5px;"
          >
            {{ currentCaptcha }}
          </div>
          
          <button type="button" class="btn btn-sm btn-outline-secondary" @click="generateCaptcha" title="Ganti Captcha">
            <IconRefresh size="20" /> Refresh
          </button>
        </div>
        
        <input 
          type="text" 
          class="form-control" 
          v-model="form.captchaInput" 
          placeholder="Ketik kode unik di atas" 
          required 
        />
        <small v-if="captchaError" class="text-danger mt-1">{{ captchaError }}</small>
      </div>

      <div class="mb-4 form-check">
        <input 
          type="checkbox" 
          class="form-check-input cursor-pointer" 
          id="rememberMe" 
          v-model="form.rememberMe"
        >
        <label class="form-check-label cursor-pointer user-select-none" for="rememberMe">
          Remember me (Sesi login lebih lama)
        </label>
      </div>

      <button type="submit" class="btn btn-primary w-100" :disabled="isLoading">
        {{ isLoading ? 'Memproses...' : 'Login' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { IconRefresh } from "@tabler/icons-vue";

const isLoading = ref(false);
const currentCaptcha = ref('');
const captchaError = ref('');

// === PENAMBAHAN STATE REMEMBER ME ===
const form = ref({
  identifier: '', 
  password: '',
  captchaInput: '',
  rememberMe: false // Default-nya tidak dicentang (sesi 3 menit)
});

// Fungsi Membuat Teks Captcha Acak (6 Karakter)
const generateCaptcha = () => {
  const chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  let captcha = '';
  for (let i = 0; i < 6; i++) {
    captcha += chars[Math.floor(Math.random() * chars.length)];
  }
  currentCaptcha.value = captcha;
  form.value.captchaInput = ''; 
  captchaError.value = '';      
};

onMounted(() => {
  generateCaptcha();
});

// Fungsi Submit Login
const handleLogin = async () => {
  // 1. VALIDASI CAPTCHA DI FRONTEND
  if (form.value.captchaInput !== currentCaptcha.value) {
    captchaError.value = 'Kode Captcha salah! Perhatikan huruf besar/kecil.';
    generateCaptcha(); 
    return;
  }

  // 2. JIKA CAPTCHA BENAR, KIRIM KE BACKEND
  isLoading.value = true;
  try {
    const response = await $fetch('/_/backend/api/auth/login', {
      method: 'POST',
      body: {
        identifier: form.value.identifier,
        password: form.value.password,
        captcha: form.value.captchaInput,      // Inputan user
        expectedCaptcha: currentCaptcha.value, // Kunci jawaban dari frontend
        rememberMe: form.value.rememberMe      // Status checkbox (true/false)
      }
    });

    // Simpan token/data ke cookie dengan aturan kedaluwarsa yang sesuai
    // Jika rememberMe true, cookie bertahan 1 hari. Jika false, hanya hitungan menit/sesi ditutup.
    const maxAgeOptions = form.value.rememberMe ? { maxAge: 60 * 60 * 24 } : {}; // 1 Hari dalam detik
    
    const tokenCookie = useCookie('auth_token', maxAgeOptions);
    const userCookie = useCookie('user_data', maxAgeOptions);
    
    tokenCookie.value = response.token;
    userCookie.value = JSON.stringify(response.user);

    alert("Login Berhasil!");
    navigateTo('/'); 

  } catch (error) {
    alert("Login Gagal: " + (error.response?._data?.message || "Terjadi kesalahan server"));
    generateCaptcha(); 
  } finally {
    isLoading.value = false;
  }
};
</script>

<style scoped>
.captcha-box {
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAI0lEQVQIW2NkQAP/gYARxIFViE8RzYVViEsRzYVVgM9rKAAAaJgJCf/1tP0AAAAASUVORK5CYII='); 
}
.required::after {
  content: " *";
  color: red;
}
.cursor-pointer {
  cursor: pointer;
}
</style>