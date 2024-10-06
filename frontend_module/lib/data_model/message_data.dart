enum UserType { user, translation , error }

class MessageData {
  UserType user;
  String message;
  String? pronunciation;

  MessageData({required this.user, required this.message, this.pronunciation});

  String get userLabel {
    switch (user) {
      case UserType.user:
        return 'User Input :';
      case UserType.translation:
        return 'Translation :';
      case UserType.error:
        return 'Error :';
    }
  }
}
