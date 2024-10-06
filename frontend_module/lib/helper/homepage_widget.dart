import 'package:flutter/material.dart';
import "../data_model/message_data.dart";
import '../data_model/supported_language.dart';

class MessageHelper {
  static void showLanguageDialog(BuildContext context,
      Function(Language) onLanguageSelected, UserType user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
              user == UserType.user ? 'Select a Language' : 'Translate to :'),
          children: supportedLanguages.map((language) {
            return SimpleDialogOption(
              onPressed: () {
                onLanguageSelected(language);
                Navigator.pop(context);
              },
              child: Text(language.name),
            );
          }).toList(),
        );
      },
    );
  }

  static Future<String> fetchTranslation(String originalMessage) async {
    // Simulate a delay and translation result
    await Future.delayed(const Duration(seconds: 1));
    return 'Translated message in $originalMessage';
  }

  // Add user message and handle translation
  static Future<void> addMessage({
    required BuildContext context,
    required TextEditingController controller,
    required ScrollController scrollController,
    required List<MessageData> messages,
    required Function(List<MessageData>, bool) updateState,
    required List<Language> selectedLanguage,
  }) async {
    FocusScope.of(context).unfocus();
    if (controller.text.isNotEmpty) {
      String originalMessage = controller.text;
      MessageData request =
          MessageData(user: UserType.user, message: controller.text);
      controller.clear(); // Clear the TextField

      // Lock the UI by marking it as loading
      messages.add(request);
      updateState(messages, true);

      // Scroll to the bottom
      await Future.delayed(const Duration(milliseconds: 100));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);

      // Simulate the translation process
      String translatedMessage = await fetchTranslation(originalMessage);
      MessageData response =
          MessageData(user: UserType.translation, message: translatedMessage);

      // Update the state with the translated message and unlock UI
      messages.add(response);
      updateState(messages, false);

      await Future.delayed(const Duration(milliseconds: 100));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  static Widget buildLanguageSelectionButton(
      BuildContext context,
      UserType user,
      Language selectedLanguage,
      Function(Language) onLanguageSelected) {
    return ElevatedButton(
      onPressed: () {
        MessageHelper.showLanguageDialog(
          context,
          (selectedLanguage) {
            onLanguageSelected(
                selectedLanguage);
          },
          user,
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        elevation: 2,
      ),
      child: SizedBox(width:MediaQuery.of(context).size.width *0.2 ,
        child: Center(
          child: Text(
            selectedLanguage.name.toUpperCase(), // Display selected language
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: MediaQuery.of(context).size.width *0.036,
                overflow: TextOverflow.ellipsis
            ),
          ),
        ),
      ),
    );
  }
}
