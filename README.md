# 🧠 My Mind (Cloud Native)

**My Mind** adalah aplikasi manajemen pengetahuan pribadi (Personal Knowledge Management / PKM) lintas platform (Web, Desktop, Mobile) yang indah, ringan, dan tersinkronisasi secara otomatis dengan **GitHub**.

Aplikasi ini menggunakan filosofi **Markdown Native**. Setiap huruf yang Anda ketik akan langsung dirender menjadi pratinjau (Live Preview) yang cantik, dan setiap 5 detik saat Anda berhenti mengetik, catatan Anda akan otomatis ditembakkan ke *Private Repository GitHub* Anda (Auto-Save).

---

## 🚀 Persiapan Awal (Setup)

Untuk menggunakan aplikasi ini, Anda tidak memerlukan *database* berbayar apa pun. Anda hanya perlu memanfaatkan akun GitHub gratis Anda.

### Langkah 1: Buat Repository di GitHub
1. Buka [GitHub](https://github.com/new).
2. Buat repository baru, misalnya dengan nama `catatan-rahasia`.
3. Setel visibilitasnya menjadi **Private** (agar catatan Anda tidak bisa dibaca publik).
4. **SANGAT PENTING**: Centang opsi **"Add a README file"**. (Aplikasi My Mind membutuhkan setidaknya satu file di dalam repository agar bisa berfungsi).
5. Klik **Create repository**.

### Langkah 2: Buat Fine-Grained Personal Access Token (PAT)
Aplikasi ini menggunakan sistem keamanan **Fine-Grained Token** dari GitHub, di mana Anda bisa membatasi agar aplikasi HANYA diizinkan mengakses satu repository khusus saja (tanpa bisa menyentuh data Anda yang lain).

1. Di GitHub, klik Foto Profil Anda (Pojok Kanan Atas) > **Settings**.
2. Scroll ke menu paling bawah sebelah kiri, klik **Developer settings**.
3. Klik **Personal access tokens** > **Fine-grained tokens**.
4. Klik tombol **Generate new token**.
5. Beri nama pada `Token name` (misal: "My Mind App").
6. Setel `Expiration` maksimal (contoh: 1 tahun).
7. **Pilih Repository Secara Eksklusif:**
   * Pada bagian **Repository access**, pilih opsi **"Only select repositories"**.
   * Pilih nama repository yang baru saja Anda buat di Langkah 1 (misal: `catatan-rahasia`).
8. **Berikan Akses Minimal (Permissions):**
   * Di bagian **Repository permissions** -> Cari **Contents**, ubah menjadi **Read and write**.
   * Di bagian **Account permissions** (ada di bawahnya) -> Cari **Gists**, ubah menjadi **Read and write** *(ini wajib agar fitur Share Link berfungsi)*.
9. Scroll ke bawah dan klik **Generate token**, lalu *copy* (salin) token panjang tersebut yang berawalan `github_pat_...`. Simpan token ini baik-baik!

---

## 📖 Panduan Penggunaan Aplikasi (Manual)

### 1. Masuk ke Aplikasi (Login)
Saat Anda menjalankan aplikasi (`flutter run -d chrome` atau `windows`), Anda akan disambut oleh layar "Mount Cloud Workspace".
* **Personal Access Token**: Tempel (paste) kode `ghp_...` yang baru saja Anda buat.
* **Target Repository**: Ketikkan nama akun GitHub Anda diikuti garis miring dan nama repo Anda. *(Contoh: `Manhakkim/catatan-rahasia`)*.
* Klik **Mount Cloud Workspace**.

### 2. Membaca & Menulis Catatan
* **Sidebar (Kiri)**: Menampilkan seluruh file `.md` yang ada di cloud Anda. Klik nama file untuk membukanya.
* **Editor (Tengah)**: Ketik catatan Anda di sini menggunakan format standar Markdown (`#`, `**bold**`, `- list`, dsb).
* **Live Preview (Kanan)**: Tampilan visual hasil akhir dari ketikan Anda, dirender secara *real-time*.

### 3. Fitur Auto-Sync (Cloud)
Anda **TIDAK PERLU** menekan tombol *Save*. 
Perhatikan indikator di pojok kanan atas aplikasi:
* Jika Anda sedang mengetik, ia akan bersiap-siap (Abu-abu).
* Jika Anda **berhenti mengetik selama 5 detik**, indikator akan berubah menjadi biru (Syncing).
* Jika berhasil, ia akan berubah hijau (Saved to Cloud). Jika internet terputus, ia akan berwarna merah.

### 4. Membuat Folder & File Baru
* Klik ikon **(+) Plus** di sidebar kiri.
* Untuk membuat **File Baru**: Ketikkan nama file, misal `jurnal.md`.
* Untuk membuat **Folder Baru**: GitHub tidak mengizinkan folder kosong, sehingga folder dibuat bersaman dengan file. Ketikkan nama folder, lalu garis miring `/`, lalu nama file. 
  *(Contoh: `jurnal_2026/hari_ini.md`)*. Aplikasi akan otomatis menciptakan folder tersebut.

### 5. Mengubah Nama (Rename) / Memindahkan File
* Pastikan file yang ingin diubah sedang terbuka di Editor.
* Klik tombol **✏️ (Edit/Rename)** di bagian atas (sebelah kiri indikator Sync).
* Ganti namanya menjadi yang baru. Jika Anda ingin memindahkannya ke dalam folder lain, cukup ubah strukturnya (contoh: dari `jurnal.md` menjadi `arsip/jurnal_lama.md`).
* Aplikasi akan menyalin isinya, menghapus file lama di Cloud, dan memuat ulang Sidebar Anda.

---
*Didesain dan dibangun dengan ❤️ menggunakan Flutter & arsitektur Clean Riverpod.*
