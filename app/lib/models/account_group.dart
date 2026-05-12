import 'package:freezed_annotation/freezed_annotation.dart';
import 'account.dart';

part 'account_group.freezed.dart';
part 'account_group.g.dart';

@freezed
abstract class AccountGroup with _$AccountGroup {
  const factory AccountGroup({
    required String id,
    required String name,
    required AccountCategory accountType, // tipe akuntansi (asset/liability/dll)
    @Default(0) int order,
  }) = _AccountGroup;

  factory AccountGroup.fromJson(Map<String, dynamic> json) =>
      _$AccountGroupFromJson(json);
}

/// Grup default sesuai 5 kategori standar
List<AccountGroup> kDefaultGroups() => [
      const AccountGroup(id: 'asset', name: '1. ASET', accountType: AccountCategory.asset, order: 1),
      const AccountGroup(id: 'liability', name: '2. KEWAJIBAN', accountType: AccountCategory.liability, order: 2),
      const AccountGroup(id: 'equity', name: '3. EKUITAS', accountType: AccountCategory.equity, order: 3),
      const AccountGroup(id: 'revenue', name: '4. PENDAPATAN', accountType: AccountCategory.revenue, order: 4),
      const AccountGroup(id: 'expense', name: '5. BEBAN', accountType: AccountCategory.expense, order: 5),
    ];
