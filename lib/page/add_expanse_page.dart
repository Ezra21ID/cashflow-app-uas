import 'package:flutter/material.dart';
// --- DIHAPUS: Import dashboard tidak diperlukan lagi ---
// import 'package:coba/page/dashboard.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String? _selectedCategory = 'Groceries';
  final List<String> _categories = [
    'Groceries',
    'Entertainment',
    'Transportation',
    'Shopping',
    'Food & Drinks',
    'Fitness',
    'Insurance',
  ];

  // ... (Data categoryGridItems tetap sama) ...
  final List<Map<String, dynamic>> categoryGridItems = [
    {
      'icon': 'assets/icon/keranjang.svg',
      'label': 'Groceries',
      'color': const Color(0xFFDEEEFF),
      'iconColor': Colors.blue.shade700,
    },
    {
      'icon': 'assets/icon/entertainment.svg',
      'label': 'Entertainment',
      'color': const Color(0xFFF3DBC5),
      'size': 30.0,
    },
    {
      'icon': 'assets/icon/Transportation.svg',
      'label': 'Transportation',
      'color': const Color(0xFFDDD0F3),
      'size': 20.0,
    },
    {
      'icon': 'assets/icon/Shopping.svg',
      'label': 'Shopping',
      'color': const Color(0xFFFFC6E2),
    },
    {
      'icon': 'assets/icon/food.svg',
      'label': 'Food & Drinks',
      'color': const Color(0xFFFCE5BB),
      'size': 30.0,
    },
    {
      'icon': 'assets/icon/Fitnes.svg',
      'label': 'Fitness',
      'color': const Color(0xFF87DCD7),
      'size': 30.0,
    },
    {
      'icon': 'assets/icon/Insurance.svg',
      'label': 'Insurance',
      'color': const Color(0xFF98EAFF),
    },
    {
      'icon': Icons.more_horiz,
      'label': 'Other',
      'color': const Color(0xFF538582),
      'size': 30.0,
      // Tidak ada iconColor, akan pakai warna default (putih)
    },
  ];

  InputDecoration _buildInputDecoration({
    String? hintText,
    Widget? suffixIcon,
    String? prefixText,
  }) {
    // ... (Fungsi _buildInputDecoration tetap sama) ...
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: const Color(0xFF316D69), width: 1.5),
      ),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixStyle: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFFCFCFC);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // --- PERBAIKAN: Tombol kembali ---
          onPressed: () {
            // Cukup panggil pop(context) untuk kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
          // --- Akhir Perbaikan ---
        ),
        title: const Text(
          'Add Expenses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Categories'),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      decoration: _buildInputDecoration(),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Amount'),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        hintText: '\Rp 0.00',
                        prefixText: 'Rp ',
                      ),
                    ),
                    // ... (Sisa form tetap sama) ...
                    const SizedBox(height: 16),
                    _buildSectionTitle('Description'),
                    TextFormField(
                      maxLines: 2,
                      decoration: _buildInputDecoration(
                        hintText: 'Enter a description...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Date'),
                    TextFormField(
                      readOnly: true,
                      decoration: _buildInputDecoration(
                        hintText: 'DD/MM/YYYY',
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Attach Receipt'),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.crop_free, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: categoryGridItems.length,
                            itemBuilder: (context, index) {
                              final item = categoryGridItems[index];
                              return _buildCategoryGridItem(
                                item['icon'],
                                item['label'],
                                item['color'],
                                iconSize:
                                (item['size'] as num?)?.toDouble() ?? 28.0,
                                iconColor:
                                item['iconColor'],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ... (BottomNavigationBar tetap sama) ...
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF316D69),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ... (Widget helper _buildSectionTitle dan _buildCategoryGridItem tetap sama) ...
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCategoryGridItem(
      dynamic icon,
      String label,
      Color color, {
        double iconSize = 28.0,
        Color? iconColor,
      }) {
    Widget iconWidget;
    if (icon is String) {
      final iconPath = icon.endsWith('.svg') ? icon : '$icon.svg';

      iconWidget = SvgPicture.asset(
        iconPath,
        width: iconSize,
        height: iconSize,
      );
    } else if (icon is IconData) {
      iconWidget = Icon(
        icon,
        color: iconColor ?? Colors.white,
        size: iconSize,
      );
    } else {
      iconWidget = const SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(radius: 28, backgroundColor: color, child: iconWidget),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}