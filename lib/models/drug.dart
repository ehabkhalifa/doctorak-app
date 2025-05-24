class Drug {
  final int? id;
  final String name;
  final String activeIngredient;
  final String description;
  final String usage;
  final String dosage;
  final String bestTime;
  final String warnings;
  final String interactions;
  final String category;
  final bool isPrescriptionRequired;

  Drug({
    this.id,
    required this.name,
    required this.activeIngredient,
    required this.description,
    required this.usage,
    required this.dosage,
    required this.bestTime,
    required this.warnings,
    required this.interactions,
    required this.category,
    this.isPrescriptionRequired = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'activeIngredient': activeIngredient,
      'description': description,
      'usage': usage,
      'dosage': dosage,
      'bestTime': bestTime,
      'warnings': warnings,
      'interactions': interactions,
      'category': category,
      'isPrescriptionRequired': isPrescriptionRequired ? 1 : 0,
    };
  }

  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      id: map['id'],
      name: map['name'] ?? '',
      activeIngredient: map['activeIngredient'] ?? '',
      description: map['description'] ?? '',
      usage: map['usage'] ?? '',
      dosage: map['dosage'] ?? '',
      bestTime: map['bestTime'] ?? '',
      warnings: map['warnings'] ?? '',
      interactions: map['interactions'] ?? '',
      category: map['category'] ?? '',
      isPrescriptionRequired: map['isPrescriptionRequired'] == 1,
    );
  }
}