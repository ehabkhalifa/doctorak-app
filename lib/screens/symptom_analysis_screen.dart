import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SymptomAnalysisScreen extends StatefulWidget {
  const SymptomAnalysisScreen({super.key});

  @override
  State<SymptomAnalysisScreen> createState() => _SymptomAnalysisScreenState();
}

class _SymptomAnalysisScreenState extends State<SymptomAnalysisScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedSymptoms = [];
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().searchSymptoms('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل الأعراض'),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            _buildInstructionsCard(),
            const SizedBox(height: 20),

            // Symptom search
            _buildSymptomSearch(),
            const SizedBox(height: 20),

            // Selected symptoms
            if (_selectedSymptoms.isNotEmpty) ...[
              _buildSelectedSymptoms(),
              const SizedBox(height: 20),
            ],

            // Analysis button
            if (_selectedSymptoms.isNotEmpty) ...[
              _buildAnalysisButton(),
              const SizedBox(height: 20),
            ],

            // Analysis results
            if (_analysisResult != null) ...[
              _buildAnalysisResults(),
              const SizedBox(height: 20),
            ],

            // Common symptoms
            _buildCommonSymptoms(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF26C6DA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'كيفية استخدام تحليل الأعراض',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '1. ابحث عن الأعراض التي تشعر بها\n'
            '2. اختر الأعراض المناسبة من القائمة\n'
            '3. اضغط على "تحليل الأعراض" للحصول على التوصيات\n'
            '4. راجع النتائج والتوصيات المقترحة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'هذا التحليل للإرشاد فقط وليس بديلاً عن استشارة طبية',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ابحث عن الأعراض',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'اكتب العرض الذي تشعر به...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<AppProvider>().searchSymptoms('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            context.read<AppProvider>().searchSymptoms(value);
          },
        ),
        const SizedBox(height: 16),

        // Search results
        Consumer<AppProvider>(
          builder: (context, provider, child) {
            final symptoms = provider.symptoms;

            if (symptoms.isEmpty && _searchController.text.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'لم يتم العثور على أعراض مطابقة',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            if (symptoms.isNotEmpty) {
              return Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    final isSelected = _selectedSymptoms.contains(symptom.name);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(symptom.name),
                        subtitle: Text(
                          symptom.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Color(0xFF00BCD4))
                            : const Icon(Icons.add_circle_outline),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedSymptoms.remove(symptom.name);
                            } else {
                              _selectedSymptoms.add(symptom.name);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildSelectedSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأعراض المختارة (${_selectedSymptoms.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedSymptoms.map((symptom) {
            return Chip(
              label: Text(symptom),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() {
                  _selectedSymptoms.remove(symptom);
                });
              },
              backgroundColor: const Color(0xFF00BCD4).withValues(alpha: 0.1),
              deleteIconColor: const Color(0xFF00BCD4),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalysisButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isAnalyzing ? null : _analyzeSymptoms,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isAnalyzing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('جاري التحليل...'),
                ],
              )
            : const Text(
                'تحليل الأعراض',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final result = _analysisResult!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نتائج التحليل',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Severity indicator
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getSeverityColor(result['severity']).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getSeverityColor(result['severity']).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSeverityIcon(result['severity']),
                    color: _getSeverityColor(result['severity']),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'مستوى الخطورة: ${result['severity']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getSeverityColor(result['severity']),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: _getSeverityColor(result['severity']),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Recommended vitamins
        if (result['vitamins'].isNotEmpty) ...[
          _buildRecommendationSection(
            'الفيتامينات المقترحة',
            result['vitamins'],
            Icons.medication,
            Colors.green,
          ),
          const SizedBox(height: 16),
        ],

        // Recommended supplements
        if (result['supplements'].isNotEmpty) ...[
          _buildRecommendationSection(
            'المكملات الغذائية المقترحة',
            result['supplements'],
            Icons.local_pharmacy,
            Colors.blue,
          ),
          const SizedBox(height: 16),
        ],

        // Doctor visit recommendation
        if (result['requiresDoctor']) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.red),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ننصح بزيارة الطبيب للحصول على تشخيص دقيق',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecommendationSection(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCommonSymptoms() {
    final commonSymptoms = [
      'صداع',
      'تعب وإرهاق',
      'ألم في المعدة',
      'سعال',
      'حمى',
      'دوخة',
      'ألم في الظهر',
      'أرق',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أعراض شائعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: commonSymptoms.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            return FilterChip(
              label: Text(symptom),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSymptoms.add(symptom);
                  } else {
                    _selectedSymptoms.remove(symptom);
                  }
                });
              },
              selectedColor: const Color(0xFF00BCD4).withValues(alpha: 0.2),
              checkmarkColor: const Color(0xFF00BCD4),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'خفيف':
        return Colors.green;
      case 'متوسط':
        return Colors.orange;
      case 'شديد':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'خفيف':
        return Icons.check_circle;
      case 'متوسط':
        return Icons.warning;
      case 'شديد':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  void _analyzeSymptoms() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock analysis result
    final result = _generateMockAnalysis();

    setState(() {
      _isAnalyzing = false;
      _analysisResult = result;
    });
  }

  Map<String, dynamic> _generateMockAnalysis() {
    // This is a mock analysis - in a real app, this would be more sophisticated
    final hasHeadache = _selectedSymptoms.contains('صداع');
    final hasFatigue = _selectedSymptoms.contains('تعب وإرهاق');
    final hasStomachPain = _selectedSymptoms.contains('ألم في المعدة');

    String severity = 'خفيف';
    String description = 'الأعراض تبدو خفيفة ويمكن التعامل معها بالراحة والعلاج المنزلي';
    List<String> vitamins = [];
    List<String> supplements = [];
    bool requiresDoctor = false;

    if (hasHeadache) {
      vitamins.addAll(['فيتامين B2', 'فيتامين D', 'المغنيسيوم']);
      supplements.addAll(['أوميغا 3', 'الكركم']);
    }

    if (hasFatigue) {
      vitamins.addAll(['فيتامين B12', 'فيتامين D', 'الحديد']);
      supplements.addAll(['الجينسنغ', 'الكوكيو 10']);
    }

    if (hasStomachPain) {
      vitamins.addAll(['فيتامين B6', 'الزنك']);
      supplements.addAll(['البروبيوتيك', 'الزنجبيل']);
      severity = 'متوسط';
      description = 'قد تحتاج لمراقبة الأعراض وتجنب الأطعمة المهيجة';
    }

    if (_selectedSymptoms.length > 3) {
      severity = 'متوسط';
      requiresDoctor = true;
      description = 'عدد الأعراض يستدعي استشارة طبية للتأكد من التشخيص';
    }

    return {
      'severity': severity,
      'description': description,
      'vitamins': vitamins.toSet().toList(),
      'supplements': supplements.toSet().toList(),
      'requiresDoctor': requiresDoctor,
    };
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مساعدة'),
        content: const SingleChildScrollView(
          child: Text(
            'تحليل الأعراض هو أداة مساعدة تقدم اقتراحات أولية بناءً على الأعراض المدخلة.\n\n'
            'المعلومات المقدمة هي للإرشاد فقط وليست بديلاً عن:\n'
            '• استشارة طبية مختصة\n'
            '• التشخيص الطبي الدقيق\n'
            '• العلاج الطبي المناسب\n\n'
            'في حالة الأعراض الشديدة أو المستمرة، يرجى مراجعة الطبيب فوراً.',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }
}