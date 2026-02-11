/// User Model
class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final bool verified;
  final String? classroom;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.verified,
    this.classroom,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      verified: json['verified'] as bool? ?? true,
      classroom: json['classroom'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'verified': verified,
      'classroom': classroom,
    };
  }

  String get fullName => '$firstName $lastName';
}
