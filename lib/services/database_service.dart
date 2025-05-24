import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/drug.dart';
import '../models/user_profile.dart';
import '../models/health_tip.dart';
import 'performance_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  final PerformanceService _performanceService = PerformanceService();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'healthy_app.db');
    return await openDatabase(
      path,
      version: 2, // Increased version to trigger recreation
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Drop all tables and recreate
    await db.execute('DROP TABLE IF EXISTS drugs');
    await db.execute('DROP TABLE IF EXISTS user_profiles');
    await db.execute('DROP TABLE IF EXISTS health_tips');
    await db.execute('DROP TABLE IF EXISTS symptoms');
    await _onCreate(db, newVersion);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create drugs table
    await db.execute('''
      CREATE TABLE drugs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        activeIngredient TEXT NOT NULL,
        description TEXT NOT NULL,
        usage TEXT NOT NULL,
        dosage TEXT NOT NULL,
        bestTime TEXT NOT NULL,
        warnings TEXT NOT NULL,
        interactions TEXT NOT NULL,
        category TEXT NOT NULL,
        isPrescriptionRequired INTEGER NOT NULL
      )
    ''');

    // Create user_profiles table
    await db.execute('''
      CREATE TABLE user_profiles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        weight REAL NOT NULL,
        height REAL NOT NULL,
        gender TEXT NOT NULL,
        healthGoals TEXT NOT NULL,
        allergies TEXT NOT NULL,
        chronicConditions TEXT NOT NULL,
        activityLevel TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Create health_tips table
    await db.execute('''
      CREATE TABLE health_tips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        isRead INTEGER NOT NULL
      )
    ''');

    // Create symptoms table
    await db.execute('''
      CREATE TABLE symptoms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        severity TEXT NOT NULL,
        relatedVitamins TEXT NOT NULL,
        relatedSupplements TEXT NOT NULL,
        requiresDoctorVisit INTEGER NOT NULL
      )
    ''');

    // Create indexes for better performance
    await _createIndexes(db);

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _createIndexes(Database db) async {
    // Indexes for drugs table
    await db.execute('CREATE INDEX IF NOT EXISTS idx_drugs_name ON drugs(name)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_drugs_category ON drugs(category)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_drugs_active_ingredient ON drugs(activeIngredient)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_drugs_search ON drugs(name, activeIngredient, category)');

    // Indexes for health_tips table
    await db.execute('CREATE INDEX IF NOT EXISTS idx_health_tips_category ON health_tips(category)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_health_tips_created_at ON health_tips(createdAt)');

    // Indexes for symptoms table
    await db.execute('CREATE INDEX IF NOT EXISTS idx_symptoms_name ON symptoms(name)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_symptoms_severity ON symptoms(severity)');

    // Indexes for user_profiles table
    await db.execute('CREATE INDEX IF NOT EXISTS idx_user_profiles_created_at ON user_profiles(createdAt)');
  }

  Future<void> _insertSampleData(Database db) async {
    // Sample drugs - More comprehensive data
    final sampleDrugs = [
      {
        'name': 'باراسيتامول',
        'activeIngredient': 'Paracetamol',
        'description': 'مسكن للألم وخافض للحرارة',
        'usage': 'يستخدم لتسكين الألم الخفيف إلى المتوسط وخفض الحرارة',
        'dosage': '500-1000 مجم كل 4-6 ساعات، بحد أقصى 4 جرام يومياً',
        'bestTime': 'يمكن تناوله مع أو بدون طعام',
        'warnings': 'تجنب الجرعات الزائدة، قد يسبب تلف الكبد',
        'interactions': 'يتفاعل مع الكحول والوارفارين',
        'category': 'مسكنات',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'إيبوبروفين',
        'activeIngredient': 'Ibuprofen',
        'description': 'مضاد للالتهاب ومسكن للألم',
        'usage': 'يستخدم لتسكين الألم والالتهاب وخفض الحرارة',
        'dosage': '200-400 مجم كل 4-6 ساعات، بحد أقصى 1200 مجم يومياً',
        'bestTime': 'يفضل تناوله مع الطعام',
        'warnings': 'قد يسبب مشاكل في المعدة والكلى',
        'interactions': 'يتفاعل مع أدوية ضغط الدم والوارفارين',
        'category': 'مضادات الالتهاب',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'أسبرين',
        'activeIngredient': 'Aspirin',
        'description': 'مسكن للألم ومضاد للالتهاب ومميع للدم',
        'usage': 'يستخدم لتسكين الألم والالتهاب ومنع تجلط الدم',
        'dosage': '75-325 مجم يومياً حسب الحالة',
        'bestTime': 'يفضل تناوله مع الطعام',
        'warnings': 'قد يسبب نزيف في المعدة',
        'interactions': 'يتفاعل مع مميعات الدم الأخرى',
        'category': 'مسكنات',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'أموكسيسيلين',
        'activeIngredient': 'Amoxicillin',
        'description': 'مضاد حيوي واسع المجال',
        'usage': 'يستخدم لعلاج العدوى البكتيرية',
        'dosage': '250-500 مجم كل 8 ساعات',
        'bestTime': 'يمكن تناوله مع أو بدون طعام',
        'warnings': 'قد يسبب حساسية، أكمل الدورة كاملة',
        'interactions': 'قد يقلل فعالية حبوب منع الحمل',
        'category': 'مضادات حيوية',
        'isPrescriptionRequired': 1,
      },
      {
        'name': 'فيتامين د',
        'activeIngredient': 'Vitamin D3',
        'description': 'فيتامين أساسي لصحة العظام',
        'usage': 'يستخدم لعلاج ومنع نقص فيتامين د',
        'dosage': '1000-4000 وحدة دولية يومياً',
        'bestTime': 'يفضل تناوله مع وجبة تحتوي على دهون',
        'warnings': 'الجرعات العالية قد تسبب تسمم',
        'interactions': 'يزيد امتصاص الكالسيوم',
        'category': 'فيتامينات',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'أوميغا 3',
        'activeIngredient': 'Omega-3 Fatty Acids',
        'description': 'أحماض دهنية أساسية لصحة القلب والدماغ',
        'usage': 'يستخدم لدعم صحة القلب والدماغ',
        'dosage': '1-3 جرام يومياً',
        'bestTime': 'يفضل تناوله مع الوجبات',
        'warnings': 'قد يزيد خطر النزيف مع مميعات الدم',
        'interactions': 'يتفاعل مع أدوية مميعة للدم',
        'category': 'فيتامينات',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'ديكلوفيناك',
        'activeIngredient': 'Diclofenac',
        'description': 'مضاد قوي للالتهاب ومسكن للألم',
        'usage': 'يستخدم لعلاج التهاب المفاصل وآلام العضلات',
        'dosage': '50 مجم مرتين يومياً',
        'bestTime': 'يفضل تناوله مع الطعام',
        'warnings': 'قد يسبب مشاكل في القلب والمعدة',
        'interactions': 'يتفاعل مع أدوية القلب ومميعات الدم',
        'category': 'مضادات الالتهاب',
        'isPrescriptionRequired': 1,
      },
      {
        'name': 'لوراتادين',
        'activeIngredient': 'Loratadine',
        'description': 'مضاد للهيستامين لعلاج الحساسية',
        'usage': 'يستخدم لعلاج أعراض الحساسية والرشح',
        'dosage': '10 مجم مرة واحدة يومياً',
        'bestTime': 'يمكن تناوله في أي وقت',
        'warnings': 'قد يسبب نعاس خفيف',
        'interactions': 'تجنب مع الكحول',
        'category': 'مضادات الهيستامين',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'أوميبرازول',
        'activeIngredient': 'Omeprazole',
        'description': 'مثبط مضخة البروتون لعلاج الحموضة',
        'usage': 'يستخدم لعلاج قرحة المعدة والحموضة',
        'dosage': '20-40 مجم مرة واحدة يومياً',
        'bestTime': 'قبل الإفطار بـ 30 دقيقة',
        'warnings': 'الاستخدام طويل المدى قد يؤثر على امتصاص المعادن',
        'interactions': 'يتفاعل مع كلوبيدوجريل',
        'category': 'أدوية المعدة',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'سيمفاستاتين',
        'activeIngredient': 'Simvastatin',
        'description': 'دواء لخفض الكوليسترول',
        'usage': 'يستخدم لخفض مستوى الكوليسترول في الدم',
        'dosage': '20-40 مجم مرة واحدة مساءً',
        'bestTime': 'في المساء مع العشاء',
        'warnings': 'قد يسبب آلام في العضلات',
        'interactions': 'تجنب مع عصير الجريب فروت',
        'category': 'أدوية القلب',
        'isPrescriptionRequired': 1,
      },
      {
        'name': 'ميتفورمين',
        'activeIngredient': 'Metformin',
        'description': 'دواء لعلاج مرض السكري النوع الثاني',
        'usage': 'يستخدم للتحكم في مستوى السكر في الدم',
        'dosage': '500-1000 مجم مرتين يومياً',
        'bestTime': 'مع الوجبات',
        'warnings': 'قد يسبب اضطراب في المعدة',
        'interactions': 'تجنب مع الكحول',
        'category': 'أدوية السكري',
        'isPrescriptionRequired': 1,
      },
      {
        'name': 'أملوديبين',
        'activeIngredient': 'Amlodipine',
        'description': 'دواء لعلاج ضغط الدم المرتفع',
        'usage': 'يستخدم لخفض ضغط الدم وعلاج الذبحة الصدرية',
        'dosage': '5-10 مجم مرة واحدة يومياً',
        'bestTime': 'في نفس الوقت يومياً',
        'warnings': 'قد يسبب تورم في القدمين',
        'interactions': 'يتفاعل مع عصير الجريب فروت',
        'category': 'أدوية الضغط',
        'isPrescriptionRequired': 1,
      },
      {
        'name': 'فيتامين ب12',
        'activeIngredient': 'Cyanocobalamin',
        'description': 'فيتامين أساسي لصحة الأعصاب والدم',
        'usage': 'يستخدم لعلاج نقص فيتامين ب12',
        'dosage': '1000 ميكروجرام يومياً',
        'bestTime': 'يمكن تناوله في أي وقت',
        'warnings': 'آمن بشكل عام',
        'interactions': 'لا توجد تفاعلات مهمة',
        'category': 'فيتامينات',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'الكالسيوم',
        'activeIngredient': 'Calcium Carbonate',
        'description': 'معدن أساسي لصحة العظام والأسنان',
        'usage': 'يستخدم لتقوية العظام ومنع هشاشة العظام',
        'dosage': '500-1000 مجم يومياً',
        'bestTime': 'مع الوجبات',
        'warnings': 'قد يسبب إمساك',
        'interactions': 'يتفاعل مع بعض المضادات الحيوية',
        'category': 'فيتامينات',
        'isPrescriptionRequired': 0,
      },
      {
        'name': 'الحديد',
        'activeIngredient': 'Ferrous Sulfate',
        'description': 'معدن أساسي لتكوين خلايا الدم الحمراء',
        'usage': 'يستخدم لعلاج فقر الدم الناتج عن نقص الحديد',
        'dosage': '65 مجم مرة إلى ثلاث مرات يومياً',
        'bestTime': 'على معدة فارغة أو مع فيتامين ج',
        'warnings': 'قد يسبب إمساك واضطراب في المعدة',
        'interactions': 'يتفاعل مع الشاي والقهوة',
        'category': 'فيتامينات',
        'isPrescriptionRequired': 0,
      },
    ];

    for (final drug in sampleDrugs) {
      await db.insert('drugs', drug);
    }

    // Sample health tips - More comprehensive data
    final sampleHealthTips = [
      {
        'title': 'أهمية شرب الماء',
        'content': 'شرب 8-10 أكواب من الماء يومياً يساعد في الحفاظ على صحة الجسم وتحسين وظائف الأعضاء، ويساعد في الهضم وتنظيم درجة حرارة الجسم',
        'category': 'تغذية',
        'imageUrl': 'assets/images/water.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'فوائد المشي اليومي',
        'content': 'المشي لمدة 30 دقيقة يومياً يحسن صحة القلب ويقوي العضلات ويحسن المزاج ويساعد في حرق السعرات الحرارية',
        'category': 'رياضة',
        'imageUrl': 'assets/images/walking.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'أهمية النوم الصحي',
        'content': 'النوم لمدة 7-9 ساعات يومياً ضروري لتجديد خلايا الجسم وتحسين الذاكرة والتركيز وتقوية جهاز المناعة',
        'category': 'نوم',
        'imageUrl': 'assets/images/sleep.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'تناول الفواكه والخضروات',
        'content': 'تناول 5 حصص من الفواكه والخضروات يومياً يوفر الفيتامينات والمعادن الأساسية ويقلل خطر الأمراض المزمنة',
        'category': 'تغذية',
        'imageUrl': 'assets/images/fruits.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'تمارين التنفس للاسترخاء',
        'content': 'ممارسة تمارين التنفس العميق لمدة 10 دقائق يومياً يساعد في تقليل التوتر والقلق وتحسين الصحة النفسية',
        'category': 'صحة نفسية',
        'imageUrl': 'assets/images/breathing.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'غسل اليدين بانتظام',
        'content': 'غسل اليدين بالماء والصابون لمدة 20 ثانية على الأقل يحمي من العدوى والأمراض المعدية',
        'category': 'وقاية',
        'imageUrl': 'assets/images/handwash.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'تمارين الإطالة',
        'content': 'ممارسة تمارين الإطالة يومياً تحسن مرونة العضلات وتقلل آلام الظهر والرقبة وتحسن الدورة الدموية',
        'category': 'رياضة',
        'imageUrl': 'assets/images/stretching.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'تقليل السكر المضاف',
        'content': 'تقليل تناول السكر المضاف يساعد في الحفاظ على وزن صحي ويقلل خطر الإصابة بمرض السكري وأمراض القلب',
        'category': 'تغذية',
        'imageUrl': 'assets/images/sugar.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'التعرض لأشعة الشمس',
        'content': 'التعرض لأشعة الشمس لمدة 15-20 دقيقة يومياً يساعد الجسم في إنتاج فيتامين د الضروري لصحة العظام',
        'category': 'وقاية',
        'imageUrl': 'assets/images/sun.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
      {
        'title': 'التأمل والاسترخاء',
        'content': 'ممارسة التأمل لمدة 10-15 دقيقة يومياً يحسن التركيز ويقلل التوتر ويعزز الصحة النفسية والعقلية',
        'category': 'صحة نفسية',
        'imageUrl': 'assets/images/meditation.png',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isRead': 0,
      },
    ];

    for (final tip in sampleHealthTips) {
      await db.insert('health_tips', tip);
    }

    // Sample symptoms - More comprehensive data
    final sampleSymptoms = [
      {
        'name': 'صداع',
        'description': 'ألم في الرأس قد يكون خفيف أو شديد',
        'severity': 'متوسط',
        'relatedVitamins': 'فيتامين B2,فيتامين D,المغنيسيوم',
        'relatedSupplements': 'أوميغا 3,الكركم',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'تعب وإرهاق',
        'description': 'شعور بالتعب والإرهاق المستمر',
        'severity': 'خفيف',
        'relatedVitamins': 'فيتامين B12,فيتامين D,الحديد',
        'relatedSupplements': 'الجينسنغ,الكوكيو 10',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'ألم في المعدة',
        'description': 'ألم أو انزعاج في منطقة البطن',
        'severity': 'متوسط',
        'relatedVitamins': 'البروبيوتيك,فيتامين B1',
        'relatedSupplements': 'الزنجبيل,النعناع',
        'requiresDoctorVisit': 1,
      },
      {
        'name': 'سعال',
        'description': 'سعال جاف أو مع بلغم',
        'severity': 'خفيف',
        'relatedVitamins': 'فيتامين C,الزنك',
        'relatedSupplements': 'العسل,الزعتر',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'حمى',
        'description': 'ارتفاع في درجة حرارة الجسم',
        'severity': 'شديد',
        'relatedVitamins': 'فيتامين C,فيتامين D',
        'relatedSupplements': 'الإكيناسيا,الزنجبيل',
        'requiresDoctorVisit': 1,
      },
      {
        'name': 'دوخة',
        'description': 'شعور بعدم التوازن أو الدوار',
        'severity': 'متوسط',
        'relatedVitamins': 'فيتامين B12,الحديد',
        'relatedSupplements': 'الجنكة,المغنيسيوم',
        'requiresDoctorVisit': 1,
      },
      {
        'name': 'ألم في الظهر',
        'description': 'ألم في منطقة الظهر السفلي أو العلوي',
        'severity': 'متوسط',
        'relatedVitamins': 'فيتامين D,المغنيسيوم',
        'relatedSupplements': 'الكركم,الجلوكوزامين',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'أرق',
        'description': 'صعوبة في النوم أو البقاء نائماً',
        'severity': 'خفيف',
        'relatedVitamins': 'المغنيسيوم,الميلاتونين',
        'relatedSupplements': 'البابونج,الخزامى',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'غثيان',
        'description': 'شعور بالرغبة في التقيؤ',
        'severity': 'متوسط',
        'relatedVitamins': 'فيتامين B6',
        'relatedSupplements': 'الزنجبيل,النعناع',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'ألم في المفاصل',
        'description': 'ألم أو تيبس في المفاصل',
        'severity': 'متوسط',
        'relatedVitamins': 'فيتامين D,أوميغا 3',
        'relatedSupplements': 'الجلوكوزامين,الكركم',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'قلق وتوتر',
        'description': 'شعور بالقلق والتوتر النفسي',
        'severity': 'خفيف',
        'relatedVitamins': 'فيتامين B المركب,المغنيسيوم',
        'relatedSupplements': 'الأشواغاندا,البابونج',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'ضيق في التنفس',
        'description': 'صعوبة في التنفس أو الشعور بضيق',
        'severity': 'شديد',
        'relatedVitamins': 'فيتامين C,فيتامين E',
        'relatedSupplements': 'الكوكيو 10',
        'requiresDoctorVisit': 1,
      },
      {
        'name': 'طفح جلدي',
        'description': 'احمرار أو تهيج في الجلد',
        'severity': 'خفيف',
        'relatedVitamins': 'فيتامين E,فيتامين A',
        'relatedSupplements': 'الألوة فيرا,زيت جوز الهند',
        'requiresDoctorVisit': 0,
      },
      {
        'name': 'فقدان الشهية',
        'description': 'عدم الرغبة في تناول الطعام',
        'severity': 'متوسط',
        'relatedVitamins': 'فيتامين B المركب,الزنك',
        'relatedSupplements': 'الزنجبيل,النعناع',
        'requiresDoctorVisit': 1,
      },
      {
        'name': 'تساقط الشعر',
        'description': 'فقدان الشعر بشكل غير طبيعي',
        'severity': 'خفيف',
        'relatedVitamins': 'البيوتين,الحديد,فيتامين D',
        'relatedSupplements': 'الكولاجين,زيت الأرغان',
        'requiresDoctorVisit': 0,
      },
    ];

    for (final symptom in sampleSymptoms) {
      await db.insert('symptoms', symptom);
    }
  }

  // Drug operations
  Future<List<Drug>> getAllDrugs() async {
    return await _performanceService.measureOperation(
      'getAllDrugs',
      () async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('drugs');
        return List.generate(maps.length, (i) => Drug.fromMap(maps[i]));
      },
    );
  }

  Future<List<Drug>> searchDrugs(String query) async {
    return await _performanceService.measureOperation(
      'searchDrugs',
      () async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query(
          'drugs',
          where: 'name LIKE ? OR activeIngredient LIKE ? OR category LIKE ?',
          whereArgs: ['%$query%', '%$query%', '%$query%'],
        );
        return List.generate(maps.length, (i) => Drug.fromMap(maps[i]));
      },
      metadata: {'query': query, 'queryLength': query.length},
    );
  }

  // User profile operations
  Future<int> insertUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.insert('user_profiles', profile.toMap());
  }

  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_profiles', limit: 1);
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.update(
      'user_profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // Health tips operations
  Future<List<HealthTip>> getAllHealthTips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_tips',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => HealthTip.fromMap(maps[i]));
  }

  Future<List<HealthTip>> getHealthTipsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_tips',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => HealthTip.fromMap(maps[i]));
  }

  // Symptoms operations
  Future<List<Symptom>> getAllSymptoms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('symptoms');
    return List.generate(maps.length, (i) => Symptom.fromMap(maps[i]));
  }

  Future<List<Symptom>> searchSymptoms(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'symptoms',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Symptom.fromMap(maps[i]));
  }

  // Reset database for debugging
  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'healthy_app.db');
    await deleteDatabase(path);
    _database = null;
    await database; // This will recreate the database
  }

  // Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;

    final drugsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM drugs')
    ) ?? 0;

    final tipsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM health_tips')
    ) ?? 0;

    final symptomsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM symptoms')
    ) ?? 0;

    final profilesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user_profiles')
    ) ?? 0;

    return {
      'drugs': drugsCount,
      'health_tips': tipsCount,
      'symptoms': symptomsCount,
      'user_profiles': profilesCount,
    };
  }

  // Force refresh data
  Future<void> refreshAllData() async {
    await resetDatabase();
    // Database refreshed with latest sample data
  }

  // Get random health tips
  Future<List<HealthTip>> getRandomHealthTips({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM health_tips ORDER BY RANDOM() LIMIT ?',
      [limit],
    );
    return List.generate(maps.length, (i) => HealthTip.fromMap(maps[i]));
  }

  // Get drugs by category
  Future<List<Drug>> getDrugsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'drugs',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Drug.fromMap(maps[i]));
  }

  // Get all categories
  Future<List<String>> getDrugCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT category FROM drugs ORDER BY category',
    );
    return maps.map((map) => map['category'] as String).toList();
  }

  // Get health tip categories
  Future<List<String>> getHealthTipCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT category FROM health_tips ORDER BY category',
    );
    return maps.map((map) => map['category'] as String).toList();
  }
}