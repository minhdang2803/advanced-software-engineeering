extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
            '''^(([^<>()[\\]\\\\.,;:\\s@"]+(\\.[^<>()[\\]\\\\.,;:\\s@"]+)*)|(".+"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))\$''')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$").hasMatch(this);
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String fromGGErrorToError() {
    if (this == 'wrong-password') {
      return "Password is not correct!";
    }
    if (this == 'too-many-requests') {
      return "Too many requests sent. Try later!";
    }
    if (this == 'sign_in_failed') {
      return "Request canceled!";
    }
    return this;
  }
}
