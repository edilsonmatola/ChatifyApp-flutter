class RegExpUtils {
  // * Validador de Email
  String? emailValidator(String email) {
    if (email.isEmpty) {
      return 'Insert your email';
    } else if (!!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  // * Validador de password
  String? passwordValidator(String password) {
    if (password.isEmpty) {
      return 'Insert a password';
    } else if (!RegExp('.{8,}').hasMatch(password)) {
      return 'password has to be at least 8 char long';
    }
    return null;
  }
}
