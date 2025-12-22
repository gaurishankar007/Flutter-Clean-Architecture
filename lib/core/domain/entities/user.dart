import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.isActive,
  });

  const User.empty()
    : id = 0,
      firstName = '',
      lastName = '',
      username = '',
      email = '',
      isActive = false;
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final bool isActive;

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'email': email,
    'is_active': isActive,
  };

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    username,
    email,
    isActive,
  ];
}
