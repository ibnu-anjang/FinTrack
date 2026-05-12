import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack_app/core/utils/currency_formatter.dart';
import 'package:fintrack_app/features/auth/auth_provider.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formatRupiah converts sen to Rupiah string', () {
      expect(formatRupiah(150000), contains('1.500'));
      expect(formatRupiah(100000000), contains('1.000.000'));
    });

    test('formatRupiahBulat formats integer rupiah', () {
      expect(formatRupiahBulat(1500000), contains('1.500.000'));
      expect(formatRupiahBulat(0), contains('0'));
    });

    test('parseRupiah parses formatted string back to int', () {
      expect(parseRupiah('Rp 1.500.000'), equals(1500000));
      expect(parseRupiah('Rp 0'), equals(0));
    });
  });

  group('AppMode', () {
    test('AppMode has umkm and enterprise values', () {
      expect(AppMode.values, containsAll([AppMode.umkm, AppMode.enterprise]));
      expect(AppMode.umkm.name, equals('umkm'));
      expect(AppMode.enterprise.name, equals('enterprise'));
    });
  });
}
