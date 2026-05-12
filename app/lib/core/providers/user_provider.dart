import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_provider.dart';

final userDisplayNameProvider = FutureProvider.autoDispose<String>((ref) async {
  final authAsync = ref.watch(authStateProvider);
  final user = authAsync.asData?.value;
  if (user == null) return '-';
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  final name = doc.data()?['name'] as String?;
  if (name != null && name.trim().isNotEmpty) return name.trim();
  return user.email ?? '-';
});
