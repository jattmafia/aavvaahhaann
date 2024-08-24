// ignore_for_file: public_member_api_docs, sort_constructors_first
class Location {
  final String? country;
  final String? state;
  final String? city;
  final String? isoCode;
  final String? stateCode;
  
  Location({
    required this.country,
    required this.state,
    required this.city,
    required this.isoCode,
    required this.stateCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'state': state,
      'city': city,
      'iso_code': isoCode,
      'state_code': stateCode,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    print(map);
    return Location(
      country: map['country'] as String?,
      state: map['state'] as String?,
      city: map['city'] as String?,
      isoCode: map['iso_code'] as String?,
      stateCode: map['state_code'] as String?,
    );
  }


  Location copyWith({
    String? country,
    String? state,
    String? city,
    String? isoCode,
    String? stateCode,
    bool clearCity = false,
    bool clearState = false,
  }) {
    return Location(
      country: country ?? this.country,
      state: clearState ? null : state ?? this.state,
      city: clearCity ? null : city ?? this.city,
      isoCode: isoCode ?? this.isoCode,
      stateCode: stateCode ?? this.stateCode,
    );
  }
}
