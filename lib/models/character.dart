class Character {
  final String englishName;
  final int? age;
  final String? birthday;
  final String? bounty;
  final String? devilFruitName;
  final String? avatarSrc;

  Character({
    required this.englishName,
    this.age,
    this.birthday,
    this.bounty,
    this.devilFruitName,
    this.avatarSrc,
  });

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      englishName: map['englishName'] as String? ?? 'Unknown',
      age: map['age'] is int
          ? map['age'] as int
          : int.tryParse('${map['age']}'),
      birthday: map['birthday'] as String?,
      bounty: map['bounty']?.toString(),
      devilFruitName: map['devilFruitName'] as String?,
      avatarSrc: map['avatarSrc'] as String?,
    );
  }
}
