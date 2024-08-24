class LocObj {
  final String name;
  final String iso;
  LocObj({
    required this.name,
    required this.iso,
  });

  factory LocObj.fromMap(Map<String, dynamic> map) {
    return LocObj(
      name: map['name'] as String,
      iso: map['iso2'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'iso2': iso,
    };
  }
}
