class FormValidator {
  static final _emailRegex = RegExp(
      r"^[-!#$%&'*+/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+/0-9=?A-Z^_a-z{|}~])*@[a-zA-Z](-?[a-zA-Z0-9])*(\.[a-zA-Z](-?[a-zA-Z0-9])*)+$");

  static final _password = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

  static String? name(String? text,
          [String warningText = "Enter a valid name"]) =>
      (text?.length ?? 0) <= 2 ? warningText : null;

  static String? email(String? text) =>
      _emailRegex.hasMatch(text ?? "") ? null : "Enter a valid email";

  static String? password(String? text) => _password.hasMatch(text ?? '')
      ? null
      : "Password must have a minimum eight characters, at least one letter and one number";
}
