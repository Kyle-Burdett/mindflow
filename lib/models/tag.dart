class Tag {
  final String category;
  final String name;
  final num value;

  Tag({
    required this.category,
    required this.name,
    required this.value,
  });

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      value: map['value'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'name': name,
      'value': value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag &&
        other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}