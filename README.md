# FinTrack

Aplikasi pencatatan keuangan dengan pembukuan **double-entry** (debit–kredit) — bukan sekadar catat pemasukan/pengeluaran, tapi pakai *Chart of Accounts* dan jurnal layaknya akuntansi beneran. Mendukung **multi-workspace** sehingga bisa memisahkan pembukuan beberapa entitas/usaha dalam satu aplikasi.

**Stack:** Flutter · Firebase (Firestore + Auth) · Riverpod · Freezed · go_router

---

## Fitur

- **Multi-workspace** — kelola beberapa pembukuan terpisah dalam satu akun
- **Chart of Accounts (CoA)** — daftar akun terstruktur per kelompok (aset, kewajiban, ekuitas, pendapatan, beban)
- **Jurnal double-entry** — input transaksi debit/kredit yang selalu balance
- **Auth** — login & register via Firebase
- **Dashboard** — ringkasan posisi keuangan
- **Format mata uang** — tampilan angka rapi (Rupiah)

## Struktur Project

```
FinTrack/
└── app/                        ← Aplikasi Flutter
    └── lib/
        ├── core/               ← router, theme, providers, utils
        ├── models/             ← model (Freezed): account, journal_entry, transaction, workspace
        └── features/
            ├── auth/           ← login, register
            ├── dashboard/      ← ringkasan
            ├── gl/             ← general ledger: CoA, jurnal
            └── workspace/      ← manajemen workspace
```

## Setup Lokal

### Prasyarat
- Flutter SDK 3.11+ (Dart SDK 3.x)
- Project Firebase (Firestore + Authentication aktif)

### Langkah

```bash
git clone https://github.com/ibnu-anjang/FinTrack
cd FinTrack/app
flutter pub get
```

Konfigurasi Firebase (file `google-services.json` / `firebase_options.dart` **tidak** di-commit untuk project baru — generate sendiri):

```bash
flutterfire configure
```

Generate kode (Freezed / Riverpod / router):

```bash
dart run build_runner build --delete-conflicting-outputs
```

Jalankan:

```bash
flutter run
```

## Lisensi

[MIT](LICENSE) © 2026 Ibnu Anjang Maulidi
