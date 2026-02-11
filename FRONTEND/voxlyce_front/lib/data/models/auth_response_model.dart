/// Auth Response Model
class AuthResponseModel {
  final String email;
  final String role;
  final String? token;
  final bool mfaRequired;
  final bool requires2FA; // Alias for mfaRequired

  AuthResponseModel({
    required this.email,
    required this.role,
    this.token,
    bool? mfaRequired,
    bool? requires2FA,
  })  : mfaRequired = mfaRequired ?? requires2FA ?? false,
        requires2FA = requires2FA ?? mfaRequired ?? false;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final mfaRequired = json['mfaRequired'] as bool? ?? false;
    final requires2FA = json['requires2FA'] as bool? ?? mfaRequired;
    
    return AuthResponseModel(
      email: json['email'] as String,
      role: json['role'] as String,
      token: json['token'] as String?,
      mfaRequired: mfaRequired,
      requires2FA: requires2FA,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'token': token,
      'mfaRequired': mfaRequired,
      'requires2FA': requires2FA,
    };
  }
}
