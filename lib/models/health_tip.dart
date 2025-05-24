class HealthTip {
  final int? id;
  final String title;
  final String content;
  final String category;
  final String imageUrl;
  final DateTime createdAt;
  final bool isRead;

  HealthTip({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory HealthTip.fromMap(Map<String, dynamic> map) {
    return HealthTip(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      isRead: map['isRead'] == 1,
    );
  }
}

class Symptom {
  final int? id;
  final String name;
  final String description;
  final String severity;
  final List<String> relatedVitamins;
  final List<String> relatedSupplements;
  final bool requiresDoctorVisit;

  Symptom({
    this.id,
    required this.name,
    required this.description,
    required this.severity,
    required this.relatedVitamins,
    required this.relatedSupplements,
    this.requiresDoctorVisit = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'severity': severity,
      'relatedVitamins': relatedVitamins.join(','),
      'relatedSupplements': relatedSupplements.join(','),
      'requiresDoctorVisit': requiresDoctorVisit ? 1 : 0,
    };
  }

  factory Symptom.fromMap(Map<String, dynamic> map) {
    return Symptom(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      severity: map['severity'] ?? '',
      relatedVitamins: map['relatedVitamins']?.split(',') ?? [],
      relatedSupplements: map['relatedSupplements']?.split(',') ?? [],
      requiresDoctorVisit: map['requiresDoctorVisit'] == 1,
    );
  }
}