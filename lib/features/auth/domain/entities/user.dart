import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
  final int id;
  final String email;
  final String? name;
  final String accessToken;

  const User({
    required this.id,
    required this.email,
    this.name,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [id, email, name, accessToken];

  /// Create a copy with updated fields
  User copyWith({
    int? id,
    String? email,
    String? name,
    String? accessToken,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
