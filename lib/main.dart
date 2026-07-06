import 'package:flutter/material.dart';

void main() => runApp(const CampusCafeApp());

class CampusCafeApp extends StatelessWidget {
  const CampusCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusCafé',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          primary: const Color(0xFFFF6B35),
          surface: const Color(0xFFF7F9FB),
        ),
        useMaterial3: true,
      ),
      home: const CustomOrderPage(),
    );
  }
}

class MenuItem {
  final String name;
  final double price;
  const MenuItem(this.name, this.price);
}

const menu = [
  MenuItem('Jollof Rice & Chicken', 35.00),
  MenuItem('Waakye Special', 30.00),
  MenuItem('Banku & Tilapia', 45.00),
  MenuItem('Meat Pie', 12.00),
  MenuItem('Sobolo (500 ml)', 8.00),
];

class CustomOrderPage extends StatefulWidget {
  const CustomOrderPage({super.key});

  @override
  State<CustomOrderPage> createState() => _CustomOrderPageState();
}

class _CustomOrderPageState extends State<CustomOrderPage> {
  final Map<int, int> _qty = {};

  double get _totalPrice {
    var sum = 0.0;
    _qty.forEach((i, q) => sum += menu[i].price * q);
    return sum;
  }

  int get _totalItemsCount {
    var count = 0;
    _qty.forEach((_, q) => count += q);
    return count;
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      final next = (_qty[index] ?? 0) + delta;
      if (next <= 0) {
        _qty.remove(index);
      } else {
        _qty[index] = next;
      }
    });
  }

  Future<void> _clearOrderWithConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Order?'),
        content: const Text(
          'Are you sure you want to remove all items from this basket?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _qty.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'FreshBite Counter',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Badge(
              label: Text('$_totalItemsCount'),
              isLabelVisible: _totalItemsCount > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, size: 26),
                onPressed: () {},
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.red),
            tooltip: 'Clear All',
            onPressed: _qty.isEmpty ? null : _clearOrderWithConfirmation,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Menu Items',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menu.length,
              itemBuilder: (context, i) {
                final item = menu[i];
                final q = _qty[i] ?? 0;
                final hasQty = q > 0;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.fastfood_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'GHS ${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: q == 0
                                    ? null
                                    : () => _changeQuantity(i, -1),
                              ),
                              Text(
                                '$q',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: hasQty ? Colors.black : Colors.grey,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                color: theme.colorScheme.primary,
                                onPressed: () => _changeQuantity(i, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL PAYABLE',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'GHS ${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _totalPrice > 0 ? () {} : null,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text(
                    'Checkout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
