import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/calculation_history_card_widget.dart';
import './widgets/empty_history_widget.dart';

class CalculationHistoryScreen extends StatefulWidget {
  const CalculationHistoryScreen({super.key});

  @override
  State<CalculationHistoryScreen> createState() =>
      _CalculationHistoryScreenState();
}

class _CalculationHistoryScreenState extends State<CalculationHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _filteredHistory = [];
  bool _isSearching = false;

  // Mock calculation history data
  final List<Map<String, dynamic>> _calculationHistory = [
    {
      "id": 1,
      "expression": "125 + 75 × 2",
      "result": "275",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "type": "basic"
    },
    {
      "id": 2,
      "expression": "sin(45°) + cos(30°)",
      "result": "1.5732",
      "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
      "type": "scientific"
    },
    {
      "id": 3,
      "expression": "√(144) × π",
      "result": "37.6991",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "type": "scientific"
    },
    {
      "id": 4,
      "expression": "1250 ÷ 25",
      "result": "50",
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "type": "basic"
    },
    {
      "id": 5,
      "expression": "log₁₀(1000)",
      "result": "3",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "type": "scientific"
    },
    {
      "id": 6,
      "expression": "15% of 200",
      "result": "30",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "type": "basic"
    },
    {
      "id": 7,
      "expression": "e^2.5",
      "result": "12.1825",
      "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      "type": "scientific"
    },
    {
      "id": 8,
      "expression": "9! ÷ 6!",
      "result": "504",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "type": "scientific"
    },
    {
      "id": 9,
      "expression": "456.78 - 123.45",
      "result": "333.33",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "type": "basic"
    },
    {
      "id": 10,
      "expression": "tan(60°) × 100",
      "result": "173.2051",
      "timestamp": DateTime.now().subtract(const Duration(days: 4)),
      "type": "scientific"
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredHistory = List.from(_calculationHistory);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredHistory = List.from(_calculationHistory);
      } else {
        _filteredHistory = _calculationHistory.where((calculation) {
          final expression =
              (calculation["expression"] as String).toLowerCase();
          final result = (calculation["result"] as String).toLowerCase();
          return expression.contains(query) || result.contains(query);
        }).toList();
      }
    });
  }

  void _copyToClipboard(String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 10.h,
          left: 4.w,
          right: 4.w,
        ),
      ),
    );
  }

  void _deleteCalculation(int id) {
    setState(() {
      _calculationHistory.removeWhere((calc) => (calc["id"] as int) == id);
      _filteredHistory.removeWhere((calc) => (calc["id"] as int) == id);
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Calculation deleted'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 10.h,
          left: 4.w,
          right: 4.w,
        ),
      ),
    );
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear All History',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete all calculation history? This action cannot be undone.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calculationHistory.clear();
                  _filteredHistory.clear();
                });
                Navigator.of(context).pop();
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All history cleared'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: 10.h,
                      left: 4.w,
                      right: 4.w,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      // Simulate refresh by reordering or updating timestamps
      _filteredHistory = List.from(_calculationHistory);
    });
  }

  String _getDateSectionHeader(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(const Duration(days: 7));
    final calcDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (calcDate == today) {
      return 'Today';
    } else if (calcDate == yesterday) {
      return 'Yesterday';
    } else if (timestamp.isAfter(thisWeek)) {
      return 'This Week';
    } else {
      return 'Older';
    }
  }

  List<Widget> _buildGroupedHistory() {
    if (_filteredHistory.isEmpty) {
      return [EmptyHistoryWidget()];
    }

    final Map<String, List<Map<String, dynamic>>> groupedHistory = {};

    for (final calculation in _filteredHistory) {
      final timestamp = calculation["timestamp"] as DateTime;
      final section = _getDateSectionHeader(timestamp);

      if (!groupedHistory.containsKey(section)) {
        groupedHistory[section] = [];
      }
      groupedHistory[section]!.add(calculation);
    }

    final List<Widget> widgets = [];
    final sectionOrder = ['Today', 'Yesterday', 'This Week', 'Older'];

    for (final section in sectionOrder) {
      if (groupedHistory.containsKey(section)) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Text(
              section,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );

        for (final calculation in groupedHistory[section]!) {
          widgets.add(
            CalculationHistoryCardWidget(
              calculation: calculation,
              onCopyResult: (result) => _copyToClipboard(result, 'Result'),
              onCopyExpression: (expression) =>
                  _copyToClipboard(expression, 'Expression'),
              onDelete: (id) => _deleteCalculation(id),
              searchQuery: _isSearching ? _searchController.text : null,
            ),
          );
        }
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Calculation History',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_calculationHistory.isNotEmpty)
            TextButton(
              onPressed: _clearAllHistory,
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search calculations...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _isSearching
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // History List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshHistory,
                color: Theme.of(context).colorScheme.primary,
                child: _filteredHistory.isEmpty && !_isSearching
                    ? EmptyHistoryWidget()
                    : _filteredHistory.isEmpty && _isSearching
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'search_off',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 48,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'No calculations found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Try a different search term',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 2.h),
                            children: _buildGroupedHistory(),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
