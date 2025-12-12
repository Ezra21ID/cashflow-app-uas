import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:coba/services/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- KONEKSI KE REALTIME DATABASE ---
  // Kita gunakan instanceFor dengan URL spesifik (sama seperti di database_service.dart)
  // agar data user tersimpan di server yang sama (Asia Southeast).
  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: kDatabaseUrl
  ).ref();

  // 1. SIGN UP (Daftar & Simpan Nama ke Realtime Database)
  Future<User?> signUp(String email, String password, String name) async {
    try {
      // Buat akun di Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = result.user;

      // Jika sukses, simpan data profil (Nama, Email) ke Realtime Database
      // Path: users/{uid}
      if (user != null) {
        await _dbRef.child('users').child(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }
      return user;
    } catch (e) {
      print("Error SignUp: $e");
      return null;
    }
  }

  // 2. SIGN IN (Login)
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return result.user;
    } catch (e) {
      print("Error SignIn: $e");
      return null;
    }
  }

  // 3. SIGN OUT (Keluar)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 4. GET CURRENT USER ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // 5. GET CURRENT USER NAME (Opsional: Untuk mengambil nama user)
  Future<String> getUserName() async {
    final uid = getCurrentUserId();
    if (uid == null) return "User";

    try {
      final snapshot = await _dbRef.child('users').child(uid).child('name').get();
      if (snapshot.exists) {
        return snapshot.value.toString();
      }
      return "User";
    } catch (e) {
      return "User";
    }
  }
}