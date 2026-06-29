<script setup>
import { ref, onMounted } from 'vue';
import { IconUsers, IconHourglassHigh, IconFileCheck, IconIdBadge2 } from '@tabler/icons-vue';

definePageMeta({
  title: "Dashboard",
});

useSeoMeta({
  title: "Dashboard",
});

// === STATE MANAGEMENT ===
const activeUserName = ref("Administrator");
const userRoleName = ref("Superadmin");

// State Penentu Tampilan (Sangat Aman)
const isManagerHRD = ref(false);
const isOtherRole = ref(false); 

const dataPegawaiTerbaru = ref([]);

// State untuk 4 Widget Atas
const totalStatistik = ref([
  { title: "Total Pegawai", value: 0, backgroundColor: "#206bc4", icon: IconUsers },
  { title: "Total Pegawai Kontrak", value: 0, backgroundColor: "#f59f00", icon: IconHourglassHigh },
  { title: "Total Pegawai Tetap", value: 0, backgroundColor: "#2fb344", icon: IconFileCheck },
  { title: "Peserta Magang", value: 0, backgroundColor: "#d63939", icon: IconIdBadge2 }
]);

const statusPegawaiSeries = ref([0, 0, 0]); 
const genderPegawaiSeries = ref([0, 0]); 

const statusPegawaiOptions = {
  chart: { type: "donut", height: 200 },
  labels: ["PKWT", "PKWTT", "Magang"],
  colors: ["rgba(84, 128, 199, 1)", "rgba(43, 80, 142, 1)", "rgba(254, 126, 0, 1)"],
  legend: { position: "bottom" },
  dataLabels: { enabled: true },
};

const genderPegawaiOptions = {
  chart: { type: "donut", height: 200 },
  labels: ["Laki-laki", "Perempuan"],
  colors: ["rgba(43, 80, 142, 1)", "rgba(254, 126, 0, 1)"],
  legend: { position: "bottom" },
  dataLabels: { enabled: true },
};

// === FUNGSI UTAMA ===
onMounted(() => {
  const userData = useCookie('user_data');
  
  if (userData.value) {
    const parsed = typeof userData.value === 'string' ? JSON.parse(userData.value) : userData.value;
    
    activeUserName.value = parsed.nama || parsed.username || 'Pengguna';
    userRoleName.value = parsed.role || parsed.nama_role || 'Superadmin';
    
    // Deteksi cerdas: Baca angka '2' ATAU kata 'manager'
    const roleStr = String(parsed.id_role || parsed.role).toLowerCase();
    
    if (roleStr === '2' || roleStr.includes('manager')) {
      isManagerHRD.value = true;
    } else {
      isOtherRole.value = true;
    }
  } else {
    // Kalau cookie kosong, anggap saja user biasa (agar tidak blank)
    isOtherRole.value = true;
  }
  
  // Ambil data dashboard HANYA jika yang login manager HRD
  if (isManagerHRD.value) {
    fetchDashboardData();
  }
});

const fetchDashboardData = async () => {
  try {
    const token = useCookie('auth_token');
    // Pakai endpoint /api/dashboard yang backend sudah hitung semuanya
    // (widget, chart, 5 pegawai terbaru) lewat query SQL -- lebih efisien
    // daripada ambil semua data pegawai lalu hitung manual di frontend.
    const response = await $fetch('http://localhost:5000/api/dashboard', {
      method: 'GET',
      headers: { Authorization: `Bearer ${token.value}` }
    });

    if (!response || !response.widgets) return;

    totalStatistik.value[0].value = response.widgets.total_pegawai;
    totalStatistik.value[1].value = response.widgets.total_kontrak;
    totalStatistik.value[2].value = response.widgets.total_tetap;
    totalStatistik.value[3].value = response.widgets.total_magang;

    statusPegawaiSeries.value = response.charts.kontrak_vs_tetap_vs_magang;
    genderPegawaiSeries.value = response.charts.pria_vs_wanita;

    dataPegawaiTerbaru.value = response.recent_employees || [];

  } catch (error) {
    console.error('Gagal mengambil data dashboard:', error);
  }
};

const getInitials = (name) => {
  if (!name) return 'UN';
  const words = name.split(' ');
  return words.length > 1 ? (words[0][0] + words[1][0]).toUpperCase() : name.substring(0, 2).toUpperCase();
};

const formatDate = (dateString) => {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('id-ID', { day: 'numeric', month: 'short', year: 'numeric' }).format(date);
};
</script>

<template>
  <div class="page-body">
    
    <!-- TAMPILAN 1: SUPERADMIN & ADMIN HRD (Teks Saja) -->
    <div v-if="isOtherRole" class="row justify-content-center mt-4">
      <div class="col-md-8 text-center">
        <div class="card shadow-sm p-5 border-0">
          <div class="card-body py-5">
            <h1 class="display-5 fw-bold text-primary mb-3">
              Selamat Datang {{ activeUserName }} - {{ userRoleName }}
            </h1>
          </div>
        </div>
      </div>
    </div>

    <!-- TAMPILAN 2: MANAGER HRD (Dashboard Lengkap) -->
    <div v-if="isManagerHRD" class="row g-3">
      
      <!-- ... (Isi widget, grafik, dan tabel yang panjang milikmu TETAP SAMA seperti sebelumnya) ... -->
      <!-- PASTIKAN BAGIAN INI MASIH BERISI KODE HTML CARD & WIDGET-MU -->
      
      <div class="col-md-3">
        <div class="card bg-dark h-100 position-relative">
          <div class="card-body">
            <div class="text-center">
              <img
                src="@/assets/images/greeting-img.svg"
                alt=""
                class="img-fluid mb-4"
              />
            </div>
            <h3 class="card-title text-white">
              Halo, selamat datang {{ activeUserName }} di Aplikasi Kepegawaian
            </h3>
            <p class="text-white fw-lighter fst-italic">
              "Fokuskan tujuan yang ingin didapat, jangan biarkan faktor lain menghalangi tujuan Anda"
            </p>
          </div>
        </div>
      </div>
      
      <div class="col-md-9">
        <div class="row g-3">
          <div class="col-12">
            <div class="card">
              <div class="card-body">
                <div class="row g-3">
                  <div
                    class="col-md-6 col-lg-3"
                    v-for="(item, index) in totalStatistik"
                    :key="index"
                  >
                    <div class="row align-items-center">
                      <div class="col-auto">
                        <div
                          class="d-flex rounded-circle"
                          :style="{
                            width: '56px',
                            height: '56px',
                            background: item.backgroundColor,
                          }"
                        >
                          <component
                            :is="item.icon"
                            :stroke="2"
                            class="m-auto text-white"
                          />
                        </div>
                      </div>

                      <div class="col">
                        <h3 class="fs-2 mb-1">{{ item.value }}</h3>
                        <p class="text-secondary fw-light mb-0">
                          {{ item.title }}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <h3 class="card-title">
                  Total Pegawai Berdasarkan Status Kontrak
                </h3>
                <ClientOnly>
                  <apexchart
                    type="donut"
                    height="200"
                    :options="statusPegawaiOptions"
                    :series="statusPegawaiSeries"
                  />
                </ClientOnly>
              </div>
            </div>
          </div>
          
          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <h3 class="card-title">Total Pegawai Berdasarkan Gender</h3>
                <ClientOnly>
                  <apexchart
                    type="donut"
                    height="200"
                    :options="genderPegawaiOptions"
                    :series="genderPegawaiSeries"
                  />
                </ClientOnly>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-12 mt-3">
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Data Pegawai Terbaru</h3>
          </div>
          <div class="table-responsive card-body p-0">
            <table class="table table-vcenter table-striped card-table">
              <thead>
                <tr>
                  <th class="w-1">No</th>
                  <th>NIP</th>
                  <th>Nama Lengkap</th>
                  <th>Tanggal Masuk</th>
                  <th>Status Kepegawaian</th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="dataPegawaiTerbaru.length === 0">
                  <td colspan="6" class="text-center py-4">Belum ada data pegawai.</td>
                </tr>
                
                <tr v-else v-for="(item, index) in dataPegawaiTerbaru" :key="item.id">
                  <td class="text-center">{{ index + 1 }}</td>
                  <td>{{ item.nip }}</td>
                  <td>
                    <div class="d-flex align-items-center gap-2">
                      <span class="bg-primary text-white avatar rounded-circle avatar-sm">
                        {{ getInitials(item.nama_pegawai) }}
                      </span>
                      <p class="mb-0 fw-medium">
                        {{ item.nama_pegawai }}
                      </p>
                    </div>
                  </td>
                  <td>{{ formatDate(item.tanggal_masuk) }}</td>
                  <td>
                    <span class="badge" :class="item.status_kontrak === 'PKWTT' ? 'bg-success text-white' : 'bg-warning text-dark'">
                      {{ item.status_kontrak }}
                    </span>
                  </td>
                  <td>
                    <NuxtLink
                      :to="`/pegawai/${item.id}`"
                      class="btn btn-primary btn-sm"
                    >
                      Detail Pegawai
                    </NuxtLink>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    </div>
</template>