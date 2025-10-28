// --- DIUBAH: Import untuk halaman chart ---
import 'package:coba/page/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coba/page/add_expanse_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

// --- Model untuk data transaksi (Tetap sama) ---
class Transaction {
  final String imagePath;
  final String title;
  final String subtitle;
  final String amount;
  final Color backgroundColor;
  final Color iconColor;

  Transaction({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.backgroundColor,
    required this.iconColor,
  });
}

// --- DIHAPUS: class dashboard() yang berisi MaterialApp telah dihapus ---
// --- Halaman ini sekarang LANGSUNG mengekspor FinanceHomePage ---

class FinanceHomePage extends StatefulWidget {
  const FinanceHomePage({super.key});

  @override
  State<FinanceHomePage> createState() => _FinanceHomePageState();
}

class _FinanceHomePageState extends State<FinanceHomePage> {
  bool _showAll = false;

  final List<Transaction> _transactions = [
    Transaction(
      imagePath: 'assets/icon/Groceries.svg',
      title: 'Groceries',
      subtitle: 'Today 10:00 AM',
      amount: '- \$100',
      backgroundColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF2196F3),
    ),
    // ... data transaksi lainnya
    Transaction(
      imagePath: 'assets/icon/Shopping.svg',
      title: 'Shopping',
      subtitle: 'Today 10:00 AM',
      amount: '- \$100',
      backgroundColor: const Color(0xFFFCE4EC),
      iconColor: const Color(0xFFE91E63),
    ),
    Transaction(
      imagePath: 'assets/icon/food.svg',
      title: 'Restaurant',
      subtitle: 'Yesterday 07:30 PM',
      amount: '- \$55',
      backgroundColor: const Color(0xFFE0F2F1),
      iconColor: const Color(0xFF009688),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // --- BARU: Menambahkan SystemChrome di build ---
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 30),
            _buildRecentTransactions(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        backgroundColor: const Color(0xFF2C7873),
        child: const Icon(Icons.add_circle, color: Colors.white),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                // --- DIUBAH: Icon Home (Aktif) ---
                icon: const Icon(Icons.home, color: Color(0xFF2C7873)),
                onPressed: () {
                  // Tidak melakukan apa-apa, sudah di home
                },
              ),
              const SizedBox(width: 40), // Ruang untuk FAB
              IconButton(
                // --- DIUBAH: Icon Chart (Tidak Aktif) ---
                icon: const Icon(Icons.bar_chart, color: Colors.grey),
                onPressed: () {
                  // --- DIUBAH: Navigasi ke ChartPage ---
                  // Menggunakan pushReplacement agar tidak menumpuk halaman
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ChartPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ... (Semua widget helper lainnya seperti _buildHeader, _buildRecentTransactions, dll, tetap sama) ...
  Widget _buildHeader(BuildContext context) {
    // ... (kode header Anda tetap sama)
    return SizedBox(
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2C7873),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=32'),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome!',
                          style:
                          TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('Shibab Rahman',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF348D87),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('\$ 2,548.00',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIncomeExpense(
                          'Income', '\$ 15,274.00', Icons.arrow_downward),
                      _buildIncomeExpense(
                          'Expenses', '\$ 2,436.00', Icons.arrow_upward),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpense(String title, String amount, IconData icon) {
    // ... (kode ini tetap sama)
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 14)),
            Text(amount,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }

  Widget _buildRecentTransactions() {
    final transactionsToShow =
    _showAll ? _transactions : _transactions.sublist(0, 3); // Tampilkan 3 awal

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Transactions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          ...transactionsToShow.map((transaction) {
            return _buildTransactionItem(
              transaction.imagePath,
              transaction.title,
              transaction.subtitle,
              transaction.amount,
              transaction.backgroundColor,
              transaction.iconColor,
            );
          }).toList(),
        ],
      ),
    );
  }

  // --- DIUBAH: Saya perbaiki widget ini agar menampilkan SVG ---
  // (Anda salah menggunakannya di kode asli, hanya menampilkan lingkaran)
  Widget _buildTransactionItem(String imagePath, String title, String subtitle,
      String amount, Color backgroundColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            // --- PERBAIKAN: Menampilkan SVG di dalam lingkaran ---
            child: SvgPicture.asset(
              imagePath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            // --- Akhir Perbaikan ---
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(amount,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
        ],
      ),
    );
  }
}