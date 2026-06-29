-- Seed data untuk tabel role_permission
-- Berdasarkan tabel Hak Akses pada dokumen soal (Section B)
-- id_role: 1 = Superadmin, 2 = Manager HRD, 3 = Admin HRD
-- (sesuaikan id_role di bawah jika urutan di tabel user_role kamu berbeda)

-- Kosongkan dulu data lama (kalau ada), supaya tidak duplikat
DELETE FROM role_permission;

-- =========================
-- 1. Login/Logout (Y = bisa akses, tanpa CRUD spesifik)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(1, 'login', 1, 0, 'No', 'No', 'No'),
(2, 'login', 1, 0, 'No', 'No', 'No'),
(3, 'login', 1, 0, 'No', 'No', 'No');

-- =========================
-- 2. Kelola Role (Superadmin: R saja)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(1, 'kelola_role', 1, 0, 'All', 'No', 'No');

-- =========================
-- 3. Kelola User (Superadmin: CRUD kecuali hapus dirinya sendiri -> dicek di controller)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(1, 'kelola_user', 1, 1, 'All', 'All', 'All');

-- =========================
-- 4. My Profile (semua role: Read Own, Update Own)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(1, 'my_profile', 1, 0, 'Own', 'Own', 'No'),
(2, 'my_profile', 1, 0, 'Own', 'Own', 'No'),
(3, 'my_profile', 1, 0, 'Own', 'Own', 'No');

-- =========================
-- 5. Dashboard (Superadmin: R sesuai role, Manager HRD: R sesuai role, Admin HRD: sesuai role)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(1, 'dashboard', 1, 0, 'All', 'No', 'No'),
(2, 'dashboard', 1, 0, 'All', 'No', 'No'),
(3, 'dashboard', 1, 0, 'Own', 'No', 'No');

-- =========================
-- 6. Modul Data Pegawai (Manager HRD: R, Admin HRD: CRUD kecuali hapus data superadmin -> dicek di controller)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(2, 'data_pegawai', 1, 0, 'All', 'No', 'No'),
(3, 'data_pegawai', 1, 1, 'All', 'All', 'All');

-- =========================
-- 7. Modul Tunjangan Transport (Manager HRD: RO, Admin HRD: RO)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(2, 'tunjangan_transport', 1, 0, 'Own', 'No', 'No'),
(3, 'tunjangan_transport', 1, 0, 'Own', 'No', 'No');

-- =========================
-- 8. Setting Tunjangan Transport (Admin HRD: CRUD)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(3, 'setting_tunjangan', 1, 1, 'All', 'All', 'All');

-- =========================
-- 9. Modul Log (Superadmin: R)
-- =========================
INSERT INTO role_permission (id_role, modul_fitur, akses, `create`, `read`, `update`, `delete`) VALUES
(1, 'log', 1, 0, 'All', 'No', 'No');
