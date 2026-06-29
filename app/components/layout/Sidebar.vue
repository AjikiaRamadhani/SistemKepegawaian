<template>
  <aside class="navbar navbar-vertical navbar-expand-lg navbar-dark sidebar" data-bs-theme="dark">
    <div class="container-fluid px-0 justify-content-start">
      <!-- BRAND -->
      <h1 class="navbar-brand text-white ms-3 ms-lg-0 gap-3">
        <div class="logo">
          <img src="~/assets/images/logo/logo_jmc.png" alt="Logo" height="15" />
        </div>

        <NuxtLink to="/" class="fw-bold hstack gap-3 text-decoration-none text-white">
          <div style="font-size: 0.9rem">{{ config.public.appName }}</div>
        </NuxtLink>
      </h1>

      <div id="sidebar-menu" class="offcanvas offcanvas-start px-lg-3" tabindex="-1">
        <!-- HEADER -->
        <div class="offcanvas-header">
          <div class="d-flex gap-3 align-items-center">
            <div class="image">
              <img src="~/assets/images/logo/logo_jmc.png" alt="Logo" height="15" />
            </div>

            <div class="logo-text flex-grow-1">
              <h3 class="m-0"></h3>
              <div class="fs-4 fw-bold">{{ config.public.appName }}</div>
            </div>
          </div>

          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>

        <!-- BODY -->
        <div class="offcanvas-body p-3 p-lg-0 flex-column flex-grow-1 overflow-auto">
          <ul class="navbar-nav align-items-start pt-lg-3">
            
            <!-- Looping menggunakan menu yang SUDAH DIFILTER -->
            <template v-for="item in filteredMenuItems">
              
              <!-- Menu dengan children (dropdown) -->
              <li :key="item.title" v-if="item.children" class="nav-item dropdown" :class="{ active: isParentActive(item) }">
                <a
                  class="nav-link dropdown-toggle"
                  href="#"
                  :class="{ active: isParentActive(item) }"
                  data-bs-toggle="dropdown"
                  data-bs-auto-close="false"
                  role="button"
                  aria-expanded="false"
                  @click.prevent="toggleDropdown(item.title)"
                >
                  <span class="nav-link-icon d-md-none d-lg-inline-block">
                    <component :is="item.icon" />
                  </span>
                  <span class="nav-link-title">{{ item.title }}</span>
                </a>
                <div class="dropdown-menu" :class="{ show: openDropdowns.includes(item.title) || isParentActive(item) }">
                  <div class="dropdown-menu-columns">
                    <div class="dropdown-menu-column">
                      <NuxtLink
                        v-for="child in item.children"
                        :key="child.to"
                        :to="child.to"
                        class="dropdown-item"
                        :class="{ active: isActive(child.to) }"
                      >
                        {{ child.title }}
                      </NuxtLink>
                    </div>
                  </div>
                </div>
              </li>

              <!-- Menu biasa (tanpa children) -->
              <li v-else class="nav-item">
                <NuxtLink :to="item.to" class="nav-link" :class="{ active: isActive(item.to) }">
                  <span class="nav-link-icon d-md-none d-lg-inline-block">
                    <component :is="item.icon" />
                  </span>
                  <span class="nav-link-title">{{ item.title }}</span>
                </NuxtLink>
              </li>
              
            </template>
            
          </ul>
        </div>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
import { menuItems } from "~/data/menu.js";

const appName = "Admin";
const route = useRoute();
const config = useRuntimeConfig();

// ==========================================
// 1. BACA ROLE SECARA INSTAN
// ==========================================
const userData = useCookie('user_data');
const parsedData = userData.value ? (typeof userData.value === 'string' ? JSON.parse(userData.value) : userData.value) : null;
const activeRole = parsedData ? String(parsedData.id_role || parsedData.role).toLowerCase() : null;

// ==========================================
// 2. FILTER MENU INDUK DAN SUB-MENU (CHILDREN)
// ==========================================
const filteredMenuItems = computed(() => {
  if (!activeRole) return [];

  // Definisi Role yang lebih kuat (Deteksi ID atau Nama)
  const isSuperadmin = activeRole === '1' || activeRole.includes('super');
  const isManagerHRD = activeRole === '2' || activeRole.includes('manager');
  const isAdminHRD = activeRole === '3' || (activeRole.includes('admin') && !activeRole.includes('super'));

  // PROSES 1: Kita periksa dan bersihkan sub-menu (children) terlebih dahulu
  const cleanedMenu = menuItems.map(item => {
    // Gandakan data menu agar tidak merusak data aslinya
    const newItem = { ...item };
    
    // Jika menu ini punya dropdown (children)
    if (newItem.children) {
      newItem.children = newItem.children.filter(child => {
        const cTitle = child.title.toLowerCase();
        const cPath = child.to.toLowerCase();

        // Aturan Superadmin di dalam Sub-menu
        if (isSuperadmin) {
          if (cTitle.includes('pegawai') || cPath.includes('pegawai')) return false;
          if (cTitle.includes('tunjangan') || cPath.includes('tunjangan')) return false;
        }

        // Aturan Manager HRD di dalam Sub-menu
        if (isManagerHRD) {
          // Buang menu "Setting Tunjangan" (Hanya sisakan "Tunjangan Transport")
          if (cTitle.includes('setting') || cPath.includes('setting')) return false;
        }

        return true;
      });
    }
    return newItem;
  });

  // PROSES 2: Setelah sub-menu bersih, baru kita saring menu utamanya (Parent)
  return cleanedMenu.filter(item => {
    const title = item.title ? item.title.toLowerCase() : '';
    const path = item.to ? item.to.toLowerCase() : '';

    if (isSuperadmin) {
      if (title.includes('pegawai') || path.includes('pegawai')) return false;
      if (title.includes('tunjangan') || path.includes('tunjangan')) return false;
      
      // Sangat Penting: Jika Parent Menu (misal "Master Data") anaknya sudah habis
      // dibersihkan di Proses 1, maka Parent-nya juga ikut disembunyikan.
      if (item.children && item.children.length === 0) return false;
    }

    if (isManagerHRD || isAdminHRD) {
      if (title.includes('log') || path.includes('log')) return false;
      if (title.includes('role') || path.includes('role')) return false;
      if (title.includes('user') || path.includes('user')) return false;
    }

    return true;
  });
});

// ==========================================
// 3. LOGIKA DROPDOWN & ACTIVE CLASS
// ==========================================
const openDropdowns = ref([]);

const isActive = (path) => {
  if (path === "/") return route.path === "/";
  return route.path === path || route.path.startsWith(path + "/");
};

const isParentActive = (item) => {
  if (!item.children) return false;
  return item.children.some((child) => isActive(child.to));
};

const toggleDropdown = (title) => {
  const idx = openDropdowns.value.indexOf(title);
  if (idx === -1) {
    openDropdowns.value.push(title);
  } else {
    openDropdowns.value.splice(idx, 1);
  }
};

watch(
  () => route.path,
  () => {
    filteredMenuItems.value.forEach((item) => {
      if (item.children && isParentActive(item)) {
        if (!openDropdowns.value.includes(item.title)) {
          openDropdowns.value.push(item.title);
        }
      }
    });
  },
  { immediate: true },
);
</script>