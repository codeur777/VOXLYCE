/// Form Validators
class Validators {
  /// Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email requis';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }
    
    return null;
  }

  /// Required field validator
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }

  /// Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe requis';
    }
    
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    
    return null;
  }

  /// Confirm password validator
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmation requise';
    }
    
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }

  /// Phone number validator
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numéro de téléphone requis';
    }
    
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Numéro de téléphone invalide';
    }
    
    return null;
  }

  /// Minimum length validator
  static String? minLength(String? value, int length, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    
    if (value.length < length) {
      return '${fieldName ?? 'Ce champ'} doit contenir au moins $length caractères';
    }
    
    return null;
  }

  /// Maximum length validator
  static String? maxLength(String? value, int length, [String? fieldName]) {
    if (value != null && value.length > length) {
      return '${fieldName ?? 'Ce champ'} ne doit pas dépasser $length caractères';
    }
    
    return null;
  }
}
