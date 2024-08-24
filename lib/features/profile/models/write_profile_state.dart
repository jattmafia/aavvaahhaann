// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/models/location.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:equatable/equatable.dart';

class WriteProfileState extends Equatable {
  final bool loading;
  final Profile profile;

  final Location? location;

  const WriteProfileState({
    required this.loading,
    required this.profile,
    this.location,
  });



  WriteProfileState copyWith({
    bool? loading,
    Profile? profile,
    Location? location,
  }) {
    return WriteProfileState(
      loading: loading ?? this.loading,
      profile: profile ?? this.profile,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [loading, profile];
}
