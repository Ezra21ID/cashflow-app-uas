
import 'package:coba/services/database_service.dart';
import 'package:coba/services/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  // --- CONTROLLER ---
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  // --- STATE TIPE TRANSAKSI (BARU) ---
  // Default 'expense', bisa berubah jadi 'income'
  String _selectedType = 'expense';

  // --- KATEGORI ---
  String? _selectedCategory;

  // List Kategori Pengeluaran
  final List<String> _expenseCategories = [
    'Groceries', 'Entertainment', 'Transportation',
    'Shopping', 'Food & Drinks', 'Fitness', 'Insurance', 'Other'
  ];

  // List Kategori Pemasukan (BARU)
  final List<String> _incomeCategories = [
    'Salary', 'Bonus', 'Allowance', 'Petty Cash', 'Gift', 'Investment', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Set kategori awal default
    _selectedCategory = _expenseCategories.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- FUNGSI GANTI TIPE (Income/Expense) ---
  void _changeType(String type) {
    setState(() {
      _selectedType = type;
      // Reset kategori ke item pertama dari list yang baru agar tidak error
      if (type == 'expense') {
        _selectedCategory = _expenseCategories.first;
      } else {
        _selectedCategory = _incomeCategories.first;
      }
    });
  }

  // --- LOGIKA SIMPAN KE FIREBASE ---
  void _saveTransaction() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter amount")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Bersihkan format Rp dan titik/koma
      double amount = double.parse(_amountController.text.replaceAll(RegExp(r'[^0-9.]'), ''));

      final newTx = TransactionModel(
        id: '',
        title: _descController.text.isEmpty ? _selectedCategory! : _descController.text,
        category: _selectedCategory!,
        amount: amount,
        date: DateTime.now(),
        // --- PENTING: Kirim tipe yang dipilih ('income' atau 'expense') ---
        type: _selectedType,
      );

      await DatabaseService().addTransaction(newTx);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${_selectedType == 'income' ? 'Income' : 'Expense'} Saved!"),
          backgroundColor: _selectedType == 'income' ? Colors.green : Colors.red,
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- HELPER DEKORASI INPUT ---
  InputDecoration _buildInputDecoration({String? hintText, Widget? suffixIcon, String? prefixText}) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _selectedType == 'income' ? Colors.green : const Color(0xFF316D69), width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFFCFCFC);

    // Tentukan list kategori mana yang dipakai saat ini
    final currentCategories = _selectedType == 'expense' ? _expenseCategories : _incomeCategories;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _selectedType == 'expense' ? 'Add Expense' : 'Add Income',
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- WIDGET SWITCH INCOME/EXPENSE ---
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Tombol Expense
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _changeType('expense'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedType == 'expense' ? Colors.red.shade400 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Expense",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedType == 'expense' ? Colors.white : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Tombol Income
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _changeType('income'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedType == 'income' ? Colors.green.shade400 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Income",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedType == 'income' ? Colors.white : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- INPUT KATEGORI ---
                    _buildSectionTitle('Categories'),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      // Dropdown item akan berubah sesuai list yang dipilih
                      items: currentCategories.map((String category) {
                        return DropdownMenuItem<String>(value: category, child: Text(category));
                      }).toList(),
                      onChanged: (newValue) => setState(() => _selectedCategory = newValue),
                      decoration: _buildInputDecoration(),
                    ),
                    const SizedBox(height: 16),

                    // --- INPUT AMOUNT ---
                    _buildSectionTitle('Amount'),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        hintText: '0',
                        prefixText: 'Rp ',
                        // Ubah warna text input jadi hijau kalau income
                      ),
                      style: TextStyle(
                        color: _selectedType == 'income' ? Colors.green.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- INPUT DESKRIPSI ---
                    _buildSectionTitle('Description'),
                    TextFormField(
                      controller: _descController,
                      maxLines: 2,
                      decoration: _buildInputDecoration(hintText: 'Enter a description...'),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveTransaction,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            // Ubah warna tombol simpan sesuai tipe
            backgroundColor: _selectedType == 'income' ? Colors.green.shade600 : const Color(0xFF316D69),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
              'Save ${_selectedType == 'income' ? 'Income' : 'Expense'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 4.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }
}