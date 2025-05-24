import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/drug_search_screen.dart';
import 'screens/health_tips_screen.dart';
import 'screens/symptom_analysis_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/app_provider.dart';
import 'services/database_service.dart';
import 'services/cache_service.dart';
import 'services/error_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize services
  await _initializeServices();

  runApp(const DoctoraKApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize database
    await DatabaseService().database;

    // Initialize cache service
    await CacheService().init();

    debugPrint('✅ All services initialized successfully');
  } catch (e) {
    final error = ErrorService().handleException(e, context: 'Service Initialization');
    debugPrint('❌ Failed to initialize services: ${error.message}');
  }
}

class DoctoraKApp extends StatelessWidget {
  const DoctoraKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'دكتورك - DoctoraK',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            case '/drugs':
              return MaterialPageRoute(
                builder: (context) => const DrugSearchScreen(),
              );
            case '/tips':
              return MaterialPageRoute(
                builder: (context) => const HealthTipsScreen(),
              );
            case '/symptoms':
              return MaterialPageRoute(
                builder: (context) => const SymptomAnalysisScreen(),
              );
            case '/profile':
              return MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              );
            default:
              return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
          }
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DrugSearchScreen(),
    const HealthTipsScreen(),
    const SymptomAnalysisScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.tips_and_updates_rounded,
    Icons.health_and_safety_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = [
    'الرئيسية',
    'البحث',
    'النصائح',
    'الأعراض',
    'الملف الشخصي',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_screens.length, (index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _icons[index],
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey.shade600,
                          size: 24,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          AnimatedOpacity(
                            opacity: isSelected ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _labels[index],
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
