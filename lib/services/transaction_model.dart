class TransactionModel {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final String type;

  TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
  });

  // Format dari JSON Database ke Aplikasi
  factory TransactionModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return TransactionModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? 'Other',
      amount: (map['amount'] ?? 0).toDouble(),
      // Parse tanggal dari String ISO8601
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      type: map['type'] ?? 'expense',
    );
  }

  // Format dari Aplikasi ke JSON Database
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(), // Simpan tanggal sebagai Text
      'type': type,
    };
  }
}