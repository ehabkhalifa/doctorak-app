import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Required for Timer (debouncing)
import '../providers/app_provider.dart';
import '../models/drug.dart';
import '../theme/app_theme.dart';
import '../widgets/skeleton_widgets.dart';
import '../services/loading_service.dart';

class DrugSearchScreen extends StatefulWidget {
  const DrugSearchScreen({super.key});

  @override
  State<DrugSearchScreen> createState() => _DrugSearchScreenState();
}

class _DrugSearchScreenState extends State<DrugSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Constant for the default category
  static const String _kDefaultCategory = 'الكل';
  String _selectedCategory = _kDefaultCategory;

  Timer? _debounce;
  static const Duration _kDebounceDuration = Duration(milliseconds: 500);

  final List<String> _categories = [
    _kDefaultCategory,
    'مسكنات',
    'مضادات الالتهاب',
    'مضادات حيوية',
    'فيتامينات',
    'أدوية القلب',
    'أدوية الضغط',
    'أدوية السكري',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load initial data with empty search term and default category
      if (mounted) {
        context.read<AppProvider>().searchDrugs('', _selectedCategory);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن الأدوية'),
        backgroundColor: AppTheme.primaryColor, // Consider using theme color for consistency
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن دواء بالاسم أو المادة الفعالة...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear(); // This will trigger onChanged
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    // Update UI for suffix icon visibility
                    if (mounted) {
                      setState(() {});
                    }
                    // Debounce search
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(_kDebounceDuration, () {
                      if (mounted) { // Check mounted before accessing context in async callback
                        context.read<AppProvider>().searchDrugs(value, _selectedCategory);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Category filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category; // Update UI for FilterChip
                            });
                            _filterByCategory(category); // Trigger data reload with new category
                          },
                          selectedColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.grey.shade100,
                          checkmarkColor: Colors.white,
                          elevation: isSelected ? 3 : 0,
                          shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Results section
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.isDrugsLoading) {
                  return const ListSkeleton(
                    itemCount: 6,
                    itemSkeleton: DrugCardSkeleton(),
                  );
                }

                // provider.drugs is now assumed to be pre-filtered by search term and category
                final drugs = provider.drugs;

                if (drugs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لم يتم العثور على أدوية',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'جرب البحث بكلمات مختلفة',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SmartRefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: drugs.length,
                    itemBuilder: (context, index) {
                      final drug = drugs[index];
                      return _buildDrugCard(drug);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Refresh data method
  Future<void> _refreshData() async {
    // Reset database and reload data
    await context.read<AppProvider>().refreshData();
    if (mounted) {
      _debounce?.cancel(); // Cancel any pending search
      _searchController.clear(); // Clear search text field
      setState(() {
        _selectedCategory = _kDefaultCategory; // Reset category filter
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إعادة تحميل البيانات')),
      );
    }
  }

  // This method is now responsible for triggering the data fetch with the new category
  void _filterByCategory(String newCategory) {
    // AppProvider will handle the filtering.
    // The setState in onSelected for FilterChip handles the chip's visual state.
    context.read<AppProvider>().searchDrugs(_searchController.text, newCategory);
  }


  Widget _buildDrugCard(Drug drug) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDrugDetails(drug),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drug.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          drug.activeIngredient,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(drug.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      drug.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCategoryColor(drug.category),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                drug.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    drug.isPrescriptionRequired
                        ? Icons.local_pharmacy
                        : Icons.shopping_cart,
                    size: 16,
                    color: drug.isPrescriptionRequired
                        ? Colors.red
                        : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    drug.isPrescriptionRequired
                        ? 'يتطلب وصفة طبية'
                        : 'متاح بدون وصفة',
                    style: TextStyle(
                      fontSize: 12,
                      color: drug.isPrescriptionRequired
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'مسكنات':
        return Colors.blue;
      case 'مضادات الالتهاب':
        return Colors.green;
      case 'مضادات حيوية':
        return Colors.red;
      case 'فيتامينات':
        return Colors.orange;
      case 'أدوية القلب':
        return Colors.purple;
      case 'أدوية الضغط':
        return Colors.teal;
      case 'أدوية السكري':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _showDrugDetails(Drug drug) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    drug.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    drug.activeIngredient,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(drug.category).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                drug.category,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _getCategoryColor(drug.category),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description
                        _buildDetailSection('الوصف', drug.description),

                        // Usage
                        _buildDetailSection('الاستخدامات', drug.usage),

                        // Dosage
                        _buildDetailSection('الجرعة', drug.dosage),

                        // Best time
                        _buildDetailSection('أفضل وقت للتناول', drug.bestTime),

                        // Warnings
                        _buildDetailSection('تحذيرات', drug.warnings, isWarning: true),

                        // Interactions
                        _buildDetailSection('التفاعلات الدوائية', drug.interactions, isWarning: true),

                        const SizedBox(height: 20),

                        // Prescription requirement
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: drug.isPrescriptionRequired
                                ? Colors.red.withValues(alpha: 0.1)
                                : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: drug.isPrescriptionRequired
                                  ? Colors.red.withValues(alpha: 0.3)
                                  : Colors.green.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                drug.isPrescriptionRequired
                                    ? Icons.local_pharmacy
                                    : Icons.check_circle,
                                color: drug.isPrescriptionRequired
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  drug.isPrescriptionRequired
                                      ? 'هذا الدواء يتطلب وصفة طبية من طبيب مختص'
                                      : 'هذا الدواء متاح بدون وصفة طبية',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: drug.isPrescriptionRequired
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, {bool isWarning = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isWarning ? Colors.red : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isWarning
                ? Colors.red.withValues(alpha: 0.05)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: isWarning
                ? Border.all(color: Colors.red.withValues(alpha: 0.2))
                : null,
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isWarning ? Colors.red.shade700 : Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}