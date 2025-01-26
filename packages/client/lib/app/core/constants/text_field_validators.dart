mixin TextFieldValidators {
  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty.';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (emailRegex.hasMatch(email.trim())) {
      return '';
    } else {
      return 'Invalid email address.';
    }
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty.';
    }

    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasMinLength = password.length >= 8;
    final commonPasswords = RegExp(
      r'^(password|123456|test|qwerty)$',
      caseSensitive: false,
    );

    if (hasUpperCase &&
        hasLowerCase &&
        hasNumber &&
        hasMinLength &&
        !commonPasswords.hasMatch(password)) {
      return '';
    } else {
      List<String> errors = [];
      if (!hasMinLength) errors.add('at least 8 characters');
      if (!hasUpperCase) errors.add('an uppercase letter');
      if (!hasLowerCase) errors.add('a lowercase letter');
      if (!hasNumber) errors.add('a number');
      if (commonPasswords.hasMatch(password)) {
        errors.add('not be a common password');
      }

      return 'Password must ${errors.join(', ')}.';
    }
  }

  String validateFullName(String fullName) {
    if (fullName.isEmpty) {
      return 'Full name cannot be empty.';
    }

    if (RegExp(r'^\w+\s+\w+').hasMatch(fullName.trim())) {
      return '';
    } else {
      return 'Please enter your full name (e.g., John Doe).';
    }
  }
}
