<template>
  <div class="sticky-top" id="navbar">
    <header class="navbar navbar-expand-md d-none d-lg-flex d-print-none">
      <div class="container-xl">
        <!-- Sidebar Toggler -->
        <button
          class="navbar-toggler sidebar-toggler"
          type="button"
          @click="toggleSidebar"
          aria-label="Toggle sidebar"
        >
          <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Search (opsional) -->
        <div class="navbar-nav flex-row order-md-last">
          <!-- Dark Mode Toggle -->
          <div class="nav-item d-none d-md-flex me-3">
            <div class="btn-list">
              <button
                class="btn btn-toggle-theme btn-icon"
                :title="isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'"
                @click="toggleTheme"
              >
                <i v-if="isDark" class="ti ti-sun"></i>
                <i v-else class="ti ti-moon"></i>
              </button>
            </div>
          </div>

          <!-- Notification -->
          <div class="nav-item dropdown me-2">
            <a
              href="#"
              class="nav-link px-0"
              data-bs-toggle="dropdown"
              tabindex="-1"
              aria-label="Show notifications"
            >
              <i class="ti ti-bell icon"></i>
              <span class="badge bg-red"></span>
            </a>
            <div
              class="dropdown-menu dropdown-menu-arrow dropdown-menu-end dropdown-menu-card"
            >
              <div class="card">
                <div class="card-header">
                  <h3 class="card-title">Notifikasi</h3>
                </div>
                <div class="list-group list-group-flush list-group-hoverable">
                  <div class="list-group-item">
                    <div class="row align-items-center">
                      <div class="col-auto">
                        <span
                          class="status-dot status-dot-animated bg-red d-block"
                        ></span>
                      </div>
                      <div class="col text-truncate">
                        <p class="text-body d-block mb-0">
                          Belum ada notifikasi.
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- User Profile Dropdown -->
          <div class="nav-item dropdown">
            <a
              href="#"
              class="nav-link d-flex lh-1 text-reset p-0"
              data-bs-toggle="dropdown"
              aria-label="Open user menu"
            >
              <span class="avatar avatar-sm">
                <i class="ti ti-user" style="font-size: 1.25rem"></i>
              </span>
              <div class="d-none d-xl-block ps-2">
                <!-- Teks statis diubah menjadi dinamis -->
                <div>{{ activeUser.nama }}</div>
                <div class="mt-1 small text-secondary">{{ activeUser.role || activeUser.username }}</div>
              </div>
            </a>
            <div class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
              <NuxtLink to="/profile" class="dropdown-item">
                <i class="ti ti-user me-2"></i>Profil
              </NuxtLink>
              <a href="#" class="dropdown-item" @click.prevent="alert('Fitur Pengaturan sedang dalam tahap pengembangan')">
                <i class="ti ti-settings me-2"></i>Pengaturan
              </a>
              <div class="dropdown-divider"></div>
              
              <!-- Tombol Keluar memanggil fungsi handleLogout -->
              <a href="#" class="dropdown-item text-danger" @click.prevent="handleLogout">
                <i class="ti ti-logout me-2"></i>Keluar
              </a>
            </div>
          </div>
        </div>
      </div>
    </header>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useSidebar } from "@/composables/useSidebar";

const { isDark, toggleTheme } = useTheme();
const { toggleSidebar } = useSidebar();

// 1. Siapkan state untuk menampung data user
const activeUser = ref({
  nama: 'Memuat...',
  role: 'Memuat...'
});

// 2. Ambil data dari cookie saat komponen dimuat
onMounted(() => {
  const userData = useCookie('user_data');
  if (userData.value) {
    activeUser.value = typeof userData.value === 'string'
      ? JSON.parse(userData.value)
      : userData.value;
  }
});

// 3. Fungsi eksekusi Logout
const handleLogout = () => {
  const token = useCookie('auth_token');
  const user = useCookie('user_data');

  // Hapus tiket dan identitas dari peramban
  token.value = null;
  user.value = null;

  // Arahkan kembali ke halaman login (sesuai route sebelumnya di kodemu)
  navigateTo('/auth/login');
};
</script>