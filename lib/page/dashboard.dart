
import 'package:coba/page/chart_page.dart';
import 'package:coba/page/add_expanse_page.dart';
import 'package:coba/services/database_service.dart';
import 'package:coba/services/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class FinanceHomePage extends StatefulWidget {
  const FinanceHomePage({super.key});

  @override
  State<FinanceHomePage> createState() => _FinanceHomePageState();
}

class _FinanceHomePageState extends State<FinanceHomePage> {
  // --- STATE UNTUK FILTER & SEARCH (SYARAT UAS) ---
  String _searchQuery = '';
  String _filterType = 'All'; // Pilihan: 'All', 'income', 'expense'

  final TextEditingController _searchController = TextEditingController();

  // Helper untuk icon & warna kategori
  Map<String, dynamic> _getCategoryStyle(String category, String type) {
    if (type == 'income') {
      return {
        'icon': 'assets/icon/Shopping.svg', // Pastikan icon ini ada atau ganti icon lain
        'color': Colors.green.shade50,
        'iconColor': Colors.green
      };
    }

    switch (category) {
      case 'Groceries': return {'icon': 'assets/icon/keranjang.svg', 'color': const Color(0xFFE3F2FD), 'iconColor': const Color(0xFF2196F3)};
      case 'Entertainment': return {'icon': 'assets/icon/entertainment.svg', 'color': const Color(0xFFFFF3E0), 'iconColor': const Color(0xFFFF9800)};
      case 'Transportation': return {'icon': 'assets/icon/Transportation.svg', 'color': const Color(0xFFE8EAF6), 'iconColor': const Color(0xFF3F51B5)};
      case 'Shopping': return {'icon': 'assets/icon/Shopping.svg', 'color': const Color(0xFFFCE4EC), 'iconColor': const Color(0xFFE91E63)};
      case 'Food & Drinks': return {'icon': 'assets/icon/food.svg', 'color': const Color(0xFFE0F2F1), 'iconColor': const Color(0xFF009688)};
      case 'Fitness': return {'icon': 'assets/icon/Fitnes.svg', 'color': const Color(0xFFE0F2F1), 'iconColor': Colors.cyan};
      case 'Insurance': return {'icon': 'assets/icon/Insurance.svg', 'color': const Color(0xFFE0F2F1), 'iconColor': Colors.purple};
      default: return {'icon': 'assets/icon/Shopping.svg', 'color': const Color(0xFFF3F3F3), 'iconColor': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return StreamBuilder<List<TransactionModel>>(
      stream: DatabaseService().transactions,
      builder: (context, snapshot) {
        // Data Awal
        List<TransactionModel> allTransactions = [];
        List<TransactionModel> filteredTransactions = [];
        double totalBalance = 0;
        double totalExpense = 0;
        double totalIncome = 0;

        if (snapshot.hasData) {
          allTransactions = snapshot.data!;

          // 1. Hitung Saldo Global (Tidak terpengaruh filter)
          totalIncome = allTransactions
              .where((t) => t.type == 'income')
              .fold(0, (sum, item) => sum + item.amount);

          totalExpense = allTransactions
              .where((t) => t.type == 'expense')
              .fold(0, (sum, item) => sum + item.amount);

          totalBalance = totalIncome - totalExpense;

          // 2. Terapkan Filter & Search pada List yang akan ditampilkan
          filteredTransactions = allTransactions.where((tx) {
            // Filter by Type (All/Income/Expense)
            bool typeMatches = _filterType == 'All' || tx.type == _filterType;

            // Filter by Search (Title)
            bool searchMatches = tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                tx.category.toLowerCase().contains(_searchQuery.toLowerCase());

            return typeMatches && searchMatches;
          }).toList();
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, totalBalance, totalIncome, totalExpense),

                const SizedBox(height: 20),

                // --- BAGIAN SEARCH & FILTER ---
                _buildSearchAndFilter(),

                const SizedBox(height: 10),

                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  )
                else if (allTransactions.isEmpty)
                // Jika data kosong dari database
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Belum ada transaksi.\nTekan tombol (+) untuk menambah.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                else if (filteredTransactions.isEmpty)
                  // Jika data ada tapi tidak ketemu di search
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text("Transaksi tidak ditemukan.", style: TextStyle(color: Colors.grey)),
                    )
                  else
                    _buildTransactionList(filteredTransactions),

                const SizedBox(height: 80), // Spasi bawah agar tidak tertutup FAB
              ],
            ),
          ),

          // --- FAB & NAV BAR ---
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
                      icon: const Icon(Icons.home, color: Color(0xFF2C7873)),
                      onPressed: () {} // Sudah di Home
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.bar_chart, color: Colors.grey),
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChartPage())),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET BAGIAN ATAS (SALDO) ---
  Widget _buildHeader(BuildContext context, double balance, double income, double expense) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SizedBox(
      height: 300, // Sedikit dipertinggi agar layout aman
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 230, width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2C7873),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 25, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back!', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('User', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 130, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF348D87),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(currencyFormatter.format(balance),
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIncomeExpense('Income', currencyFormatter.format(income), Icons.arrow_downward),
                      Container(height: 40, width: 1, color: Colors.white24), // Divider kecil
                      _buildIncomeExpense('Expenses', currencyFormatter.format(expense), Icons.arrow_upward),
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
            Text(amount, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  // --- WIDGET SEARCH & FILTER ---
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // 1. Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Cari transaksi...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 2. Filter Buttons (Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildFilterChip('All', 'All'),
                const SizedBox(width: 10),
                _buildFilterChip('Income', 'income'),
                const SizedBox(width: 10),
                _buildFilterChip('Expense', 'expense'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    bool isSelected = _filterType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C7873) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF2C7873).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- WIDGET LIST TRANSAKSI ---
  Widget _buildTransactionList(List<TransactionModel> transactions) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM, HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          ...transactions.map((tx) {
            final style = _getCategoryStyle(tx.category, tx.type);
            final isIncome = tx.type == 'income';

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: style['color'], shape: BoxShape.circle),
                    child: style['icon'].toString().endsWith('.svg')
                        ? SvgPicture.asset(style['icon'], width: 24, height: 24, colorFilter: ColorFilter.mode(style['iconColor'], BlendMode.srcIn))
                        : Icon(Icons.attach_money, color: style['iconColor']),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${tx.category} • ${dateFormat.format(tx.date)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  Text(
                    '${isIncome ? '+ ' : '- '}${currencyFormatter.format(tx.amount)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }), // .toList() tidak diperlukan jika menggunakan ...spread operator
        ],
      ),
    );
  }
}