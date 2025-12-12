import 'package:coba/page/add_expanse_page.dart';
import 'package:coba/page/dashboard.dart';
import 'package:coba/services/database_service.dart';
import 'package:coba/services/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // --- Helper Icon & Color ---
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Groceries': return Icons.shopping_cart_outlined;
      case 'Food & Drinks': return Icons.fastfood_outlined;
      case 'Entertainment': return Icons.movie_outlined;
      case 'Fitness': return Icons.fitness_center_outlined;
      case 'Transportation': return Icons.directions_bus_outlined;
      case 'Insurance': return Icons.shield_outlined;
      case 'Shopping': return Icons.checkroom_outlined;
      default: return Icons.more_horiz_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Groceries': return Colors.blue.shade700;
      case 'Food & Drinks': return Colors.orange.shade700;
      case 'Entertainment': return Colors.teal.shade700;
      case 'Fitness': return Colors.green.shade700;
      case 'Transportation': return Colors.purple.shade700;
      case 'Insurance': return Colors.cyan.shade700;
      case 'Shopping': return Colors.pink.shade700;
      default: return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: DatabaseService().transactions,
      builder: (context, snapshot) {
        List<TransactionModel> allData = [];
        double totalBalance = 0;
        double totalExpense = 0;
        double totalIncome = 0;
        Map<String, double> categoryTotals = {};
        Map<String, int> categoryCount = {};

        if (snapshot.hasData) {
          allData = snapshot.data!;
          for (var tx in allData) {
            if (tx.type == 'income') {
              totalIncome += tx.amount;
            } else {
              totalExpense += tx.amount;
              categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0) + tx.amount;
              categoryCount[tx.category] = (categoryCount[tx.category] ?? 0) + 1;
            }
          }
          // Rumus Saldo: Pemasukan - Pengeluaran
          totalBalance = totalIncome - totalExpense;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
            // Menggunakan SafeArea agar tidak tertutup status bar
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Month Selector (Sekarang di paling atas, background putih)
                    _buildMonthSelector(),

                    const SizedBox(height: 20),

                    // 2. Balance Card (Sekarang warnanya Hijau Teal)
                    _buildBalanceCard(totalBalance, totalIncome, totalExpense),

                    const SizedBox(height: 20),

                    // 3. Categories Section
                    _buildCategoriesSection(categoryTotals, categoryCount, totalExpense),

                    const SizedBox(height: 80), // Spasi untuk Bottom Nav
                  ],
                ),
              ),
            ),
          ),

          // --- FAB & Bottom Nav ---
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpensePage()));
            },
            backgroundColor: const Color(0xFF2C7873),
            elevation: 2.0,
            child: const Icon(Icons.add_circle, color: Colors.white),
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
                    icon: const Icon(Icons.home, color: Colors.grey),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FinanceHomePage()));
                    },
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.bar_chart, color: Color(0xFF2C7873)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol Bulan: Putih dengan Text Hitam
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30), // Lebih bulat seperti kapsul
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.chevron_left, color: Colors.black54),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMMM yyyy').format(DateTime.now()),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.black54, size: 20),
            ],
          ),
        ),
        // Tombol Kalender: Putih dengan Icon Hitam
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 20),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(double balance, double income, double expense) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Hitung persentase bar
    double expenseRatio = income == 0 ? 0 : (expense / income);
    if (expenseRatio > 1.0) expenseRatio = 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C7873), // UBAH: Warna Hijau Teal sesuai gambar
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C7873).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row atas: Saldo dan Pengeluaran Kecil
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currencyFormatter.format(balance),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormatter.format(expense),
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 20),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 12, // Sedikit lebih tebal
              color: Colors.white.withOpacity(0.3), // Background bar transparan
              child: Row(
                children: [
                  // Sisa Saldo (Putih/Abu) vs Terpakai (Merah/Warna Lain)
                  // Sesuai gambar: Bar penuh warna abu, ujungnya merah?
                  // Kita buat simple: Bar Expense berwarna Merah, sisanya transparan/putih
                  Expanded(
                      flex: (expenseRatio * 100).toInt(),
                      child: Container(color: Colors.redAccent)
                  ),
                  Expanded(
                      flex: ((1 - expenseRatio) * 100).toInt(),
                      child: Container(color: Colors.transparent)
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Label Legend
          Row(
            children: [
              const Icon(Icons.circle, color: Colors.white70, size: 8),
              const SizedBox(width: 4),
              const Text('Balance', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(width: 16),
              const Icon(Icons.circle, color: Colors.redAccent, size: 8),
              const SizedBox(width: 4),
              const Text('Expense', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(Map<String, double> categoryTotals, Map<String, int> categoryCount, double totalExpense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 16),

        categoryTotals.isEmpty
            ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text("Belum ada pengeluaran.", style: TextStyle(color: Colors.grey)))
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categoryTotals.length,
          itemBuilder: (context, index) {
            String key = categoryTotals.keys.elementAt(index);
            double amount = categoryTotals[key]!;
            int count = categoryCount[key]!;
            double progress = totalExpense == 0 ? 0 : (amount / totalExpense);

            // Tampilan List memanjang ke bawah (seperti gambar) alih-alih Grid
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getCategoryColor(key).withOpacity(0.1),
                    child: Icon(_getCategoryIcon(key), color: _getCategoryColor(key), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('$count transactions', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: _getCategoryColor(key).withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation(_getCategoryColor(key)),
                            minHeight: 4,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}