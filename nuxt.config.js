// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  future: {
    compatibilityVersion: 4,
  },

  compatibilityDate: "2024-11-01",

  devtools: { enabled: true },

  routeRules: {
  '/api/**': { proxy: 'http://localhost:5000/api/**' }
},

  runtimeConfig: {
  public: {
    appName: process.env.APP_NAME,
    appClient: process.env.APP_CLIENT,
    recaptchaSiteKey: process.env.NUXT_PUBLIC_RECAPTCHA_SITE_KEY,
    apiBase: process.env.NUXT_PUBLIC_API_BASE, // ← tambahkan ini
  },
},

  css: [
    "@tabler/core/dist/css/tabler.min.css",
    // '@tabler/core/dist/css/tabler-icons.min.css',
    // "~/assets/css/main.css",
    "~/assets/css/backend.css",
  ],

  app: {
    head: {
      charset: "utf-8",
      viewport: "width=device-width, initial-scale=1",
      link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.png" }],
      script: [
        {
          src: "https://www.google.com/recaptcha/api.js",
          async: true,
          defer: true,
        },
      ],
    },
  },

  plugins: [
    "~/plugins/jquery.client.js",
    "~/plugins/tabler.client.js",
    "~/plugins/apexcharts.client.js",
  ],

  vite: {
    optimizeDeps: {
      include: ["apexcharts"],
    },
  },
});
