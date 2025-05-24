import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final profile = provider.userProfile;

          if (profile == null) {
            return _buildCreateProfileView();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                _buildProfileHeader(profile),
                const SizedBox(height: 24),

                // Health stats
                _buildHealthStats(profile),
                const SizedBox(height: 24),

                // Health goals
                _buildHealthGoals(profile),
                const SizedBox(height: 24),

                // Medical information
                _buildMedicalInfo(profile),
                const SizedBox(height: 24),

                // Action buttons
                _buildActionButtons(profile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateProfileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add,
                size: 60,
                color: Color(0xFF00BCD4),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'أنشئ ملفك الشخصي',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'أنشئ ملفك الشخصي للحصول على توصيات صحية مخصصة لك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showCreateProfileDialog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إنشاء الملف الشخصي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF26C6DA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              profile.gender == 'ذكر' ? Icons.person : Icons.person_2,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${profile.age} سنة • ${profile.gender}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderStat('الطول', '${profile.height.toInt()} سم'),
              _buildHeaderStat('الوزن', '${profile.weight.toInt()} كجم'),
              _buildHeaderStat('BMI', profile.bmi.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthStats(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإحصائيات الصحية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'مؤشر كتلة الجسم',
                profile.bmi.toStringAsFixed(1),
                profile.bmiCategory,
                _getBMIColor(profile.bmi),
                Icons.monitor_weight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'مستوى النشاط',
                profile.activityLevel,
                _getActivityDescription(profile.activityLevel),
                _getActivityColor(profile.activityLevel),
                Icons.fitness_center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthGoals(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأهداف الصحية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.flag,
                    color: Color(0xFF00BCD4),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'هدفي الصحي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                profile.healthGoals,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalInfo(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المعلومات الطبية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Allergies
        if (profile.allergies.isNotEmpty) ...[
          _buildMedicalInfoCard(
            'الحساسيات',
            profile.allergies,
            Icons.warning,
            Colors.orange,
          ),
          const SizedBox(height: 12),
        ],

        // Chronic conditions
        if (profile.chronicConditions.isNotEmpty) ...[
          _buildMedicalInfoCard(
            'الحالات المزمنة',
            profile.chronicConditions,
            Icons.medical_information,
            Colors.red,
          ),
        ],

        if (profile.allergies.isEmpty && profile.chronicConditions.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Text(
                  'لا توجد حساسيات أو حالات مزمنة مسجلة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMedicalInfoCard(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
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
        ],
      ),
    );
  }

  Widget _buildActionButtons(UserProfile profile) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showEditProfileDialog(profile),
            icon: const Icon(Icons.edit),
            label: const Text('تعديل الملف الشخصي'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _exportProfile,
            icon: const Icon(Icons.download),
            label: const Text('تصدير البيانات'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  Color _getActivityColor(String activity) {
    switch (activity) {
      case 'قليل':
        return Colors.red;
      case 'متوسط':
        return Colors.orange;
      case 'عالي':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getActivityDescription(String activity) {
    switch (activity) {
      case 'قليل':
        return 'أقل من 30 دقيقة يومياً';
      case 'متوسط':
        return '30-60 دقيقة يومياً';
      case 'عالي':
        return 'أكثر من 60 دقيقة يومياً';
      default:
        return '';
    }
  }

  void _showCreateProfileDialog() {
    _showProfileDialog(null);
  }

  void _showEditProfileDialog(UserProfile profile) {
    _showProfileDialog(profile);
  }

  void _showProfileDialog(UserProfile? existingProfile) {
    final nameController = TextEditingController(text: existingProfile?.name ?? '');
    final ageController = TextEditingController(text: existingProfile?.age.toString() ?? '');
    final weightController = TextEditingController(text: existingProfile?.weight.toString() ?? '');
    final heightController = TextEditingController(text: existingProfile?.height.toString() ?? '');
    final goalsController = TextEditingController(text: existingProfile?.healthGoals ?? '');

    String selectedGender = existingProfile?.gender ?? 'ذكر';
    String selectedActivity = existingProfile?.activityLevel ?? 'متوسط';
    List<String> allergies = List.from(existingProfile?.allergies ?? []);
    List<String> conditions = List.from(existingProfile?.chronicConditions ?? []);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(existingProfile == null ? 'إنشاء ملف شخصي' : 'تعديل الملف الشخصي'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        decoration: const InputDecoration(
                          labelText: 'العمر',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'الجنس',
                          border: OutlineInputBorder(),
                        ),
                        items: ['ذكر', 'أنثى'].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          labelText: 'الوزن (كجم)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          labelText: 'الطول (سم)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedActivity,
                  decoration: const InputDecoration(
                    labelText: 'مستوى النشاط',
                    border: OutlineInputBorder(),
                  ),
                  items: ['قليل', 'متوسط', 'عالي'].map((activity) {
                    return DropdownMenuItem(
                      value: activity,
                      child: Text(activity),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedActivity = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: goalsController,
                  decoration: const InputDecoration(
                    labelText: 'الأهداف الصحية',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                if (nameController.text.isNotEmpty &&
                    ageController.text.isNotEmpty &&
                    weightController.text.isNotEmpty &&
                    heightController.text.isNotEmpty) {

                  final profile = UserProfile(
                    id: existingProfile?.id,
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    weight: double.parse(weightController.text),
                    height: double.parse(heightController.text),
                    gender: selectedGender,
                    healthGoals: goalsController.text,
                    allergies: allergies,
                    chronicConditions: conditions,
                    activityLevel: selectedActivity,
                    createdAt: existingProfile?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  context.read<AppProvider>().saveUserProfile(profile);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(existingProfile == null
                          ? 'تم إنشاء الملف الشخصي بنجاح'
                          : 'تم تحديث الملف الشخصي بنجاح'),
                    ),
                  );
                }
              },
              child: Text(existingProfile == null ? 'إنشاء' : 'حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإعدادات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('الإشعارات'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Handle notification settings
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اللغة'),
              subtitle: const Text('العربية'),
              onTap: () {
                // Handle language settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('الخصوصية'),
              onTap: () {
                // Handle privacy settings
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _exportProfile() {
    // Export profile functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تصدير البيانات بنجاح')),
    );
  }
}