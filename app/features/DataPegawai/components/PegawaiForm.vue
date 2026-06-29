<template>
  <div>
    <form @submit.prevent="submitData">
      <div class="row g-3">
        <div class="col-lg-6">
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">{{ isEditMode ? 'Edit Data Diri' : 'Data Diri' }}</h3>
            </div>
            <div class="card-body">
              <div class="row g-4">
                <div class="col-12">
                  <div class="row align-items-center">
                    <div class="col-auto">
                      <img
                        src="/images/pegawai/ahmad.jpg"
                        alt=""
                        class="foto-ptofil"
                      />
                      <label
                        for="unggah-foto"
                        class="form-label text-primary text-center cursor-pointer mt-2 d-block"
                        >Ubah Foto</label
                      >
                      <input id="unggah-foto" type="file" hidden />
                    </div>

                    <div class="col">
                      <div class="mb-4">
                        <label for="" class="form-label required">NIP</label>
                        <input type="text" class="form-control" v-model="form.nip" required />
                      </div>

                      <div>
                        <label for="" class="form-label required">Nama Lengkap</label>
                        <input type="text" class="form-control" v-model="form.nama_pegawai" required />
                      </div>
                    </div>
                  </div>
                </div>

                <div class="col-md-6">
                  <label for="" class="form-label required">Email</label>
                  <input type="email" class="form-control" v-model="form.email" required />
                </div>

                <div class="col-md-6">
                  <label for="" class="form-label required">Nomor HP</label>
                  <input type="text" class="form-control" v-model="form.nomor_hp" required />
                </div>

                <div class="col-md-12">
                  <label class="form-label required">Jenis Kelamin</label>
                  <select class="form-select" v-model="form.jenis_kelamin" required>
                    <option value="Pria">Pria</option>
                    <option value="Wanita">Wanita</option>
                  </select>
                </div>

                <div class="col-md-5">
                  <label for="" class="form-label">Tempat Lahir</label>
                  <input type="text" class="form-control" v-model="form.tempat_lahir" />
                </div>

                <div class="col-md-5">
                  <label for="" class="form-label">Tanggal Lahir</label>
                  <input type="date" class="form-control" v-model="form.tanggal_lahir" @change="hitungUsia" />
                </div>

                <div class="col-md-2">
                  <label for="" class="form-label">Usia</label>
                  <input type="number" min="0" class="form-control" v-model="form.usia" readonly />
                </div>

                <div class="col-12">
                  <div class="card">
                    <div class="card-body">
                      <label for="" class="form-label">Pendidikan</label>
                      <table class="table table-borderless align-middle">
                        <thead>
                          <tr>
                            <th class="py-0">Jenjang</th>
                            <th class="py-0">Nama Sekolah / Perguruan Tinggi</th>
                            <th class="py-0">Tahun Lulus</th>
                            <th class="py-0"></th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(p, index) in form.pendidikan" :key="index">
                            <td>
                              <input type="text" class="form-control" v-model="p.tingkat" placeholder="Misal: S1" required />
                            </td>
                            <td>
                              <input type="text" class="form-control" v-model="p.sekolah" required />
                            </td>
                            <td>
                              <input type="number" class="form-control" v-model="p.tahun" required />
                            </td>
                            <td>
                              <IconXboxXFilled class="text-red cursor-pointer" @click="hapusPendidikan(index)" />
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <div class="text-center">
                        <button type="button" class="btn btn-primary btn-sm" @click="tambahPendidikan">TAMBAH DATA</button>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="col-12">
                  <label for="" class="form-label">Alamat Lengkap</label>
                  <textarea name="" id="" class="form-control" rows="3" v-model="form.alamat_lengkap"></textarea>
                </div>

                <div class="col-md-4">
                  <label for="" class="form-label required">Provinsi</label>
                  <select class="form-select" v-model="selectedProvinsi" @change="fetchKabupaten" required>
                    <option value="" disabled>Pilih Provinsi</option>
                    <option v-for="prov in listProvinsi" :key="prov.id" :value="prov.id">
                      {{ prov.name }}
                    </option>
                  </select>
                </div>

                <div class="col-md-4">
                  <label for="" class="form-label required">Kabupaten/Kota</label>
                  <select class="form-select" v-model="selectedKabupaten" @change="fetchKecamatan" :disabled="!selectedProvinsi" required>
                    <option value="" disabled>Pilih Kabupaten</option>
                    <option v-for="kab in listKabupaten" :key="kab.id" :value="kab.id">
                      {{ kab.name }}
                    </option>
                  </select>
                </div>

                <div class="col-md-4">
                  <label for="" class="form-label required">Kecamatan</label>
                  <select class="form-select" v-model="selectedKecamatan" :disabled="!selectedKabupaten" required>
                    <option value="" disabled>Pilih Kecamatan</option>
                    <option v-for="kec in listKecamatan" :key="kec.id" :value="kec.id">
                      {{ kec.name }}
                    </option>
                  </select>
                </div>

                <div class="col-md-4">
                  <div class="form-label">Status Pernikahan</div>
                  <div>
                    <label class="form-check">
                      <input class="form-check-input" type="radio" value="tidak kawin" v-model="form.status_kawin" />
                      <span class="form-check-label">Belum Menikah</span>
                    </label>
                    <label class="form-check">
                      <input class="form-check-input" type="radio" value="kawin" v-model="form.status_kawin" />
                      <span class="form-check-label">Menikah</span>
                    </label>
                  </div>
                </div>

                <div class="col-md-4">
                  <label for="" class="form-label">Jumlah Anak</label>
                  <input type="number" min="0" class="form-control" v-model="form.jumlah_anak" />
                </div>

                <div class="col-md-4">
                  <label for="" class="form-label required">Jarak ke Kantor</label>
                  <div class="input-group">
                    <input type="number" min="0" class="form-control" v-model="form.jarak_rumah_kantor" required />
                    <span class="input-group-text">KM</span>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-6">
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Data Kepegawaian</h3>
            </div>
            <div class="card-body">
              <div class="row g-4">
                <div class="col-12">
                  <label for="" class="form-label">Tanggal Masuk</label>
                  <input type="date" class="form-control" v-model="form.tanggal_masuk" />
                </div>

                <div class="col-md-6">
                  <label for="" class="form-label required">Jabatan</label>
                  <select class="form-select" v-model="form.id_jabatan" required>
                    <option value="" disabled>Pilih jabatan</option>
                    <option value="1">Manager</option>
                    <option value="2">System Analist</option>
                    <option value="3">Akuntan</option>
                    <option value="4">Programmer</option>
                  </select>
                </div>

                <div class="col-md-6">
                  <label for="" class="form-label required">Departemen</label>
                  <select class="form-select" v-model="form.id_departemen" required>
                    <option value="" disabled>Pilih departemen</option>
                    <option value="1">Produksi</option>
                    <option value="2">Marketing</option>
                    <option value="3">Finance</option>
                  </select>
                </div>

                <div class="col-md-6">
                  <label class="form-label required">Status Kontrak</label>
                  <select class="form-select" v-model="form.status_kontrak" required>
                    <option value="PKWTT">PKWTT (Tetap)</option>
                    <option value="PKWT">PKWT (Kontrak)</option>
                    <option value="Magang">Magang</option>
                  </select>
                </div>

                <div class="col-md-6">
                  <label for="" class="form-label">Status Pegawai</label>
                  <label class="form-check form-switch form-switch-3 mt-2">
                    <input class="form-check-input" type="checkbox" v-model="form.status" true-value="Aktif" false-value="Nonaktif" />
                    <span class="form-check-label">{{ form.status }}</span>
                  </label>
                </div>
              </div>
            </div>
            
            <div class="card-footer d-flex">
              <div class="d-flex gap-2 ms-auto">
                <button type="button" class="btn btn-outline-primary" @click="goBack()" :disabled="isSubmitting">
                  Kembali
                </button>
                <button type="submit" class="btn btn-primary" :disabled="isSubmitting">
                  {{ isSubmitting ? 'Menyimpan...' : (isEditMode ? 'Simpan Perubahan' : 'Simpan Data') }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { IconXboxXFilled } from "@tabler/icons-vue";

const { goBack } = useGoBack(); 
const route = useRoute();

definePageMeta({
  title: "Form Pegawai",
});

useSeoMeta({
  title: "Form Pegawai",
});

const isSubmitting = ref(false);

// Deteksi Mode Edit
const editId = route.query.id; 
const isEditMode = computed(() => !!editId);

// State Form Sesuai 100% Struktur DB Kamu
const form = ref({
  nip: '',
  nama_pegawai: '',
  jenis_kelamin: 'Pria',
  email: '',
  nomor_hp: '',
  tempat_lahir: '',
  tanggal_lahir: '',
  usia: 0,
  kecamatan: '',
  kabupaten: '',
  provinsi: '',
  alamat_lengkap: '',
  jarak_rumah_kantor: 0,
  status_kawin: 'tidak kawin',
  jumlah_anak: 0,
  tanggal_masuk: '',
  id_jabatan: '',
  id_departemen: '',
  status_kontrak: 'PKWTT',
  status: 'Aktif',
  pendidikan: []
});

// State API Wilayah Indonesia
const listProvinsi = ref([]);
const listKabupaten = ref([]);
const listKecamatan = ref([]);
const selectedProvinsi = ref('');
const selectedKabupaten = ref('');
const selectedKecamatan = ref('');

// Fungsi Ambil Data Provinsi
const fetchProvinsi = async () => {
  try {
    listProvinsi.value = await $fetch('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json');
  } catch (err) {
    console.error('Gagal mengambil data Provinsi:', err);
  }
};

// Fungsi Ambil Data Kabupaten (Dipicu saat user memilih Provinsi secara manual)
const fetchKabupaten = async () => {
  selectedKabupaten.value = '';
  selectedKecamatan.value = '';
  listKecamatan.value = [];
  if (!selectedProvinsi.value) return;
  try {
    listKabupaten.value = await $fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${selectedProvinsi.value}.json`);
  } catch (err) {
    console.error('Gagal mengambil data Kabupaten:', err);
  }
};

// Fungsi Ambil Data Kecamatan (Dipicu saat user memilih Kabupaten secara manual)
const fetchKecamatan = async () => {
  selectedKecamatan.value = '';
  if (!selectedKabupaten.value) return;
  try {
    listKecamatan.value = await $fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/${selectedKabupaten.value}.json`);
  } catch (err) {
    console.error('Gagal mengambil data Kecamatan:', err);
  }
};

// Otomatisasi hitung usia dari tanggal lahir
const hitungUsia = () => {
  if (form.value.tanggal_lahir) {
    const hariIni = new Date();
    const tglLahir = new Date(form.value.tanggal_lahir);
    let umur = hariIni.getFullYear() - tglLahir.getFullYear();
    const m = hariIni.getMonth() - tglLahir.getMonth();
    if (m < 0 || (m === 0 && hariIni.getDate() < tglLahir.getDate())) {
      umur--;
    }
    form.value.usia = umur;
  }
};

const tambahPendidikan = () => {
  form.value.pendidikan.push({ tingkat: '', sekolah: '', tahun: '' });
};

const hapusPendidikan = (index) => {
  form.value.pendidikan.splice(index, 1);
};

// Fungsi Simpan Data (POST atau PUT)
const submitData = async () => {
  isSubmitting.value = true;
  try {
    const token = useCookie('auth_token');

    // Backend menyimpan nama wilayah sebagai teks (bukan ID Emsifa), jadi
    // kita konversi ID yang terpilih di dropdown menjadi nama sebelum kirim.
    const provinsiTerpilih = listProvinsi.value.find(p => p.id === selectedProvinsi.value);
    const kabupatenTerpilih = listKabupaten.value.find(k => k.id === selectedKabupaten.value);
    const kecamatanTerpilih = listKecamatan.value.find(k => k.id === selectedKecamatan.value);

    form.value.provinsi = provinsiTerpilih ? provinsiTerpilih.name : '';
    form.value.kabupaten = kabupatenTerpilih ? kabupatenTerpilih.name : '';
    form.value.kecamatan = kecamatanTerpilih ? kecamatanTerpilih.name : '';
    
    const url = isEditMode.value 
      ? `http://localhost:5000/api/pegawai/${editId}` 
      : 'http://localhost:5000/api/pegawai';
    const method = isEditMode.value ? 'PUT' : 'POST';

    await $fetch(url, {
      method: method,
      headers: { Authorization: `Bearer ${token.value}` },
      body: form.value
    });

    alert(isEditMode.value ? "Perubahan berhasil disimpan!" : "Data baru berhasil ditambahkan!");
    goBack();

  } catch (error) {
    console.error('Gagal:', error);
    alert("Gagal: " + (error.response?._data?.message || "Terjadi kesalahan"));
  } finally {
    isSubmitting.value = false;
  }
};

onMounted(async () => {
  // 1. RBAC (Keamanan)
  const userData = useCookie('user_data');
  if (userData.value) {
    const parsed = typeof userData.value === 'string' ? JSON.parse(userData.value) : userData.value;
    const role = parsed.id_role || parsed.role;
    
    if (role !== 3 && role !== 'Admin HRD') {
      alert("Akses Ditolak! Hanya Admin HRD yang bisa ke halaman ini.");
      goBack();
      return;
    }
  }

  // 2. Muat dasar Provinsi terlepas dari mode tambah atau edit
  await fetchProvinsi();

  // 3. JIKA MODE EDIT: Ambil data dan kunci otomatis dropdown wilayah wilayah
  if (isEditMode.value) {
    try {
      const token = useCookie('auth_token');
      // Ambil satu pegawai langsung berdasarkan ID (bukan fetch semua data lalu cari manual),
      // supaya tidak terdampak oleh pagination di endpoint daftar pegawai.
      const response = await $fetch(`http://localhost:5000/api/pegawai/${editId}`, {
        headers: { Authorization: `Bearer ${token.value}` }
      });

      const pegawai = response.data;
      
      if (pegawai) {
        form.value.nip = pegawai.nip || '';
        form.value.nama_pegawai = pegawai.nama_pegawai || '';
        form.value.jenis_kelamin = pegawai.jenis_kelamin || 'Pria';
        form.value.email = pegawai.email || '';
        form.value.nomor_hp = pegawai.nomor_hp || '';
        form.value.tempat_lahir = pegawai.tempat_lahir || '';
        form.value.tanggal_lahir = pegawai.tanggal_lahir ? pegawai.tanggal_lahir.split('T')[0] : '';
        form.value.alamat_lengkap = pegawai.alamat_lengkap || '';
        form.value.jarak_rumah_kantor = pegawai.jarak_rumah_kantor || 0;
        form.value.status_kawin = pegawai.status_kawin || 'tidak kawin';
        form.value.jumlah_anak = pegawai.jumlah_anak || 0;
        form.value.tanggal_masuk = pegawai.tanggal_masuk ? pegawai.tanggal_masuk.split('T')[0] : '';
        form.value.id_jabatan = pegawai.id_jabatan || '';
        form.value.id_departemen = pegawai.id_departemen || '';
        form.value.status_kontrak = pegawai.status_kontrak || 'PKWTT';
        form.value.status = pegawai.status || 'Aktif';
        
        hitungUsia();

        // === LOGIKA SINKRONISASI DROPDOWN WILAYAH NASIONAL ===
        // Database menyimpan nama wilayah (bukan ID Emsifa), jadi kita cari
        // ID yang cocok di setiap level dengan mencocokkan nama secara berurutan:
        // provinsi -> kabupaten -> kecamatan (karena tiap level butuh ID induk
        // untuk fetch ke API Emsifa).
        if (pegawai.provinsi) {
          const provinsiMatch = listProvinsi.value.find(p => p.name === pegawai.provinsi);
          if (provinsiMatch) {
            selectedProvinsi.value = provinsiMatch.id;
            listKabupaten.value = await $fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${provinsiMatch.id}.json`);

            if (pegawai.kabupaten) {
              const kabupatenMatch = listKabupaten.value.find(k => k.name === pegawai.kabupaten);
              if (kabupatenMatch) {
                selectedKabupaten.value = kabupatenMatch.id;
                listKecamatan.value = await $fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/${kabupatenMatch.id}.json`);

                if (pegawai.kecamatan) {
                  const kecamatanMatch = listKecamatan.value.find(k => k.name === pegawai.kecamatan);
                  if (kecamatanMatch) {
                    selectedKecamatan.value = kecamatanMatch.id;
                  }
                }
              }
            }
          }
        }

        if (pegawai.pendidikan && pegawai.pendidikan.length > 0) {
          form.value.pendidikan = pegawai.pendidikan;
        } else {
          form.value.pendidikan = [{ tingkat: '', sekolah: '', years: '' }];
        }
      }
    } catch (error) {
      console.error('Gagal memuat detail data edit:', error);
    }
  } else {
    if (form.value.pendidikan.length === 0) tambahPendidikan();
  }
});
</script>

<style scoped>
.foto-ptofil {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
}
.required::after {
  content: " *";
  color: red;
}
</style>