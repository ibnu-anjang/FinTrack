# Laporan Progress Development — FinTrack Enterprise

**Terakhir diperbarui:** 6 Mei 2026  
**Status:** Phase 2 selesai, siap lanjut Phase 3

---

## Ringkasan

Pembangunan FinTrack Enterprise mengikuti arsitektur di TRD: Flutter + Firebase Firestore + Riverpod. Dua phase pertama sudah selesai dan kode sudah diselaraskan ulang dengan PRD, TRD, dan ERD.

---

## Yang Sudah Dikerjakan

### Phase 1 — Fondasi

| Komponen | File | Status |
|----------|------|--------|
| Tema & warna (hijau #1B8A5A) | `lib/core/theme/app_theme.dart` | ✅ |
| Currency formatter (Sen → Rp) | `lib/core/utils/currency_formatter.dart` | ✅ |
| Navigation (go_router + auth redirect) | `lib/core/router/app_router.dart` | ✅ |
| Firebase init + ProviderScope | `lib/main.dart` | ✅ |
| Login screen | `lib/features/auth/login_screen.dart` | ✅ |
| Register screen | `lib/features/auth/register_screen.dart` | ✅ |
| Auth provider (stream + notifier) | `lib/features/auth/auth_provider.dart` | ✅ |
| Dashboard dengan menu navigasi | `lib/features/dashboard/dashboard_screen.dart` | ✅ |

### Phase 2 — General Ledger

| Komponen | File | Status |
|----------|------|--------|
| Model Account (+ NormalBalance enum) | `lib/models/account.dart` | ✅ |
| Model JournalEntry (amount Sen) | `lib/models/journal_entry.dart` | ✅ |
| Model Transaction (tanpa embedded entries) | `lib/models/transaction.dart` | ✅ |
| COA provider (stream + seed 19 akun) | `lib/features/gl/providers/coa_provider.dart` | ✅ |
| Journal provider (save + post + reversal) | `lib/features/gl/providers/journal_provider.dart` | ✅ |
| Chart of Accounts screen | `lib/features/gl/screens/coa_screen.dart` | ✅ |
| Daftar Jurnal screen | `lib/features/gl/screens/journal_list_screen.dart` | ✅ |
| Form Buat Jurnal | `lib/features/gl/screens/journal_form_screen.dart` | ✅ |
| Entry row widget (input debit/kredit) | `lib/features/gl/widgets/entry_row_widget.dart` | ✅ |

---

## Koreksi yang Sudah Dilakukan (Sesuai Dokumen)

Selama development ditemukan beberapa penyimpangan dari PRD/TRD/ERD yang sudah diperbaiki:

1. **Struktur Firestore** — `journal_entries` dipindah dari embedded array menjadi sub-collection `transactions/{id}/journal_entries/{entryId}` sesuai ERD
2. **Satuan amount** — dikembalikan ke **Sen** (integer × 100) sesuai TRD. Input user tetap dalam Rupiah, konversi dilakukan di widget sebelum disimpan
3. **accountRef** — menggunakan path Firestore `accounts/{accountCode}` sesuai ERD, dengan denormalisasi `accountCode` dan `accountName` untuk efisiensi display
4. **UMKM/Enterprise mode** — dihapus karena tidak ada di PRD. App ini murni Enterprise
5. **Packages** — ditambahkan `share_plus`, `path_provider`, `uuid` yang dibutuhkan TRD
6. **Onboarding screen** — dihapus (tidak ada di PRD)
7. **Compound query** — query COA disederhanakan (hapus `.where isActive`) untuk menghindari kebutuhan composite index Firestore. Filter dilakukan di Flutter

---

## Struktur Folder Saat Ini

```
app/
└── lib/
    ├── core/
    │   ├── router/app_router.dart
    │   ├── theme/app_theme.dart
    │   └── utils/currency_formatter.dart
    ├── features/
    │   ├── auth/
    │   │   ├── auth_provider.dart
    │   │   ├── login_screen.dart
    │   │   └── register_screen.dart
    │   ├── dashboard/
    │   │   └── dashboard_screen.dart
    │   └── gl/
    │       ├── providers/
    │       │   ├── coa_provider.dart
    │       │   └── journal_provider.dart
    │       ├── screens/
    │       │   ├── coa_screen.dart
    │       │   ├── journal_form_screen.dart
    │       │   └── journal_list_screen.dart
    │       └── widgets/
    │           └── entry_row_widget.dart
    ├── models/
    │   ├── account.dart
    │   ├── journal_entry.dart
    │   └── transaction.dart
    └── main.dart
```

---

## Struktur Firestore (sesuai ERD)

```
accounts/
  {accountCode}          ← doc ID = accountCode (e.g. "1000")
    accountCode: string
    name: string
    category: enum (asset|liability|equity|revenue|expense)
    normalBalance: enum (debit|kredit)
    isActive: boolean

transactions/
  {transactionId}        ← UUID v4
    date: Timestamp
    description: string
    sourceModule: string  (GL|AR|AP|INV|FA)
    isPosted: boolean
    createdBy: string     (userId — audit trail)
    deviceId: string?
    reversalOfId: string?

  journal_entries/       ← sub-collection
    {entryId}            ← UUID v4
      accountRef: string  (path: "accounts/{code}")
      accountCode: string (denormalized)
      accountName: string (denormalized)
      amount: integer     (dalam Sen)
      side: enum (debit|kredit)
```

---

## Aturan Kritis yang Sudah Diimplementasi

| Aturan | Implementasi |
|--------|-------------|
| Double-entry | Validasi `Σ debit == Σ kredit` di `JournalNotifier.saveJournal()` sebelum write ke Firestore |
| Immutability | Firestore Security Rules: `allow update: if resource.data.isPosted == false` |
| Amount integer | Semua amount disimpan dalam Sen (`int`), dikonversi ke Rupiah hanya saat display |
| Audit trail | Setiap transaksi menyimpan `createdBy` (userId) dan `deviceId` |
| ACID | Save jurnal menggunakan `batch.commit()` untuk atomicity header + semua entries |

---

## Phase Berikutnya

### Phase 3 — Modul Operasional
- [ ] AR & Sales — Invoice, Piutang, Aging Report
- [ ] AP & Purchases — Tagihan supplier, Jadwal bayar
- [ ] Cash & Bank — Rekonsiliasi, Kas Kecil
- [ ] Inventory & Costing — FIFO/Average, HPP otomatis
- [ ] Fixed Assets — Penyusutan otomatis bulanan

### Phase 4 — Laporan & Export
- [ ] Trial Balance (Neraca Saldo)
- [ ] Laporan Laba/Rugi
- [ ] Neraca (Balance Sheet)
- [ ] Laporan Arus Kas
- [ ] Export semua ke .xlsx (pakai package `excel` + `share_plus`)

---

## Cara Menjalankan

```bash
cd /home/iben/FIntrack/app

# Install dependencies
flutter pub get

# Generate code (Freezed + Riverpod)
flutter pub run build_runner build

# Jalankan (gunakan --profile agar tidak berat)
flutter run --profile -d chrome
```

> Sebelum menjalankan, pastikan Firebase sudah dikonfigurasi.
> Lihat: `docs/PANDUAN_FIREBASE_SETUP.md`
