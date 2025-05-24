class UserProfile {
  final int? id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String healthGoals;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String activityLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.healthGoals,
    required this.allergies,
    required this.chronicConditions,
    required this.activityLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) return 'نقص في الوزن';
    if (bmi < 25) return 'وزن طبيعي';
    if (bmi < 30) return 'زيادة في الوزن';
    return 'سمنة';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'healthGoals': healthGoals,
      'allergies': allergies.join(','),
      'chronicConditions': chronicConditions.join(','),
      'activityLevel': activityLevel,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
      gender: map['gender'] ?? '',
      healthGoals: map['healthGoals'] ?? '',
      allergies: map['allergies']?.split(',') ?? [],
      chronicConditions: map['chronicConditions']?.split(',') ?? [],
      activityLevel: map['activityLevel'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }
}