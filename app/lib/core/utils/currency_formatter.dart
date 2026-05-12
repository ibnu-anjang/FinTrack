import 'package:intl/intl.dart';

final _formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

/// Converts integer sen to formatted Rupiah string.
/// e.g. 150000 → "Rp 1.500"
String formatRupiah(int sen) => _formatter.format(sen / 100);

/// Converts integer rupiah (no decimal) to formatted string.
/// e.g. 1500000 → "Rp 1.500.000"
String formatRupiahBulat(int rupiah) => _formatter.format(rupiah);

/// Parses "Rp 1.500.000" back to integer rupiah.
int parseRupiah(String text) {
  final cleaned = text.replaceAll(RegExp(r'[Rp\s\.]'), '').replaceAll(',', '');
  return int.tryParse(cleaned) ?? 0;
}
