<template>
  <form @submit.prevent="simpanPengaturan" class="card shadow-sm mt-4">
    <div class="card-header bg-primary text-white">
      <h3 class="card-title mb-0">Pengaturan Tunjangan Transport</h3>
    </div>
    
    <div class="card-body">
      <div class="row g-4">
        
        <div class="col-md-6">
          <label class="form-label required">Tarif</label>
          <input 
            type="text" 
            class="form-control text-end fw-bold text-primary" 
            v-model="displayTarif" 
            @input="onTarifInput"
            placeholder="Rp 0"
            required 
          />
        </div>

        <div class="col-md-6">
          <label class="form-label required">Berlaku Mulai</label>
          <input 
            type="date" 
            class="form-control" 
            v-model="form.berlaku_mulai"
            required 
          />
        </div>

        <div class="col-md-6">
          <label class="form-label required">Minimum Kilometer</label>
          <div class="input-group">
            <input 
              type="number" 
              min="0" 
              class="form-control" 
              v-model="form.min_km"
              required 
            />
            <span class="input-group-text">km</span>
          </div>
        </div>

        <div class="col-md-6">
          <label class="form-label required">Maksimum Kilometer</label>
          <div class="input-group">
            <input 
              type="number" 
              min="1" 
              class="form-control" 
              v-model="form.max_km"
              required 
            />
            <span class="input-group-text">km</span>
          </div>
        </div>
        
      </div>
    </div>
    
    <div class="card-footer bg-light">
      <div class="d-flex gap-2 justify-content-end">
        <button type="button" class="btn btn-outline-primary" @click="navigateTo('/')">
          Kembali
        </button>
        <button type="submit" class="btn btn-primary px-4" :disabled="isLoading">
          {{ isLoading ? 'Menyimpan...' : 'Simpan' }}
        </button>
      </div>
    </div>
  </form>
</template>

<script setup>
const apiBase = useRuntimeConfig().public.apiBase;
import { ref, onMounted } from 'vue';

definePageMeta({ title: "Setting Tunjangan Transport" });

const isLoading = ref(false);

// State Form (Disesuaikan dengan kolom database 'base_fare')
const form = ref({
  base_fare: '', 
  berlaku_mulai: '',
  min_km: '',
  max_km: ''
});

// State untuk tampilan di layar (contoh: Rp 5.000)
const displayTarif = ref('');

// ==========================================
// 1. KEAMANAN RBAC (HANYA ADMIN HRD)
// ==========================================
onMounted(() => {
  const userData = useCookie('user_data');
  if (userData.value) {
    const parsed = typeof userData.value === 'string' ? JSON.parse(userData.value) : userData.value;
    const roleStr = String(parsed.id_role || parsed.role).toLowerCase();

    if (roleStr !== '3' && !roleStr.includes('admin')) {
      alert("Akses Ditolak! Halaman ini hanya untuk Admin HRD.");
      navigateTo('/dashboard');
      return;
    }
  }
  
  loadDataSetting();
});

// ==========================================
// 2. MENGAMBIL DATA AWAL DARI BACKEND
// ==========================================
const loadDataSetting = async () => {
  try {
    const token = useCookie('auth_token');
    const response = await $fetch(`${apiBase}/api/tunjangan/setting`, {
      headers: { Authorization: `Bearer ${token.value}` }
    });

    if (response && response.data) {
      const data = response.data;
      
      form.value.base_fare = data.base_fare;
      form.value.min_km = data.min_km;
      form.value.max_km = data.max_km;
      
      if (data.berlaku_mulai) {
        form.value.berlaku_mulai = data.berlaku_mulai.split('T')[0];
      }

      displayTarif.value = formatRupiah(data.base_fare);
    }
  } catch (error) {
    console.error('Gagal memuat pengaturan awal:', error);
  }
};

// ==========================================
// 3. LOGIKA AUTO FORMAT RUPIAH
// ==========================================
const formatRupiah = (angka) => {
  if (!angka) return '';
  let numberString = angka.toString().replace(/[^,\d]/g, '');
  let split = numberString.split(',');
  let sisa = split[0].length % 3;
  let rupiah = split[0].substr(0, sisa);
  let ribuan = split[0].substr(sisa).match(/\d{3}/gi);

  if (ribuan) {
    let separator = sisa ? '.' : '';
    rupiah += separator + ribuan.join('.');
  }
  return rupiah ? 'Rp ' + rupiah : '';
};

const onTarifInput = (event) => {
  // Hanya ambil angka (memaksa sifat "number only" pada input text)
  let val = event.target.value.replace(/[^0-9]/g, '');
  form.value.base_fare = val;
  displayTarif.value = formatRupiah(val);
};

// ==========================================
// 4. SUBMIT PENYIMPANAN
// ==========================================
const simpanPengaturan = async () => {
  isLoading.value = true;
  try {
    const payload = {
      base_fare: Number(form.value.base_fare),
      berlaku_mulai: form.value.berlaku_mulai,
      min_km: Number(form.value.min_km),
      max_km: Number(form.value.max_km)
    };

    const token = useCookie('auth_token');
    await $fetch(`${apiBase}/api/tunjangan/setting`, {
      method: 'PUT',
      headers: { Authorization: `Bearer ${token.value}` },
      body: payload
    });

    alert("Berhasil! Pengaturan tarif tunjangan telah diperbarui.");
  } catch (error) {
    console.error(error);
    alert("Gagal menyimpan data.");
  } finally {
    isLoading.value = false;
  }
};
</script>

<style scoped>
.required::after {
  content: " *";
  color: red;
}
</style>