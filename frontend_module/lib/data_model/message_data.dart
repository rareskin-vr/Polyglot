enum UserType { user, translation }

class MessageData {
  UserType user;
  String message;

  MessageData({
    required this.user,
    required this.message,
  });

  String get userLabel {
    switch (user) {
      case UserType.user:
        return 'User Input :';
      case UserType.translation:
        return 'Translation :';
    }
  }
}
