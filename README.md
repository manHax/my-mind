# 🧠 My Mind (Cloud Native)

**My Mind** adalah aplikasi manajemen pengetahuan pribadi (Personal Knowledge Management / PKM) lintas platform (Web, Desktop, Mobile) yang indah, ringan, dan tersinkronisasi secara otomatis dengan **GitHub**.

Aplikasi ini menggunakan filosofi **Markdown Native** dan memiliki berbagai fitur modern untuk mengatur pengetahuan Anda, termasuk metadata YAML Frontmatter.

---

## ✨ Fitur Utama Terbaru
* **Cloud-Native Sync**: Sinkronisasi langsung ke Private Repository GitHub melalui API tanpa perlu *command line* Git lokal.
* **Auto-Save & Toggle**: Perubahan Anda akan otomatis disimpan tiap 5 detik saat berhenti mengetik. Fitur ini bisa dinonaktifkan di Settings jika Anda ingin menggunakan tombol manual.
* **Smart View Modes**: Tiga mode tampilan fleksibel: *Editor Only* (fokus menulis), *Split View* (menulis sekaligus pratinjau), dan *Reader Only* (fokus membaca).
* **Rich Metadata Management**: Mendukung format standar *YAML Frontmatter*. Anda bisa mengelola *Title, Tags, Date, Favorite,* dan *Published* dengan mudah melalui antarmuka *Edit Metadata*.
* **Public Sharing**: Bagikan catatan *private* Anda ke publik dengan satu klik via *GitHub Gists*.

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
Aplikasi ini menggunakan sistem keamanan **Fine-Grained Token** dari GitHub, di mana Anda bisa membatasi agar aplikasi HANYA diizinkan mengakses satu repository khusus saja.

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
* **Personal Access Token**: Tempel kode `ghp_...` atau `github_pat_...` Anda.
* **Target Repository**: Ketikkan nama akun GitHub Anda diikuti garis miring dan nama repo Anda. *(Contoh: `Manhakkim/catatan-rahasia`)*.
* Klik **Mount Cloud Workspace**.

### 2. Membaca & Menulis Catatan
Gunakan grup ikon **View Mode** di baris menu atas (kanan) untuk mengatur tampilan ruang kerja:
* 📝 **Editor Only**: Menampilkan panel teks editor saja untuk fokus menulis.
* 🗂️ **Split View**: Tampilan berdampingan (Editor di kiri, Preview di kanan).
* 📖 **Reader Only**: Menampilkan Markdown yang sudah dirender dengan indah untuk fokus membaca.

### 3. Mengatur Metadata (YAML Frontmatter)
Setiap catatan mendukung *frontmatter* YAML (Title, Tags, Date, Favorite, Published).
* Buka catatan, lalu klik ikon **slider/tune (Edit Metadata)** di deretan menu atas.
* Atur parameter sesuai kebutuhan, lalu klik **Save**. Aplikasi akan langsung memformulasikannya ke format YAML yang rapi di awal file Anda.

### 4. Fitur Auto-Sync & Manual Save
Secara bawaan, aplikasi akan otomatis mem-push perubahan Anda ke GitHub ketika Anda berhenti mengetik selama 5 detik.
* Jika Anda lebih suka metode konvensional, klik ikon ⚙️ **Settings** di bawah kiri (Sidebar) dan nonaktifkan fitur *Auto-save*.
* Saat dimatikan, sebuah tombol 💾 **Save** akan muncul di baris menu atas untuk Anda tekan saat ingin menembakkan catatan ke GitHub.

### 5. Membuat, Mengubah, dan Memindahkan File/Folder
* **Buat Baru**: Klik ikon **(+) Plus** di pojok atas sidebar kiri. Untuk mengorganisir menggunakan folder, cukup gunakan simbol garis miring `/` (contoh: `jurnal_2026/hari_ini.md`).
* **Rename / Move**: Buka file yang dimaksud, lalu klik ikon **✏️ (Rename)** di menu atas. Ubah struktur teksnya (contoh: pindahkan `jurnal.md` ke folder lain menjadi `arsip/jurnal.md`).

### 6. Berbagi Catatan ke Publik
* Ingin membagikan file rahasia secara individual? Klik ikon **📤 (Share as Public Link)** di menu atas.
* Aplikasi akan menggunakan token Anda untuk menembak API Gist, dan menghasilkan tautan *shareable* yang bisa langsung di-copy!

---
*Didesain dan dibangun dengan ❤️ menggunakan Flutter & arsitektur Clean Riverpod.*
