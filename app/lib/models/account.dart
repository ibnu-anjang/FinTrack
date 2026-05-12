import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

enum AccountCategory { asset, liability, equity, revenue, expense }

enum NormalBalance { debit, kredit }

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,             // = accountCode, dipakai sebagai Firestore doc ID
    required String accountCode,
    required String name,
    required AccountCategory category,
    required NormalBalance normalBalance,
    @Default(true) bool isActive,
    String? parentCode,
    String? group, // label grup display, override dari category label
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

/// Seed data COA standar Indonesia
const List<Map<String, dynamic>> kDefaultCoa = [
  // ASET
  {'id': '1000', 'accountCode': '1000', 'name': 'Kas', 'category': 'asset', 'normalBalance': 'debit'},
  {'id': '1010', 'accountCode': '1010', 'name': 'Bank', 'category': 'asset', 'normalBalance': 'debit'},
  {'id': '1100', 'accountCode': '1100', 'name': 'Piutang Usaha', 'category': 'asset', 'normalBalance': 'debit'},
  {'id': '1200', 'accountCode': '1200', 'name': 'Persediaan', 'category': 'asset', 'normalBalance': 'debit'},
  {'id': '1500', 'accountCode': '1500', 'name': 'Aset Tetap', 'category': 'asset', 'normalBalance': 'debit'},
  {'id': '1510', 'accountCode': '1510', 'name': 'Akumulasi Penyusutan', 'category': 'asset', 'normalBalance': 'kredit'},
  // KEWAJIBAN
  {'id': '2000', 'accountCode': '2000', 'name': 'Hutang Usaha', 'category': 'liability', 'normalBalance': 'kredit'},
  {'id': '2100', 'accountCode': '2100', 'name': 'Hutang Bank', 'category': 'liability', 'normalBalance': 'kredit'},
  {'id': '2200', 'accountCode': '2200', 'name': 'Hutang Pajak', 'category': 'liability', 'normalBalance': 'kredit'},
  // EKUITAS
  {'id': '3000', 'accountCode': '3000', 'name': 'Modal', 'category': 'equity', 'normalBalance': 'kredit'},
  {'id': '3100', 'accountCode': '3100', 'name': 'Laba Ditahan', 'category': 'equity', 'normalBalance': 'kredit'},
  // PENDAPATAN
  {'id': '4000', 'accountCode': '4000', 'name': 'Pendapatan Usaha', 'category': 'revenue', 'normalBalance': 'kredit'},
  {'id': '4100', 'accountCode': '4100', 'name': 'Pendapatan Lain-lain', 'category': 'revenue', 'normalBalance': 'kredit'},
  // BEBAN
  {'id': '5000', 'accountCode': '5000', 'name': 'HPP', 'category': 'expense', 'normalBalance': 'debit'},
  {'id': '5100', 'accountCode': '5100', 'name': 'Beban Gaji', 'category': 'expense', 'normalBalance': 'debit'},
  {'id': '5200', 'accountCode': '5200', 'name': 'Beban Sewa', 'category': 'expense', 'normalBalance': 'debit'},
  {'id': '5300', 'accountCode': '5300', 'name': 'Beban Utilitas', 'category': 'expense', 'normalBalance': 'debit'},
  {'id': '5400', 'accountCode': '5400', 'name': 'Beban Penyusutan', 'category': 'expense', 'normalBalance': 'debit'},
  {'id': '5900', 'accountCode': '5900', 'name': 'Beban Lain-lain', 'category': 'expense', 'normalBalance': 'debit'},
];
