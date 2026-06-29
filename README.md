# Sistem Informasi Kepegawaian - JMC

Sistem informasi mini untuk pengelolaan data pegawai dan tunjangan transport.
Terdiri dari 2 bagian terpisah yang harus dijalankan bersamaan:

- **Backend**: Node.js + Express + MariaDB/MySQL (folder `backend/`)
- **Frontend**: Nuxt 4 + Tabler UI (folder root project)

---

## 1. Prasyarat (Prerequisite)

Pastikan sudah terinstall di komputer kamu:

| Tools | Versi Minimal | Catatan |
|---|---|---|
| Node.js | LTS (20.x atau lebih baru) | Cek dengan `node --version` |
| NPM | Bundled dengan Node.js | Cek dengan `npm --version` |
| MariaDB / MySQL | 10.x / 8.x | Bisa pakai XAMPP/Laragon untuk kemudahan lokal |
| Git | Versi apapun | Untuk clone repo |

---

## 2. Setup Database

### 2.1. Buat database

Buka phpMyAdmin atau MySQL client, buat database baru:

```sql
CREATE DATABASE db_pegawai;
```

### 2.2. Import struktur & data awal

Import file `db_pegawai.sql` (dump utama) ke database `db_pegawai` yang baru dibuat.

Lewat phpMyAdmin: pilih database `db_pegawai` → tab **Import** → pilih file `db_pegawai.sql` → **Go**.

Lewat command line:
```bash
mysql -u root -p db_pegawai < db_pegawai.sql
```

### 2.3. Jalankan migration tambahan

Beberapa perubahan struktur tabel dilakukan setelah dump awal dibuat. Jalankan **secara berurutan**:

```bash
mysql -u root -p db_pegawai < migration_wilayah.sql
```

> `migration_wilayah.sql` mengganti kolom `id_kecamatan` (yang merujuk ke tabel lokal `master_wilayah` yang kosong) menjadi 3 kolom teks (`kecamatan`, `kabupaten`, `provinsi`) yang diisi langsung dari API Wilayah Indonesia (emsifa) saat pegawai ditambahkan/diedit lewat form.

### 2.4. Seed data hak akses (role_permission)

Tabel `role_permission` menyimpan matriks hak akses per role (Superadmin, Manager HRD, Admin HRD) dan **wajib diisi** agar sistem RBAC berfungsi:

```bash
mysql -u root -p db_pegawai < seed_role_permission.sql
```

> Sesuai instruksi soal, perubahan hak akses dilakukan langsung di tabel ini lewat database, bukan lewat UI.

---

## 3. Setup Backend

```bash
cd backend
npm install
```

### 3.1. Konfigurasi `.env`

Buat file `.env` di folder `backend/` (atau copy dari `.env.example` jika tersedia):

```bash
# Konfigurasi Server
PORT=5000

# Konfigurasi Database MariaDB/MySQL
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=db_pegawai

# Kunci Rahasia JWT & Captcha
JWT_SECRET=ganti_dengan_string_acak_yang_panjang_dan_unik
RECAPTCHA_SECRET_KEY=isi_dengan_secret_key_recaptcha_kamu
```

> **Penting**: `JWT_SECRET` jangan dibiarkan dengan nilai contoh/placeholder pada lingkungan produksi. Gunakan string acak yang panjang (misal hasil `openssl rand -hex 32`).

### 3.2. Seed akun Superadmin pertama

Karena tabel `user` butuh minimal satu akun untuk bisa login pertama kali, jalankan:

```bash
node seed.js
```

Ini akan membuat akun dengan kredensial:

| Username | Password |
|---|---|
| `superadmin` | `Admin123!` |

> Segera ganti password ini setelah login pertama kali lewat halaman My Profile, terutama jika project akan dipakai di luar lingkungan testing.

### 3.3. Jalankan server backend

```bash
npm run dev
```

Server berjalan di `http://localhost:5000`. Dokumentasi API (Swagger) tersedia di:

```
http://localhost:5000/api-docs
```

---

## 4. Setup Frontend

Buka terminal baru (biarkan backend tetap berjalan), lalu dari folder root project:

```bash
npm install
```

### 4.1. Konfigurasi `.env`

Buat file `.env` di folder root:

```bash
APP_NAME=Sistem Informasi Kepegawaian
APP_CLIENT=JMC IT Consultant

NUXT_PUBLIC_RECAPTCHA_SITE_KEY=isi_dengan_site_key_recaptcha_kamu
```

### 4.2. Jalankan development server

```bash
npm run dev
```

Buka [http://localhost:3000](http://localhost:3000) di browser.

---

## 5. Kredensial Akun untuk Testing

Setelah `node seed.js` dijalankan, kamu punya 1 akun Superadmin. Untuk role lain (Manager HRD, Admin HRD), buat lewat menu **Manajemen User** setelah login sebagai Superadmin — sistem akan menggenerate password otomatis yang ditampilkan satu kali di layar.

| Role | Cara Mendapatkan Akun |
|---|---|
| Superadmin | Hasil `node seed.js` (lihat tabel di atas) |
| Manager HRD | Dibuat manual via menu Manajemen User (pilih role "Manager HRD") |
| Admin HRD | Dibuat manual via menu Manajemen User (pilih role "Admin HRD") |

---

## 6. Struktur Project (Ringkas)

```
.
├── app/                        # Frontend Nuxt
│   ├── pages/                  # Routing berbasis file
│   │   ├── pegawai/            # Modul Data Pegawai
│   │   ├── tunjangan/          # Modul Tunjangan Transport
│   │   ├── user/               # Kelola User & Kelola Role
│   │   └── log/                # Modul Log Aktivitas
│   ├── features/               # Komponen form per modul
│   ├── components/layout/       # Sidebar, Header, Breadcrumb
│   ├── data/                   # Konfigurasi menu sidebar
│   └── utils/                  # Helper format tanggal, rupiah, dll
│
├── backend/                     # Backend Express
│   ├── controllers/             # Logic per modul
│   ├── routes/                  # Definisi endpoint + dokumentasi Swagger
│   ├── middleware/              # Auth (JWT), RBAC, Logging
│   ├── config/db.js             # Koneksi database
│   └── server.js                # Entry point backend
│
├── db_pegawai.sql               # Dump database utama
├── migration_wilayah.sql        # Migration kolom wilayah (lihat 2.3)
└── seed_role_permission.sql     # Seed hak akses per role (lihat 2.4)
```

---

## 7. Troubleshooting Umum

| Masalah | Kemungkinan Sebab |
|---|---|
| `Cannot find module '../middleware/xxx'` | File middleware belum ditaruh di folder `backend/middleware/` yang benar |
| Selalu dapat `403 Forbidden` di semua endpoint | Tabel `role_permission` belum di-seed, atau token JWT lama (login ulang setelah update) |
| Login berhasil tapi langsung logout lagi | Token JWT default berlaku 3 menit jika "Remember Me" tidak dicentang (sesuai soal) |
| Dropdown Kecamatan/Kabupaten/Provinsi kosong | API eksternal emsifa.com sedang tidak bisa diakses, atau koneksi internet bermasalah |
| `Gagal terkoneksi ke database` saat start backend | Cek `.env` di folder `backend/`, pastikan MariaDB/MySQL service aktif |

---

## 8. Catatan Pengembangan

Beberapa hal yang diketahui masih merupakan area pengembangan lanjutan (bukan bug, melainkan keterbatasan scope/waktu pengerjaan):

- Tombol export PDF/Excel pada daftar pegawai belum diimplementasikan.
- Upload foto pegawai belum terhubung ke backend (kolom `foto_pegawai` tersedia di database, namun form belum mengirim file).
- Captcha pada form login bersifat sederhana (client-side), bukan menggunakan Google reCAPTCHA meskipun dependency `vue-recaptcha` sudah tersedia di project.
