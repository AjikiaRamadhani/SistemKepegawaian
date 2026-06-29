-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 29 Jun 2026 pada 02.32
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_pegawai`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `activities`
--

CREATE TABLE `activities` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` mediumtext DEFAULT NULL,
  `ua` varchar(256) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `url` text DEFAULT NULL,
  `browser` varchar(64) DEFAULT NULL,
  `platform` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `activities`
--

INSERT INTO `activities` (`id`, `title`, `content`, `ua`, `ip`, `url`, `browser`, `platform`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-27 21:34:57', NULL, NULL, NULL),
(2, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/auth/login', NULL, NULL, '2026-06-27 21:39:32', NULL, NULL, NULL),
(3, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/auth/login', NULL, NULL, '2026-06-27 21:42:35', NULL, NULL, NULL),
(4, 'Akses Modul: Kelola User', 'User melakukan aksi Membuat pada modul Kelola User.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/user', NULL, NULL, '2026-06-27 21:42:45', NULL, 1, NULL),
(5, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-27 21:43:23', NULL, NULL, NULL),
(6, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/auth/login', NULL, NULL, '2026-06-27 21:49:13', NULL, NULL, NULL),
(7, 'Akses Modul: Memperbarui pegawai', 'User melakukan aksi Memperbarui pada modul Memperbarui pegawai.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/pegawai/1', NULL, NULL, '2026-06-27 21:49:31', NULL, 1, NULL),
(8, 'Akses Modul: Menghapus pegawai', 'User melakukan aksi Menghapus pada modul Menghapus pegawai.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/pegawai/1', NULL, NULL, '2026-06-27 21:50:25', NULL, 1, NULL),
(9, 'Akses Modul: Membuat pegawai baru', 'User melakukan aksi Membuat pada modul Membuat pegawai baru.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/pegawai', NULL, NULL, '2026-06-27 21:50:33', NULL, 1, NULL),
(10, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 00:13:13', NULL, NULL, NULL),
(11, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:07:59', NULL, NULL, NULL),
(12, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 11:08:06', NULL, 1, NULL),
(13, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:10:27', NULL, NULL, NULL),
(14, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:14:44', NULL, NULL, NULL),
(15, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:15:47', NULL, NULL, NULL),
(16, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:16:03', NULL, NULL, NULL),
(17, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:18:03', NULL, NULL, NULL),
(18, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:18:47', NULL, NULL, NULL),
(19, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/auth/login', NULL, NULL, '2026-06-28 11:21:05', NULL, NULL, NULL),
(20, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 11:23:25', NULL, NULL, NULL),
(21, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/auth/login', NULL, NULL, '2026-06-28 12:18:11', NULL, NULL, NULL),
(22, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/auth/login', NULL, NULL, '2026-06-28 12:23:40', NULL, NULL, NULL),
(23, 'Akses Modul: Kelola User', 'User melakukan aksi Membuat pada modul Kelola User.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/user', NULL, NULL, '2026-06-28 12:23:47', NULL, 1, NULL),
(24, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 12:24:21', NULL, NULL, NULL),
(25, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 12:24:21', NULL, 4, NULL),
(26, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 12:25:24', NULL, NULL, NULL),
(27, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/auth/login', NULL, NULL, '2026-06-28 12:27:20', NULL, NULL, NULL),
(28, 'Akses Modul: Kelola User', 'User melakukan aksi Membuat pada modul Kelola User.', 'Thunder Client (https://www.thunderclient.com)', '::ffff:127.0.0.1', '/api/user', NULL, NULL, '2026-06-28 12:27:56', NULL, 1, NULL),
(29, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 12:28:16', NULL, NULL, NULL),
(30, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 12:28:16', NULL, 5, NULL),
(31, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 12:28:41', NULL, 5, NULL),
(32, 'Akses Modul: Memperbarui pegawai', 'User melakukan aksi Memperbarui pada modul Memperbarui pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/3', NULL, NULL, '2026-06-28 12:49:21', NULL, 5, NULL),
(33, 'Akses Modul: Membuat pegawai baru', 'User melakukan aksi Membuat pada modul Membuat pegawai baru.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 13:15:27', NULL, 5, NULL),
(34, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 13:15:29', NULL, 5, NULL),
(35, 'Akses Modul: Membuat pegawai baru', 'User melakukan aksi Membuat pada modul Membuat pegawai baru.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 13:24:36', NULL, 5, NULL),
(36, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 13:24:38', NULL, 5, NULL),
(37, 'Akses Modul: Membuat pegawai baru', 'User melakukan aksi Membuat pada modul Membuat pegawai baru.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 13:31:38', NULL, 5, NULL),
(38, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 13:31:39', NULL, 5, NULL),
(39, 'Akses Modul: Membuat pegawai baru', 'User melakukan aksi Membuat pada modul Membuat pegawai baru.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 14:05:27', NULL, 5, NULL),
(40, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 14:05:29', NULL, 5, NULL),
(41, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:45:51', NULL, NULL, NULL),
(42, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:46:33', NULL, NULL, NULL),
(43, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:48:42', NULL, NULL, NULL),
(44, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:51:10', NULL, NULL, NULL),
(45, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:51:28', NULL, NULL, NULL),
(46, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:52:11', NULL, NULL, NULL),
(47, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:54:37', NULL, NULL, NULL),
(48, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 14:57:21', NULL, NULL, NULL),
(49, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 15:26:17', NULL, NULL, NULL),
(50, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 15:26:17', NULL, 5, NULL),
(51, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 16:57:29', NULL, NULL, NULL),
(52, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:24:54', NULL, NULL, NULL),
(53, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:25:39', NULL, NULL, NULL),
(54, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:34:58', NULL, NULL, NULL),
(55, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 17:35:05', NULL, 4, NULL),
(56, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:35:56', NULL, NULL, NULL),
(57, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:36:43', NULL, NULL, NULL),
(58, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:37:29', NULL, NULL, NULL),
(59, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:40:31', NULL, NULL, NULL),
(60, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:41:05', NULL, NULL, NULL),
(61, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:43:53', NULL, NULL, NULL),
(62, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:44:47', NULL, NULL, NULL),
(63, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:47:02', NULL, NULL, NULL),
(64, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:56:34', NULL, NULL, NULL),
(65, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 17:59:09', NULL, NULL, NULL),
(66, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 18:02:14', NULL, NULL, NULL),
(67, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 18:07:13', NULL, NULL, NULL),
(68, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 18:07:39', NULL, NULL, NULL),
(69, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 18:10:14', NULL, NULL, NULL),
(70, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 18:13:32', NULL, NULL, NULL),
(71, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 20:29:29', NULL, NULL, NULL),
(72, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-28 20:37:00', NULL, 4, NULL),
(73, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-28 20:45:00', NULL, 4, NULL),
(74, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc', NULL, NULL, '2026-06-28 20:45:41', NULL, 4, NULL),
(75, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=desc', NULL, NULL, '2026-06-28 20:45:42', NULL, 4, NULL),
(76, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=desc&masa_kerja_min=0', NULL, NULL, '2026-06-28 20:45:45', NULL, 4, NULL),
(77, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 20:46:08', NULL, NULL, NULL),
(78, 'Akses Modul: Melihat detail pegawai', 'User melakukan aksi Membaca pada modul Melihat detail pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/4', NULL, NULL, '2026-06-28 20:46:14', NULL, 5, NULL),
(79, 'Akses Modul: Melihat detail pegawai', 'User melakukan aksi Membaca pada modul Melihat detail pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/9', NULL, NULL, '2026-06-28 20:46:54', NULL, 5, NULL),
(80, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 21:30:02', NULL, NULL, NULL),
(81, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-28 21:30:50', NULL, NULL, NULL),
(82, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 00:32:16', NULL, NULL, NULL),
(83, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 00:32:33', NULL, NULL, NULL),
(84, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 00:32:36', NULL, 5, NULL),
(85, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 00:46:43', NULL, NULL, NULL),
(86, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 00:47:17', NULL, NULL, NULL),
(87, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 00:47:20', NULL, 4, NULL),
(88, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 00:48:50', NULL, NULL, NULL),
(89, 'Akses Modul: Memperbarui pegawai', 'User melakukan aksi Memperbarui pada modul Memperbarui pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/4', NULL, NULL, '2026-06-29 00:50:17', NULL, 5, NULL),
(90, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 00:50:19', NULL, 5, NULL),
(91, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 00:57:42', NULL, NULL, NULL),
(92, 'Akses Modul: Melihat detail pegawai', 'User melakukan aksi Membaca pada modul Melihat detail pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/4', NULL, NULL, '2026-06-29 00:57:45', NULL, 4, NULL),
(93, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 00:57:54', NULL, 4, NULL),
(94, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&status_kontrak=PKWTT', NULL, NULL, '2026-06-29 00:57:59', NULL, 4, NULL),
(95, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&jabatan=1', NULL, NULL, '2026-06-29 00:58:04', NULL, 4, NULL),
(96, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&jabatan=1,3', NULL, NULL, '2026-06-29 00:58:05', NULL, 4, NULL),
(97, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&jabatan=1,3,4', NULL, NULL, '2026-06-29 00:58:06', NULL, 4, NULL),
(98, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&jabatan=1,3,4,2', NULL, NULL, '2026-06-29 00:58:07', NULL, 4, NULL),
(99, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&jabatan=1,4,2', NULL, NULL, '2026-06-29 00:58:10', NULL, 4, NULL),
(100, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&jabatan=4,2', NULL, NULL, '2026-06-29 00:58:11', NULL, 4, NULL),
(101, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc&jabatan=4', NULL, NULL, '2026-06-29 00:58:14', NULL, 4, NULL),
(102, 'Akses Modul: Melihat detail pegawai', 'User melakukan aksi Membaca pada modul Melihat detail pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/9', NULL, NULL, '2026-06-29 00:58:23', NULL, 4, NULL),
(103, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 01:07:50', NULL, NULL, NULL),
(104, 'Akses Modul: Melihat detail pegawai', 'User melakukan aksi Membaca pada modul Melihat detail pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/4', NULL, NULL, '2026-06-29 01:07:54', NULL, 4, NULL),
(105, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 01:08:02', NULL, 4, NULL),
(106, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 01:08:25', NULL, NULL, NULL),
(107, 'Akses Modul: Membuat pegawai baru', 'User melakukan aksi Membuat pada modul Membuat pegawai baru.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai', NULL, NULL, '2026-06-29 01:10:45', NULL, 5, NULL),
(108, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 01:10:46', NULL, 5, NULL),
(109, 'Akses Modul: Melihat detail pegawai', 'User melakukan aksi Membaca pada modul Melihat detail pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/10', NULL, NULL, '2026-06-29 01:10:55', NULL, 5, NULL),
(110, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 01:14:53', NULL, NULL, NULL),
(111, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 01:14:55', NULL, 5, NULL),
(112, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 01:21:22', NULL, NULL, NULL),
(113, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 01:21:25', NULL, 5, NULL),
(114, 'Akses Modul: Melihat detail pegawai', 'User melakukan aksi Membaca pada modul Melihat detail pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai/1', NULL, NULL, '2026-06-29 01:21:29', NULL, 5, NULL),
(115, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=asc', NULL, NULL, '2026-06-29 01:28:48', NULL, 5, NULL),
(116, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc', NULL, NULL, '2026-06-29 01:28:51', NULL, 5, NULL),
(117, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=1', NULL, NULL, '2026-06-29 01:28:59', NULL, 5, NULL),
(118, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=0', NULL, NULL, '2026-06-29 01:29:01', NULL, 5, NULL),
(119, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=2', NULL, NULL, '2026-06-29 01:29:04', NULL, 5, NULL),
(120, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=3', NULL, NULL, '2026-06-29 01:29:04', NULL, 5, NULL),
(121, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=4', NULL, NULL, '2026-06-29 01:29:04', NULL, 5, NULL),
(122, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=5', NULL, NULL, '2026-06-29 01:29:04', NULL, 5, NULL),
(123, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=6', NULL, NULL, '2026-06-29 01:29:05', NULL, 5, NULL),
(124, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=8', NULL, NULL, '2026-06-29 01:29:05', NULL, 5, NULL),
(125, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=9', NULL, NULL, '2026-06-29 01:29:05', NULL, 5, NULL),
(126, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=10', NULL, NULL, '2026-06-29 01:29:05', NULL, 5, NULL),
(127, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=11', NULL, NULL, '2026-06-29 01:29:06', NULL, 5, NULL),
(128, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=12', NULL, NULL, '2026-06-29 01:29:06', NULL, 5, NULL),
(129, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&masa_kerja_min=13', NULL, NULL, '2026-06-29 01:29:06', NULL, 5, NULL),
(130, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&jabatan=3&masa_kerja_min=0', NULL, NULL, '2026-06-29 01:29:10', NULL, 5, NULL),
(131, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=nama_pegawai&sort_dir=asc&status_kontrak=Magang', NULL, NULL, '2026-06-29 01:29:27', NULL, 5, NULL),
(132, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 01:29:42', NULL, NULL, NULL),
(133, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 07:10:09', NULL, NULL, NULL),
(134, 'Akses Modul: Mengubah status user', 'User melakukan aksi Memperbarui pada modul Mengubah status user.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/user/5/toggle-status', NULL, NULL, '2026-06-29 07:10:33', NULL, 1, NULL),
(135, 'Akses Modul: Mengubah status user', 'User melakukan aksi Memperbarui pada modul Mengubah status user.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/user/5/toggle-status', NULL, NULL, '2026-06-29 07:10:34', NULL, 1, NULL),
(136, 'Akses Modul: Kelola User', 'User melakukan aksi Membuat pada modul Kelola User.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/user', NULL, NULL, '2026-06-29 07:11:15', NULL, 1, NULL),
(137, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 07:13:03', NULL, NULL, NULL),
(138, 'Akses Modul: Melihat semua pegawai', 'User melakukan aksi Membaca pada modul Melihat semua pegawai.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/pegawai?page=1&limit=10&sort_by=tanggal_masuk&sort_dir=desc', NULL, NULL, '2026-06-29 07:13:09', NULL, NULL, NULL),
(139, 'Akses Modul: Login/ Logout', 'User melakukan aksi Login ke aplikasi pada modul Login/ Logout.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/auth/login', NULL, NULL, '2026-06-29 07:23:53', NULL, NULL, NULL),
(140, 'Akses Modul: Menghapus user', 'User melakukan aksi Menghapus pada modul Menghapus user.', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '::1', '/api/user/6', NULL, NULL, '2026-06-29 07:24:21', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `departemen`
--

CREATE TABLE `departemen` (
  `id` int(11) NOT NULL,
  `nama_departemen` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `departemen`
--

INSERT INTO `departemen` (`id`, `nama_departemen`) VALUES
(1, 'Produksi'),
(2, 'Marketing'),
(3, 'Finance');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_data`
--

CREATE TABLE `master_data` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `tipe` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `master_data`
--

INSERT INTO `master_data` (`id`, `nama`, `tipe`) VALUES
(1, 'Manager', 'jabatan'),
(2, 'System Analist', 'jabatan'),
(3, 'Akuntan', 'jabatan'),
(4, 'Programmer', 'jabatan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_wilayah`
--

CREATE TABLE `master_wilayah` (
  `id` int(11) NOT NULL,
  `kecamatan` varchar(100) DEFAULT NULL,
  `kabupaten` varchar(100) DEFAULT NULL,
  `provinsi` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pegawai`
--

CREATE TABLE `pegawai` (
  `id` int(11) NOT NULL,
  `foto_pegawai` varchar(255) DEFAULT NULL,
  `nip` varchar(30) DEFAULT NULL,
  `nama_pegawai` varchar(255) DEFAULT NULL,
  `jenis_kelamin` enum('Pria','Wanita') DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `nomor_hp` varchar(20) DEFAULT NULL,
  `tempat_lahir` varchar(100) DEFAULT NULL,
  `kecamatan` varchar(100) DEFAULT NULL,
  `kabupaten` varchar(100) DEFAULT NULL,
  `provinsi` varchar(100) DEFAULT NULL,
  `alamat_lengkap` text DEFAULT NULL,
  `jarak_rumah_kantor` tinyint(2) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `status_kawin` enum('kawin','tidak kawin') DEFAULT NULL,
  `jumlah_anak` tinyint(2) DEFAULT 0,
  `tanggal_masuk` date DEFAULT NULL,
  `id_jabatan` int(11) DEFAULT NULL,
  `id_departemen` int(11) DEFAULT NULL,
  `status_kontrak` enum('PKWTT','PKWT','Magang') DEFAULT NULL,
  `usia` int(11) DEFAULT NULL,
  `status` enum('Aktif','Nonaktif') DEFAULT 'Aktif',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pegawai`
--

INSERT INTO `pegawai` (`id`, `foto_pegawai`, `nip`, `nama_pegawai`, `jenis_kelamin`, `email`, `nomor_hp`, `tempat_lahir`, `kecamatan`, `kabupaten`, `provinsi`, `alamat_lengkap`, `jarak_rumah_kantor`, `tanggal_lahir`, `status_kawin`, `jumlah_anak`, `tanggal_masuk`, `id_jabatan`, `id_departemen`, `status_kontrak`, `usia`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, '1234561234234', 'Susanti', 'Wanita', 'santi@gmail.com', '+623445566', 'Semarang', NULL, NULL, NULL, NULL, 4, '2005-06-02', 'kawin', 1, '2020-06-17', NULL, NULL, 'PKWT', NULL, 'Aktif', '2026-06-28 05:27:14', '2026-06-28 05:28:37'),
(3, NULL, '12345678', 'Budi Santoso, S.Kom', 'Pria', 'budi@gmail.com', '+62343400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'PKWTT', NULL, 'Aktif', '2026-06-27 14:50:33', '2026-06-28 05:49:21'),
(4, NULL, '1234567833', 'Joko Susilo', 'Pria', 'joko@gmail.com', '+62812345', 'Bantul', NULL, NULL, NULL, 'Sukoharjo', 15, '2006-06-06', 'kawin', 2, '2025-06-09', 1, 3, 'Magang', 20, 'Aktif', '2026-06-28 05:22:47', '2026-06-28 17:50:17'),
(5, NULL, '12332111', 'Rahmat Hidayat', 'Pria', 'rahmat@gmail.com', '+6287776578', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Magang', NULL, 'Aktif', '2026-06-28 06:15:27', '2026-06-28 06:15:27'),
(6, NULL, '123313211', 'Oline Manuel', 'Wanita', 'oln@gmail.com', '+628106547799', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'PKWT', NULL, 'Aktif', '2026-06-28 06:24:36', '2026-06-28 06:24:36'),
(7, NULL, '12334566', 'Olivia', 'Wanita', 'olv@gmail.com', '+62888189822', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'PKWTT', NULL, 'Aktif', '2026-06-28 06:31:38', '2026-06-28 06:31:38'),
(9, NULL, '122223333', 'Iqbal', 'Pria', 'iqbl@gmail.com', '+62887778998', 'Karanganyar', NULL, NULL, NULL, 'Karanganyar', 11, '2005-09-14', 'kawin', 2, '2023-12-10', 2, 2, 'PKWTT', 20, 'Aktif', '2026-06-28 07:05:27', '2026-06-28 07:05:27'),
(10, NULL, '12333434', 'Roni Maulana', 'Pria', 'rnm@gmail.com', '+6289998837', 'Surabaya', 'GUBENG', 'KOTA SURABAYA', 'JAWA TIMUR', 'Gubeg, Surabaya, Jawa Timur', 20, '2000-05-10', 'kawin', 2, '2020-01-01', 4, 3, 'PKWTT', 26, 'Aktif', '2026-06-28 18:10:45', '2026-06-28 18:10:45');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pegawai_pendidikan`
--

CREATE TABLE `pegawai_pendidikan` (
  `id` int(11) NOT NULL,
  `id_pegawai` int(11) DEFAULT NULL,
  `tingkat_pendidikan` varchar(50) DEFAULT NULL,
  `nama_sekolah` varchar(255) DEFAULT NULL,
  `tahun_lulus` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pegawai_pendidikan`
--

INSERT INTO `pegawai_pendidikan` (`id`, `id_pegawai`, `tingkat_pendidikan`, `nama_sekolah`, `tahun_lulus`) VALUES
(9, 5, 'SMA', 'SMA 1 Jakarta', '2019'),
(10, 5, 'S1', 'Universitas Indonesia', '2027'),
(11, 6, 'SMA', 'SMA 2 Jakarta', '2025'),
(12, 7, 'S1', 'Universitas Gajah Mada', '2025'),
(13, 9, 'SMA', 'SMA N 1 Karanganyar', '2019'),
(14, 4, 'SMA', 'SMA 1 Sukoharjo', '2018'),
(15, 10, 'SMA', 'SMA 1 Surabaya', '2015'),
(16, 10, 'S1', 'Universitas Diponegoro', '2019');

-- --------------------------------------------------------

--
-- Struktur dari tabel `role_permission`
--

CREATE TABLE `role_permission` (
  `id` int(11) NOT NULL,
  `id_role` smallint(6) DEFAULT NULL,
  `modul_fitur` varchar(100) DEFAULT NULL,
  `akses` tinyint(1) DEFAULT 0,
  `create` tinyint(1) DEFAULT 0,
  `read` enum('All','Own','No') DEFAULT 'No',
  `update` enum('All','Own','No') DEFAULT 'No',
  `delete` enum('All','Own','No') DEFAULT 'No'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `role_permission`
--

INSERT INTO `role_permission` (`id`, `id_role`, `modul_fitur`, `akses`, `create`, `read`, `update`, `delete`) VALUES
(1, 1, 'login', 1, 0, 'No', 'No', 'No'),
(2, 2, 'login', 1, 0, 'No', 'No', 'No'),
(3, 3, 'login', 1, 0, 'No', 'No', 'No'),
(4, 1, 'kelola_role', 1, 0, 'All', 'No', 'No'),
(5, 1, 'kelola_user', 1, 1, 'All', 'All', 'All'),
(6, 1, 'my_profile', 1, 0, 'Own', 'Own', 'No'),
(7, 2, 'my_profile', 1, 0, 'Own', 'Own', 'No'),
(8, 3, 'my_profile', 1, 0, 'Own', 'Own', 'No'),
(9, 1, 'dashboard', 1, 0, 'All', 'No', 'No'),
(10, 2, 'dashboard', 1, 0, 'All', 'No', 'No'),
(11, 3, 'dashboard', 1, 0, 'Own', 'No', 'No'),
(12, 2, 'data_pegawai', 1, 0, 'All', 'No', 'No'),
(13, 3, 'data_pegawai', 1, 1, 'All', 'All', 'All'),
(14, 2, 'tunjangan_transport', 1, 0, 'Own', 'No', 'No'),
(15, 3, 'tunjangan_transport', 1, 0, 'Own', 'No', 'No'),
(16, 3, 'setting_tunjangan', 1, 1, 'All', 'All', 'All'),
(17, 1, 'log', 1, 0, 'All', 'No', 'No');

-- --------------------------------------------------------

--
-- Struktur dari tabel `setting_tunjangan`
--

CREATE TABLE `setting_tunjangan` (
  `id` int(11) NOT NULL,
  `base_fare` int(11) NOT NULL COMMENT 'Tarif per KM',
  `berlaku_mulai` date NOT NULL,
  `min_km` tinyint(4) DEFAULT 5,
  `max_km` tinyint(4) DEFAULT 25,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `setting_tunjangan`
--

INSERT INTO `setting_tunjangan` (`id`, `base_fare`, `berlaku_mulai`, `min_km`, `max_km`, `created_at`, `updated_at`) VALUES
(1, 5000, '2026-05-30', 5, 25, '2026-06-27 14:22:48', '2026-06-28 17:33:09');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tunjangan_bulanan`
--

CREATE TABLE `tunjangan_bulanan` (
  `id` int(11) NOT NULL,
  `bulan` tinyint(2) NOT NULL COMMENT '1-12',
  `tahun` year(4) NOT NULL,
  `total_penerima` int(11) DEFAULT 0,
  `total_nominal` bigint(20) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tunjangan_bulanan`
--

INSERT INTO `tunjangan_bulanan` (`id`, `bulan`, `tahun`, `total_penerima`, `total_nominal`, `created_at`) VALUES
(1, 6, '2026', 1, 1100000, '2026-06-27 14:28:10'),
(2, 6, '2026', 0, 0, '2026-06-27 14:28:41'),
(3, 0, '2026', 0, 0, '2026-06-28 11:32:04'),
(4, 0, '2026', 1, 1430000, '2026-06-28 11:32:47'),
(5, 1, '2026', 1, 1155000, '2026-06-28 17:47:40'),
(6, 2, '2026', 0, 0, '2026-06-28 17:50:50'),
(7, 1, '2025', 1, 1540000, '2026-06-28 17:51:11'),
(8, 3, '2026', 1, 2000000, '2026-06-28 18:28:18');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tunjangan_detail`
--

CREATE TABLE `tunjangan_detail` (
  `id` bigint(20) NOT NULL,
  `id_tunjangan_bulanan` int(11) NOT NULL,
  `id_pegawai` int(11) NOT NULL,
  `jarak_km` tinyint(4) NOT NULL,
  `jumlah_hari` tinyint(2) NOT NULL,
  `nominal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tunjangan_detail`
--

INSERT INTO `tunjangan_detail` (`id`, `id_tunjangan_bulanan`, `id_pegawai`, `jarak_km`, `jumlah_hari`, `nominal`) VALUES
(2, 4, 9, 11, 26, 1430000),
(3, 5, 9, 11, 21, 1155000),
(4, 7, 9, 11, 28, 1540000),
(5, 8, 10, 20, 20, 2000000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `id_role` smallint(6) DEFAULT NULL,
  `id_pegawai` int(11) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `last_session` varchar(255) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `disabled` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id`, `id_role`, `id_pegawai`, `username`, `password_hash`, `nama`, `email`, `last_session`, `last_login`, `updated_at`, `created_at`, `disabled`) VALUES
(1, 1, NULL, 'budipurwanto', '$2b$10$XnepZOXsl7.dVsSJrKH3P.yTIbF9GlfAHXmcrDR4kRwRyFbsUgnX2', 'Budi Purwanto', 'admin@jmc.com', NULL, '2026-06-29 00:23:52', '2026-06-29 00:23:52', '2026-06-27 13:40:31', 0),
(4, 2, 4, 'jokosusilo', '$2b$10$z5TjbtVCMoCIPQUYL4pyWOUpqulvzbShrhG4wOk4BMWFj/qmFMKWq', 'Joko Susilo', 'joko@gmail.com', NULL, '2026-06-28 18:07:50', '2026-06-28 18:07:50', '2026-06-28 05:23:47', 0),
(5, 3, 1, 'susanti', '$2b$10$n5u7hr8C/V8Xuoh51Q/xJOamEH4YOkB3qcFtBxonNS4gCei/sqikq', 'Susanti', 'santi@gmail.com', NULL, '2026-06-28 18:29:42', '2026-06-29 00:10:34', '2026-06-28 05:27:56', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_role`
--

CREATE TABLE `user_role` (
  `id` smallint(6) NOT NULL,
  `nama_role` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `user_role`
--

INSERT INTO `user_role` (`id`, `nama_role`, `created_at`) VALUES
(1, 'Superadmin', '2026-06-27 13:40:31'),
(2, 'Manager HRD', '2026-06-27 13:40:31'),
(3, 'Admin HRD', '2026-06-27 13:40:31');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_activities_created` (`created_by`),
  ADD KEY `fk_activities_updated` (`updated_by`);

--
-- Indeks untuk tabel `departemen`
--
ALTER TABLE `departemen`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `master_data`
--
ALTER TABLE `master_data`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `master_wilayah`
--
ALTER TABLE `master_wilayah`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_kecamatan` (`kecamatan`);

--
-- Indeks untuk tabel `pegawai`
--
ALTER TABLE `pegawai`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nip` (`nip`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_pegawai_jabatan` (`id_jabatan`),
  ADD KEY `fk_pegawai_departemen` (`id_departemen`);

--
-- Indeks untuk tabel `pegawai_pendidikan`
--
ALTER TABLE `pegawai_pendidikan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pendidikan_pegawai` (`id_pegawai`);

--
-- Indeks untuk tabel `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_permission_role` (`id_role`);

--
-- Indeks untuk tabel `setting_tunjangan`
--
ALTER TABLE `setting_tunjangan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tunjangan_bulanan`
--
ALTER TABLE `tunjangan_bulanan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tunjangan_detail`
--
ALTER TABLE `tunjangan_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_detail_tunjangan` (`id_tunjangan_bulanan`),
  ADD KEY `fk_detail_pegawai` (`id_pegawai`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `username` (`username`) USING BTREE,
  ADD KEY `user_ibfk_1` (`id_role`),
  ADD KEY `fk_user_pegawai` (`id_pegawai`);

--
-- Indeks untuk tabel `user_role`
--
ALTER TABLE `user_role`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `activities`
--
ALTER TABLE `activities`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT untuk tabel `departemen`
--
ALTER TABLE `departemen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `master_data`
--
ALTER TABLE `master_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `master_wilayah`
--
ALTER TABLE `master_wilayah`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pegawai`
--
ALTER TABLE `pegawai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `pegawai_pendidikan`
--
ALTER TABLE `pegawai_pendidikan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `setting_tunjangan`
--
ALTER TABLE `setting_tunjangan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `tunjangan_bulanan`
--
ALTER TABLE `tunjangan_bulanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `tunjangan_detail`
--
ALTER TABLE `tunjangan_detail`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `user_role`
--
ALTER TABLE `user_role`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `fk_activities_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_activities_updated` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pegawai`
--
ALTER TABLE `pegawai`
  ADD CONSTRAINT `fk_pegawai_departemen` FOREIGN KEY (`id_departemen`) REFERENCES `master_data` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pegawai_jabatan` FOREIGN KEY (`id_jabatan`) REFERENCES `master_data` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pegawai_pendidikan`
--
ALTER TABLE `pegawai_pendidikan`
  ADD CONSTRAINT `fk_pendidikan_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `fk_permission_role` FOREIGN KEY (`id_role`) REFERENCES `user_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tunjangan_detail`
--
ALTER TABLE `tunjangan_detail`
  ADD CONSTRAINT `fk_detail_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_tunjangan` FOREIGN KEY (`id_tunjangan_bulanan`) REFERENCES `tunjangan_bulanan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id_role`) REFERENCES `user_role` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
