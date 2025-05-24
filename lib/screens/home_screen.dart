import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'drug_search_screen.dart';
import 'health_tips_screen.dart';
import 'symptom_analysis_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<AppProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.health_and_safety,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .scale(duration: 1000.ms, curve: Curves.easeInOut)
                          .then()
                          .scale(begin: const Offset(1.2, 1.2), duration: 1000.ms),
                      const SizedBox(height: 24),
                      Text(
                        'جاري تحميل البيانات...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  // Custom App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'دكتورك - DoctoraK',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'مرحباً بك في رحلتك الصحية',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome section
                          _buildWelcomeSection(provider),
                          const SizedBox(height: 24),

                          // Quick actions
                          _buildQuickActions(),
                          const SizedBox(height: 24),

                          // Health stats
                          _buildHealthStats(provider),
                          const SizedBox(height: 24),

                          // Today's health tip
                          _buildTodaysHealthTip(provider),
                          const SizedBox(height: 24),

                          // Recent activities
                          _buildRecentActivities(),
                          const SizedBox(height: 100), // Bottom padding for navigation
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(AppProvider provider) {
    final userName = provider.userProfile?.name ?? 'المستخدم';
    final currentHour = DateTime.now().hour;
    String greeting = 'مرحباً';

    if (currentHour < 12) {
      greeting = 'صباح الخير';
    } else if (currentHour < 17) {
      greeting = 'مساء الخير';
    } else {
      greeting = 'مساء الخير';
    }

    return GradientCard(
      colors: const [AppTheme.primaryColor, AppTheme.primaryLight],
      delay: const Duration(milliseconds: 200),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting، $userName',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'كيف تشعر اليوم؟ دعنا نساعدك في الحفاظ على صحتك',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'صحتك أولويتنا',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.health_and_safety,
              color: Colors.white,
              size: 40,
            ),
          )
              .animate(delay: 500.ms)
              .scale(duration: 800.ms, curve: Curves.elasticOut)
              .then(delay: 2000.ms)
              .shake(duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الإجراءات السريعة',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AnimatedCard(
                delay: const Duration(milliseconds: 300),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DrugSearchScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.infoColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: AppTheme.infoColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'البحث عن دواء',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedCard(
                delay: const Duration(milliseconds: 400),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SymptomAnalysisScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.health_and_safety_rounded,
                        color: AppTheme.successColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تحليل الأعراض',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AnimatedCard(
                delay: const Duration(milliseconds: 500),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthTipsScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tips_and_updates_rounded,
                        color: AppTheme.warningColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'نصائح صحية',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedCard(
                delay: const Duration(milliseconds: 600),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppTheme.secondaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'الملف الشخصي',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildHealthStats(AppProvider provider) {
    final profile = provider.userProfile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائياتك الصحية',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (profile != null) ...[
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'مؤشر كتلة الجسم',
                  value: profile.bmi.toStringAsFixed(1),
                  subtitle: profile.bmiCategory,
                  icon: Icons.monitor_weight_rounded,
                  color: _getBMIColor(profile.bmi),
                  delay: const Duration(milliseconds: 700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'العمر',
                  value: '${profile.age}',
                  subtitle: 'سنة',
                  icon: Icons.cake_rounded,
                  color: AppTheme.infoColor,
                  delay: const Duration(milliseconds: 800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'الوزن',
                  value: profile.weight.toStringAsFixed(1),
                  subtitle: 'كيلو',
                  icon: Icons.fitness_center_rounded,
                  color: AppTheme.successColor,
                  delay: const Duration(milliseconds: 900),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'الطول',
                  value: profile.height.toStringAsFixed(0),
                  subtitle: 'سم',
                  icon: Icons.height_rounded,
                  color: AppTheme.warningColor,
                  delay: const Duration(milliseconds: 1000),
                ),
              ),
            ],
          ),
        ] else ...[
          AnimatedCard(
            delay: const Duration(milliseconds: 700),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.person_add_rounded,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'أنشئ ملفك الشخصي',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'لرؤية إحصائياتك الصحية والحصول على نصائح مخصصة',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }


  Widget _buildTodaysHealthTip(AppProvider provider) {
    final tips = provider.healthTips;
    if (tips.isEmpty) {
      return const SizedBox.shrink();
    }

    final todaysTip = tips.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نصيحة اليوم',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GradientCard(
          colors: const [AppTheme.warningColor, Color(0xFFFFB74D)],
          delay: const Duration(milliseconds: 1100),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HealthTipsScreen(),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      todaysTip.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                todaysTip.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.category_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      todaysTip.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأنشطة الأخيرة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          icon: Icons.search,
          title: 'بحث عن دواء',
          subtitle: 'باراسيتامول',
          time: 'منذ ساعتين',
        ),
        _buildActivityItem(
          icon: Icons.tips_and_updates,
          title: 'قراءة نصيحة صحية',
          subtitle: 'أهمية شرب الماء',
          time: 'منذ 4 ساعات',
        ),
        _buildActivityItem(
          icon: Icons.health_and_safety,
          title: 'تحليل أعراض',
          subtitle: 'صداع',
          time: 'أمس',
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00BCD4),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}