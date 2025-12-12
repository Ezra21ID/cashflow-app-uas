import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:coba/services/constants.dart';
import 'transaction_model.dart';

class DatabaseService {
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static const String _dbUrl = kDatabaseUrl;

  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: _dbUrl
  ).ref();

  Future<void> addTransaction(TransactionModel transaction) async {
    if (_uid == null) throw Exception("User belum login!");

    try {
      await _dbRef.child('users').child(_uid!).child('transactions').push().set(transaction.toMap());
    } catch (e) {
      print("GAGAL KIRIM: $e");
      rethrow;
    }
  }

  Stream<List<TransactionModel>> get transactions {
    if (_uid == null) return Stream.value([]);

    return _dbRef.child('users').child(_uid!).child('transactions').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      List<TransactionModel> expenses = [];

      map.forEach((key, value) {
        try {
          expenses.add(TransactionModel.fromMap(
              key,
              Map<dynamic, dynamic>.from(value)
          ));
        } catch (e) {
          print("Error parsing data: $e");
        }
      });

      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    });
  }
}