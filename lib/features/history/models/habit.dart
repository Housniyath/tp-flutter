/// Modèle simplifié d'une habitude — copié ici pour que le Membre 4
/// puisse travailler en autonomie. Le vrai modèle est dans la branche du Membre 2.
class Habit {
  final String id;
  final String name;
  final String userId;

  const Habit({
    required this.id,
    required this.name,
    required this.userId,
  });

  factory Habit.fromMap(Map<String, dynamic> map, String docId) {
    return Habit(
      id: docId,
      name: map['name'] as String,
      userId: map['userId'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'userId': userId,
      };
}
