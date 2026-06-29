<script setup>
import { ref, onMounted } from 'vue';
import { IconUserCircle } from "@tabler/icons-vue";
import { formatDateID } from "~/utils/formatDate.js";

definePageMeta({
  title: "Detail Pegawai",
});

useSeoMeta({
  title: "Detail Pegawai",
});

const { goBack } = useGoBack();
const route = useRoute();

// Catatan: nama parameter folder adalah [nipp] (warisan dari prototype),
// tapi isinya sebenarnya adalah ID pegawai (sesuai link dari halaman list).
const pegawaiId = route.params.nipp;

const isLoading = ref(true);
const errorMessage = ref('');
const pegawai = ref(null);

const fetchDetail = async () => {
  isLoading.value = true;
  errorMessage.value = '';
  try {
    const token = useCookie('auth_token');
    const response = await $fetch(`http://localhost:5000/api/pegawai/${pegawaiId}`, {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    pegawai.value = response.data;
  } catch (error) {
    console.error('Gagal mengambil detail pegawai:', error);
    if (error?.response?.status === 404 || error?.statusCode === 404) {
      errorMessage.value = 'Data pegawai tidak ditemukan.';
    } else {
      errorMessage.value = 'Gagal memuat data pegawai. Silakan coba lagi.';
    }
  } finally {
    isLoading.value = false;
  }
};

// Helper: hitung usia dari tanggal lahir jika field usia di DB kosong
const hitungUsia = (tanggalLahir) => {
  if (!tanggalLahir) return null;
  const lahir = new Date(tanggalLahir);
  const sekarang = new Date();
  let usia = sekarang.getFullYear() - lahir.getFullYear();
  const belumUlangTahun =
    sekarang.getMonth() < lahir.getMonth() ||
    (sekarang.getMonth() === lahir.getMonth() && sekarang.getDate() < lahir.getDate());
  if (belumUlangTahun) usia--;
  return usia;
};

onMounted(() => {
  fetchDetail();
});
</script>

<template>
  <div v-if="isLoading" class="text-center py-5">Memuat data pegawai...</div>

  <div v-else-if="errorMessage" class="alert alert-danger">
    {{ errorMessage }}
    <div class="mt-2">
      <button class="btn btn-outline-secondary btn-sm" @click="goBack()">Kembali</button>
    </div>
  </div>

  <div v-else-if="pegawai" class="row g-3">
    <div class="col-lg-6">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Data Diri</h3>
        </div>
        <div class="card-body">
          <div class="row g-4">
            <div class="col-12">
              <div class="row align-items-center">
                <!-- Foto -->
                <div class="col-auto">
                  <img
                    v-if="pegawai.foto_pegawai"
                    :src="pegawai.foto_pegawai"
                    alt="Foto Pegawai"
                    class="foto-ptofil"
                  />
                  <IconUserCircle v-else size="100" stroke="1" class="text-secondary" />
                </div>

                <div class="col">
                  <!-- NIP -->
                  <div class="datagrid-item mb-4">
                    <div class="datagrid-title">NIP</div>
                    <div class="datagrid-content">{{ pegawai.nip }}</div>
                  </div>

                  <!-- Nama Lengkap -->
                  <div class="datagrid-item">
                    <div class="datagrid-title">Nama Lengkap</div>
                    <div class="datagrid-content">{{ pegawai.nama_pegawai }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Email -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Email</div>
                <div class="datagrid-content">{{ pegawai.email || '-' }}</div>
              </div>
            </div>

            <!-- No HP -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Nomor HP</div>
                <div class="datagrid-content">{{ pegawai.nomor_hp || '-' }}</div>
              </div>
            </div>

            <!-- Tempat Lahir -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Tempat Lahir</div>
                <div class="datagrid-content">{{ pegawai.tempat_lahir || '-' }}</div>
              </div>
            </div>

            <!-- Tanggal Lahir -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Tanggal Lahir</div>
                <div class="datagrid-content">
                  {{ pegawai.tanggal_lahir ? formatDateID(pegawai.tanggal_lahir) : '-' }}
                </div>
              </div>
            </div>

            <!-- Usia -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Usia</div>
                <div class="datagrid-content">
                  {{ pegawai.usia ?? hitungUsia(pegawai.tanggal_lahir) ?? '-' }}
                  <span v-if="pegawai.usia || pegawai.tanggal_lahir"> tahun</span>
                </div>
              </div>
            </div>

            <!-- Pendidikan -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Pendidikan</div>
                <div v-if="pegawai.pendidikan && pegawai.pendidikan.length > 0">
                  <div
                    v-for="p in pegawai.pendidikan"
                    :key="p.id"
                    class="datagrid-content"
                  >
                    {{ p.tingkat }} / {{ p.sekolah }} / {{ p.tahun }}
                  </div>
                </div>
                <div v-else class="datagrid-content">-</div>
              </div>
            </div>

            <!-- Alamat Lengkap -->
            <div class="col-12">
              <div class="datagrid-item">
                <div class="datagrid-title">Alamat Lengkap</div>
                <div class="datagrid-content">{{ pegawai.alamat_lengkap || '-' }}</div>
              </div>
            </div>

            <!-- Kecamatan -->
            <div class="col-md-4">
              <div class="datagrid-item">
                <div class="datagrid-title">Kecamatan</div>
                <div class="datagrid-content">{{ pegawai.kecamatan || '-' }}</div>
              </div>
            </div>

            <!-- Kabupaten -->
            <div class="col-md-4">
              <div class="datagrid-item">
                <div class="datagrid-title">Kabupaten</div>
                <div class="datagrid-content">{{ pegawai.kabupaten || '-' }}</div>
              </div>
            </div>

            <!-- Provinsi -->
            <div class="col-md-4">
              <div class="datagrid-item">
                <div class="datagrid-title">Provinsi</div>
                <div class="datagrid-content">{{ pegawai.provinsi || '-' }}</div>
              </div>
            </div>

            <!-- Status Pernikahan -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Status Pernikahan</div>
                <div class="datagrid-content">
                  {{ pegawai.status_kawin === 'kawin' ? 'Kawin' : pegawai.status_kawin === 'tidak kawin' ? 'Tidak Kawin' : '-' }}
                </div>
              </div>
            </div>

            <!-- Jumlah Anak -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Jumlah Anak</div>
                <div class="datagrid-content">{{ pegawai.jumlah_anak ?? 0 }}</div>
              </div>
            </div>

            <!-- Jarak Rumah - Kantor -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Jarak Rumah - Kantor</div>
                <div class="datagrid-content">
                  {{ pegawai.jarak_rumah_kantor !== null ? `${pegawai.jarak_rumah_kantor} km` : '-' }}
                </div>
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
            <!-- Tanggal Masuk -->
            <div class="col-12">
              <div class="datagrid-item">
                <div class="datagrid-title">Tanggal Masuk</div>
                <div class="datagrid-content">
                  {{ pegawai.tanggal_masuk ? formatDateID(pegawai.tanggal_masuk) : '-' }}
                </div>
              </div>
            </div>

            <!-- Jabatan -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Jabatan</div>
                <div class="datagrid-content">{{ pegawai.nama_jabatan || '-' }}</div>
              </div>
            </div>

            <!-- Departemen -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Departemen</div>
                <div class="datagrid-content">{{ pegawai.nama_departemen || '-' }}</div>
              </div>
            </div>

            <!-- Status Kontrak -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Status Kontrak</div>
                <div class="datagrid-content">{{ pegawai.status_kontrak || '-' }}</div>
              </div>
            </div>

            <!-- Status Aktif/Nonaktif -->
            <div class="col-md-6">
              <div class="datagrid-item">
                <div class="datagrid-title">Status</div>
                <div class="datagrid-content">
                  <span class="badge" :class="pegawai.status === 'Aktif' ? 'bg-success text-white' : 'bg-secondary text-white'">
                    {{ pegawai.status || '-' }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card-footer d-flex">
          <div class="ms-auto">
            <button class="btn btn-outline-primary" @click="goBack()">
              Kembali
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.foto-ptofil {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
}
</style>