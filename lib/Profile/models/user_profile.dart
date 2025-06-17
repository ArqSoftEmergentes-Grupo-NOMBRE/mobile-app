import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String name;
  final String email;
  final String? phone;

  const UserProfile({
    required this.name,
    required this.email,
    this.phone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) {
    return UserProfile(
      name: j['name'] as String? ?? '',
      email: j['email'] as String? ?? '',
      phone: j['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
  };

  @override
  List<Object?> get props => [name, email, phone];
}
