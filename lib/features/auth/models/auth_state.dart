// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String phoneNumber;
  final bool loading;
  final String email;
  final String password;
  final String? generatedOtp;
  final DateTime? otpSentAt;
  final bool obscurePassword;

  const AuthState({
    required this.phoneNumber,
    required this.loading,
    required this.email,
    required this.password,
    this.generatedOtp,
    this.otpSentAt,
    this.obscurePassword = true,
  });

  AuthState copyWith({
    String? phoneNumber,
    bool? loading,
    String? email,
    String? password,
    String? generatedOtp,
    DateTime? otpSentAt,
    bool? obscurePassword,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      loading: loading ?? this.loading,
      email: email ?? this.email,
      password: password ?? this.password,
      generatedOtp: generatedOtp ?? this.generatedOtp,
      otpSentAt: otpSentAt ?? this.otpSentAt,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [
        phoneNumber,
        loading,
        email,
        password,
        otpSentAt,
      ];
}
