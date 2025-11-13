import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String bio;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? bio,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
    );
  }

  @override
  List<Object> get props => [id, name, email, phone, bio];
}