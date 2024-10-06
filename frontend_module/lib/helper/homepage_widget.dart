import 'dart:convert';

import 'package:flutter/material.dart';
import "../data_model/message_data.dart";
import '../data_model/supported_language.dart';
import 'package:http/http.dart' as http;

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

  static Future<Map<String, dynamic>> fetchTranslation(
      String message, List<Language> selectedLanguage) async {
    try {
      final response = await http.post(
          Uri.parse(
              'http://192.168.31.80:9090/api/translate/'), // Replace with your API URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'text': message,
            'source_lang': selectedLanguage[0].code,
            'target_lang': selectedLanguage[1].code,
          }));

      if (response.statusCode == 200) {
        // Assume the response contains a JSON object with "translation" and "pronunciation" fields
        final jsonResponse = jsonDecode(response.body);
        return {
          'status': 200,
          'translation': jsonResponse['translation'],
          'pronunciation': jsonResponse['pronunciation'],
        };
      } else if (response.statusCode == 400) {
        // If the response status is 400, return an error message
        return {
          'status': 400,
          'error': 'Error: Invalid request or message format',
        };
      } else {
        // Handle other status codes
        return {
          'status': response.statusCode,
          'error': 'Unexpected error occurred',
        };
      }
    } catch (e) {
      // If an exception occurs (e.g., network error)
      return {
        'status': 500,
        'error':
            'Failed to fetch translation. Please check your network connection.',
      };
    }
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

      Map<String, dynamic> translatedMessage =
          await fetchTranslation(originalMessage, selectedLanguage);
      MessageData response;
      if (translatedMessage['status'] == 200) {
        response = MessageData(
            user: UserType.translation,
            message: translatedMessage['translation'],
            pronunciation: translatedMessage['pronunciation']);
      } else {
        response = MessageData(
          user: UserType.error,
          message: translatedMessage['error'],
        );
      }

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
            onLanguageSelected(selectedLanguage);
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Center(
          child: Text(
            selectedLanguage.name.toUpperCase(), // Display selected language
            style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: MediaQuery.of(context).size.width * 0.036,
                overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }
}
