import 'package:coba/page/add_expanse_page.dart';
import 'package:coba/page/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// --- Saya salin model Transaction dari dashboard.dart agar bisa dipakai di sini ---
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

// --- Model BARU untuk data di bagian "Categories" ---
class CategoryExpense {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final double progress; // nilai dari 0.0 sampai 1.0

  CategoryExpense({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.progress,
  });
}

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // --- Data untuk "Categories" (berdasarkan gambar) ---
  final List<CategoryExpense> _categoryExpenses = [
    CategoryExpense(
      icon: Icons.shopping_cart_outlined,
      color: Colors.blue.shade700,
      title: 'Groceries',
      subtitle: '12 transactions',
      progress: 0.7,
    ),
    CategoryExpense(
      icon: Icons.fastfood_outlined,
      color: Colors.orange.shade700,
      title: 'Food & Drinks',
      subtitle: '8 transactions',
      progress: 0.5,
    ),
    CategoryExpense(
      icon: Icons.movie_outlined,
      color: Colors.teal.shade700,
      title: 'Entertainment',
      subtitle: '5 transactions',
      progress: 0.4,
    ),
    CategoryExpense(
      icon: Icons.fitness_center_outlined,
      color: Colors.green.shade700,
      title: 'Fitness',
      subtitle: '3 transactions',
      progress: 0.3,
    ),
    CategoryExpense(
      icon: Icons.directions_bus_outlined,
      color: Colors.purple.shade700,
      title: 'Transportation',
      subtitle: '6 transactions',
      progress: 0.6,
    ),
    CategoryExpense(
      icon: Icons.shield_outlined,
      color: Colors.cyan.shade700,
      title: 'Insurance',
      subtitle: '2 transactions',
      progress: 0.2,
    ),
    CategoryExpense(
      icon: Icons.checkroom_outlined,
      color: Colors.pink.shade700,
      title: 'Shopping',
      subtitle: '7 transactions',
      progress: 0.8,
    ),
    CategoryExpense(
      icon: Icons.more_horiz_outlined,
      color: Colors.grey.shade700,
      title: 'Other',
      subtitle: '4 transactions',
      progress: 0.1,
    ),
  ];

  // --- Data untuk "Recent Transactions" (saya ambil dari dashboard.dart) ---
  final List<Transaction> _transactions = [
    Transaction(
      imagePath: 'assets/icon/Groceries.svg',
      title: 'Groceries',
      subtitle: 'Today 10:00 AM',
      amount: '- \$100',
      backgroundColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF2196F3),
    ),
    Transaction(
      imagePath: 'assets/icon/entertainment.svg',
      title: 'Entertainment',
      subtitle: 'Today 10:00 AM',
      amount: '- \$100',
      backgroundColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF9800),
    ),
    Transaction(
      imagePath: 'assets/icon/Transportation.svg',
      title: 'Transportation',
      subtitle: 'Today 10:00 AM',
      amount: '- \$100',
      backgroundColor: const Color(0xFFE8EAF6),
      iconColor: const Color(0xFF3F51B5),
    ),
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
    // Warna background dari gambar (sedikit pink)
    const scaffoldBgColor = Color(0xFFF9F9F9);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMonthSelector(),
                const SizedBox(height: 24),
                _buildBalanceCard(),
                const SizedBox(height: 24),
                _buildCategoriesSection(),
                const SizedBox(height: 24),
                _buildRecentTransactionsSection(),
              ],
            ),
          ),
        ),
      ),

      // --- Saya gunakan BottomAppBar yang sama dari dashboard.dart ---
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
                // Icon Home (tidak aktif)
                icon: const Icon(Icons.home, color: Colors.grey),
                onPressed: () {
                  // Kembali ke Dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FinanceHomePage()),
                  );
                },
              ),
              const SizedBox(width: 40), // Ruang untuk FAB
              IconButton(
                // Icon Chart (aktif)
                icon: const Icon(Icons.bar_chart, color: Color(0xFF2C7873)),
                onPressed: () {
                  // Tidak melakukan apa-apa karena sudah di halaman chart
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk pemilih bulan (sesuai gambar)
  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol Bulan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.chevron_left, color: Colors.grey[600]),
              const SizedBox(width: 8),
              const Text(
                'September 2025',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.play_arrow, color: Colors.grey[600], size: 20),
            ],
          ),
        ),
        // Tombol Kalender
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Icon(Icons.calendar_today_outlined,
              color: Colors.grey[700], size: 20),
        ),
      ],
    );
  }

  // Widget untuk kartu saldo (sesuai gambar)
  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // Warna gelap dari gambar
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '\$ 2,548.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$ 500.00',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar kustom
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 10,
              color: Colors.grey[800],
              child: Row(
                children: [
                  Expanded(
                    flex: 80, // 80% Balance
                    child: Container(color: Colors.white70),
                  ),
                  Expanded(
                    flex: 20, // 20% Expense (500 dari 2548)
                    child: Container(color: Colors.red[400]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.circle, color: Colors.white70, size: 10),
              const SizedBox(width: 4),
              Text('Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 16),
              Icon(Icons.circle, color: Colors.red[400], size: 10),
              const SizedBox(width: 4),
              Text('Expense',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  // Widget untuk bagian kategori (sesuai gambar)
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categoryExpenses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.8, // Membuat item lebih lebar
            ),
            itemBuilder: (context, index) {
              final item = _categoryExpenses[index];
              return _buildCategoryExpenseItem(
                  item.icon, item.color, item.title, item.subtitle, item.progress);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryExpenseItem(IconData icon, Color color, String title,
      String subtitle, double progress) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 6,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  // Widget untuk "Recent Transactions" (mirip dashboard)
  Widget _buildRecentTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Membangun list item dari data
        ..._transactions.map((transaction) {
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
    );
  }

  // --- Widget ini saya salin dari dashboard.dart ---
  // --- !! PENTING: Saya perbaiki agar icon SVG tampil ---
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
            // --- INI PERBAIKANNYA: Menampilkan SVG ---
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