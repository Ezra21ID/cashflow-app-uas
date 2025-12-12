import 'package:coba/page/login.dart'; // Pastikan path ini sesuai
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  // 1. Pastikan Binding terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Mengatur status bar agar transparan/terlihat rapi
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  try {
    // 3. Manual Initialization (Jalan Pintas Konfigurasi)
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDj1bSs1yfIo4tEZat0X4AJ7KDS63efrIQ",
        appId: "1:329424993558:android:7773959e37c2617a27e437",
        messagingSenderId: "329424993558",
        projectId: "cashflowapp-aad0b",

        // PENTING: URL ini harus persis ada 'asia-southeast1'
        databaseURL: "https://cashflowapp-aad0b-default-rtdb.asia-southeast1.firebasedatabase.app",
      ),
    );
    print("✅ Firebase Berhasil Terhubung di main.dart!");
  } catch (e) {
    print("❌ Gagal menghubungkan Firebase: $e");
  }

  // 4. Jalankan Aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primaryColor: const Color(0xFF316D69),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF316D69)),
        useMaterial3: true,
        // Font global jika ingin menggunakan GoogleFonts (opsional)
        // textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // Kita tetap arahkan ke LoginPage.
      // Karena DatabaseService sudah kita ubah jadi "Public",
      // User bisa login sembarang atau langsung masuk dashboard nanti.
      home: const LoginPage(),
    );
  }
}