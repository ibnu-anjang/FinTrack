import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/router/app_router.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<User?> authState(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn(String emailOrUsername, String password) async {
    state = const AsyncLoading();
    try {
      String email = emailOrUsername.trim();

      // Jika bukan email, lookup username di Firestore
      if (!email.contains('@')) {
        final doc = await FirebaseFirestore.instance
            .collection('usernames')
            .doc(email.toLowerCase())
            .get();
        if (!doc.exists) {
          state = AsyncError('Username tidak ditemukan', StackTrace.current);
          return;
        }
        email = doc.data()!['email'] as String;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(_message(e.code), StackTrace.current);
    }
  }

  Future<void> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    ref.read(isRegisteringProvider.notifier).start();
    User? user;
    bool userCreated = false;

    try {
      // Cek username sudah dipakai sebelum buat akun
      final usernameDoc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username.toLowerCase())
          .get();
      if (usernameDoc.exists) {
        state = AsyncError('Username sudah dipakai', StackTrace.current);
        return;
      }

      print('signUp: creating user...');
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      user = cred.user!;
      userCreated = true;
      print('signUp: user created ${user.uid}');

      final batch = FirebaseFirestore.instance.batch();
      final usernameRef = FirebaseFirestore.instance
          .collection('usernames')
          .doc(username.toLowerCase());
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      batch.set(usernameRef, {
        'email': email.trim(),
        'uid': user.uid,
        'name': name.trim(),
      });
      batch.set(userRef, {
        'name': name.trim(),
        'username': username.toLowerCase(),
        'email': email.trim(),
      });
      print('signUp: committing batch...');
      await batch.commit();
      print('signUp: batch committed');

      print('signUp: signing out...');
      await FirebaseAuth.instance.signOut().catchError((_) {});
      print('signUp: done');
      ref.read(isRegisteringProvider.notifier).done();
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      if (userCreated) {
        await user?.delete().catchError((_) {});
        await FirebaseAuth.instance.signOut().catchError((_) {});
      }
      ref.read(isRegisteringProvider.notifier).done();
      state = AsyncError(_registerMessage(e.code), StackTrace.current);
    } on FirebaseException catch (e, st) {
      if (userCreated) {
        await user?.delete().catchError((_) {});
        await FirebaseAuth.instance.signOut().catchError((_) {});
      }
      print('ERROR signUp FirebaseException: ${e.code} ${e.message}');
      ref.read(isRegisteringProvider.notifier).done();
      state = AsyncError('Gagal mendaftar, coba lagi', st);
    } catch (e, st) {
      if (userCreated) {
        await user?.delete().catchError((_) {});
        await FirebaseAuth.instance.signOut().catchError((_) {});
      }
      print('ERROR signUp: $e');
      print('STACKTRACE: $st');
      ref.read(isRegisteringProvider.notifier).done();
      state = AsyncError('Gagal mendaftar, coba lagi', StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  String _message(String code) => switch (code) {
    'user-not-found' => 'Akun tidak ditemukan',
    'wrong-password' || 'invalid-credential' => 'Password salah',
    'invalid-email' => 'Format email tidak valid',
    'too-many-requests' => 'Terlalu banyak percobaan, coba lagi nanti',
    'user-disabled' => 'Akun dinonaktifkan',
    _ => 'Login gagal, coba lagi',
  };

  String _registerMessage(String code) => switch (code) {
    'email-already-in-use' => 'Email sudah terdaftar',
    'weak-password' => 'Password terlalu lemah (minimal 6 karakter)',
    'invalid-email' => 'Format email tidak valid',
    _ => 'Gagal mendaftar: $code',
  };
}
