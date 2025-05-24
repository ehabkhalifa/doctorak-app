import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/health_tip.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'تغذية',
    'رياضة',
    'نوم',
    'صحة نفسية',
    'وقاية',
    'علاج طبيعي',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadHealthTips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النصائح الصحية'),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AppProvider>().loadHealthTips();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'التصنيفات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
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
                              _selectedCategory = category;
                            });
                            _loadTipsByCategory(category);
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

          // Tips list
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final tips = _getFilteredTips(provider.healthTips);

                if (tips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد نصائح متاحة',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'جرب تصنيف آخر',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index];
                    return _buildTipCard(tip);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTipDialog,
        backgroundColor: const Color(0xFF00BCD4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<HealthTip> _getFilteredTips(List<HealthTip> tips) {
    if (_selectedCategory == 'الكل') {
      return tips;
    }
    return tips.where((tip) => tip.category == _selectedCategory).toList();
  }

  void _loadTipsByCategory(String category) {
    if (category == 'الكل') {
      context.read<AppProvider>().loadHealthTips();
    } else {
      context.read<AppProvider>().loadHealthTipsByCategory(category);
    }
  }

  Widget _buildTipCard(HealthTip tip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showTipDetails(tip),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor(tip.category).withValues(alpha: 0.7),
                    _getCategoryColor(tip.category),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getCategoryIcon(tip.category),
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tip.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getCategoryColor(tip.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(tip.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const Spacer(),
                      if (!tip.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00BCD4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      const SizedBox(width: 8),
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
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'تغذية':
        return Colors.green;
      case 'رياضة':
        return Colors.blue;
      case 'نوم':
        return Colors.indigo;
      case 'صحة نفسية':
        return Colors.purple;
      case 'وقاية':
        return Colors.orange;
      case 'علاج طبيعي':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'تغذية':
        return Icons.restaurant;
      case 'رياضة':
        return Icons.fitness_center;
      case 'نوم':
        return Icons.bedtime;
      case 'صحة نفسية':
        return Icons.psychology;
      case 'وقاية':
        return Icons.shield;
      case 'علاج طبيعي':
        return Icons.spa;
      default:
        return Icons.tips_and_updates;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showTipDetails(HealthTip tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.6,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header image
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(tip.category).withValues(alpha: 0.7),
                                _getCategoryColor(tip.category),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  _getCategoryIcon(tip.category),
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    tip.category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _getCategoryColor(tip.category),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(tip.createdAt),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                tip.content,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Share functionality
                                        _shareTip(tip);
                                      },
                                      icon: const Icon(Icons.share),
                                      label: const Text('مشاركة'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade100,
                                        foregroundColor: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Bookmark functionality
                                        _bookmarkTip(tip);
                                      },
                                      icon: const Icon(Icons.bookmark),
                                      label: const Text('حفظ'),
                                    ),
                                  ),
                                ],
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

  void _showAddTipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'تغذية';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة نصيحة جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'التصنيف',
                  border: OutlineInputBorder(),
                ),
                items: _categories.skip(1).map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'المحتوى',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                // Add tip logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إضافة النصيحة بنجاح')),
                );
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _shareTip(HealthTip tip) {
    // Share functionality implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ النصيحة للمشاركة')),
    );
  }

  void _bookmarkTip(HealthTip tip) {
    // Bookmark functionality implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ النصيحة')),
    );
  }
}