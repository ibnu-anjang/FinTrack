# Panduan Setup Firebase untuk FinTrack Enterprise

Dokumen ini menjelaskan langkah-langkah setup Firebase dari nol hingga app bisa berjalan.

---

## Prasyarat

- Akun Google (sudah login di browser)
- Flutter SDK terinstall
- Firebase CLI terinstall (`firebase login` sudah berhasil)

---

## Bagian 1 — Buat Project Firebase

1. Buka [console.firebase.google.com](https://console.firebase.google.com)
2. Klik **Add project**
3. Nama project: `FINTRACK` → Continue
4. Google Analytics: boleh di-disable → **Create project**
5. Tunggu hingga project selesai dibuat → **Continue**

---

## Bagian 2 — Setup Authentication

Authentication digunakan agar hanya user terdaftar yang bisa mengakses data.

1. Di sidebar Firebase Console → klik **Authentication**
2. Klik **Get started**
3. Tab **Sign-in method** → klik **Email/Password**
4. Toggle **Enable** → **Save**

> Tanpa langkah ini, login dan daftar akun akan selalu gagal.

---

## Bagian 3 — Setup Firestore Database

Firestore adalah database utama yang menyimpan semua data akuntansi.

1. Di sidebar → klik **Firestore Database**
2. Klik **Create database**
3. Pilih **Start in production mode** → **Next**
4. Pilih region: `asia-southeast1 (Singapore)` → **Enable**
5. Tunggu hingga database selesai dibuat

### Pasang Security Rules

Security Rules mengatur siapa yang boleh baca/tulis data. Tanpa ini, semua request akan ditolak.

1. Di Firestore → klik tab **Rules**
2. Hapus semua teks yang ada
3. Copy-paste rules berikut:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }
    match /accounts/{accountId} {
      allow read, write: if isAuthenticated();
    }
    match /transactions/{txId} {
      allow read, create: if isAuthenticated();
      allow update: if isAuthenticated() && resource.data.isPosted == false;
      allow delete: if false;
      match /journal_entries/{entryId} {
        allow read, create: if isAuthenticated();
        allow update, delete: if false;
      }
    }
  }
}
```

4. Klik **Publish**

> **Penjelasan rules:**
> - `accounts` — user login bisa baca dan tulis akun
> - `transactions` — bisa dibuat dan dibaca, tapi tidak bisa dihapus. Update hanya boleh jika `isPosted == false` (jurnal yang sudah diposting tidak bisa diubah — sesuai TRD)
> - `journal_entries` — sub-collection entries, hanya bisa dibuat dan dibaca, tidak bisa diubah/hapus

---

## Bagian 4 — Hubungkan Flutter ke Firebase

Langkah ini dilakukan satu kali dari terminal di folder `app/`.

```bash
# Install FlutterFire CLI (jika belum)
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Masuk ke folder app
cd /home/iben/FIntrack/app

# Jalankan konfigurasi
flutterfire configure
```

Saat muncul prompt:
- Pilih project: **fintrack** (atau nama project yang dibuat)
- Pilih platform: **Android** dan **Web** (tekan Space untuk pilih, Enter untuk konfirmasi)

Perintah ini otomatis membuat file `lib/firebase_options.dart` dan `android/app/google-services.json`.

---

## Bagian 5 — Jalankan App

```bash
# Mode development (lebih ringan dari debug)
flutter run --profile -d chrome

# Atau di Android (colok HP / emulator)
flutter run --profile -d android
```

> **Catatan:** Hindari `flutter run` tanpa flag — debug mode sangat berat dan membuat kipas laptop kencang. Gunakan `--profile` untuk development sehari-hari.

---

## Bagian 6 — Buat Akun Pertama

1. Buka app di browser/device
2. Tap **Belum punya akun? Daftar**
3. Isi Nama, Email, Password
4. Setelah berhasil daftar → otomatis masuk ke Dashboard
5. Di Dashboard → **Chart of Accounts** → tap ikon refresh untuk muat 19 akun default

---

## Troubleshooting

| Error | Penyebab | Solusi |
|-------|----------|--------|
| `channel-error: Unable to establish connection` | `firebase_options.dart` belum dibuat | Jalankan `flutterfire configure` |
| `PlatformException: DefaultFirebaseOptions not configured for linux` | Platform Linux tidak dikonfigurasi | Jalankan `flutter run -d chrome` atau `-d android` |
| Login/daftar gagal tanpa error jelas | Email/Password auth belum di-enable | Aktifkan di Firebase Console → Authentication |
| Loading forever di jurnal/COA | Firestore Rules memblokir read | Pasang Security Rules (Bagian 3) |
| `PERMISSION_DENIED` | Rules tidak mengizinkan operasi | Cek rules dan pastikan user sudah login |
