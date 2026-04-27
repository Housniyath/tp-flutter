class HabitModel {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;

  HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
  });

  
  factory HabitModel.fromMap(Map<String, dynamic> json, String documentId) {
    return HabitModel(
      id: documentId,
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      createdAt: (json['createdAt'] != null) 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}