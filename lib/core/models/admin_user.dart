import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first



class AdminUser {
  final int id;
  final String name;
  final String email;
  final List<String> permissions;
  final String uid;
  final bool? owner;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.permissions,
    required this.uid,
    this.owner,
  });

  factory AdminUser.fromMap(Map<String, dynamic> map) {
    return AdminUser(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      permissions: List<String>.from((map['permissions'] as Iterable)),
      uid: map['uid'] as String,
      owner: map['owner'] as bool?,
    );
  }
}
