-- Migration: Ganti id_kecamatan (int, merujuk ke master_wilayah lokal yang tidak terisi)
-- menjadi kolom teks kecamatan/kabupaten/provinsi yang diisi langsung dari
-- API Wilayah Indonesia (emsifa). Ini lebih sesuai dengan cara frontend kamu
-- mengambil data wilayah (lewat API eksternal, bukan tabel lokal).

-- 1. Hapus index lama pada id_kecamatan (kalau masih ada)
ALTER TABLE `pegawai` DROP INDEX `fk_pegawai_kecamatan`;

-- 2. Tambah 3 kolom teks baru untuk menyimpan nama wilayah langsung
ALTER TABLE `pegawai`
  ADD COLUMN `kecamatan` VARCHAR(100) DEFAULT NULL AFTER `id_kecamatan`,
  ADD COLUMN `kabupaten` VARCHAR(100) DEFAULT NULL AFTER `kecamatan`,
  ADD COLUMN `provinsi` VARCHAR(100) DEFAULT NULL AFTER `kabupaten`;

-- 3. Hapus kolom id_kecamatan yang lama (sudah tidak relevan)
ALTER TABLE `pegawai` DROP COLUMN `id_kecamatan`;

-- Catatan: tabel master_wilayah tidak lagi dipakai untuk modul Data Pegawai
-- karena data wilayah sekarang bersumber dari API eksternal (emsifa) dan
-- disimpan langsung sebagai teks. Tabel master_wilayah bisa dibiarkan ada
-- (tidak mengganggu), atau dihapus manual jika kamu ingin membersihkan skema.
