import 'dart:io';

import 'package:chat_app_ai/utils/app_constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatWithAiServices {
  final model = GenerativeModel(
    model: "gemini-2.5-flash-lite",
    apiKey: AppConstants.apiKey,
  );

  late ChatSession _session;

  // Future<String?> sendingMessage(String prompt) async {
  //   final content = [Content.text(prompt)];
  //   final response = await model.generateContent(content);

  //   print(response.text);
  //   return response.text;
  // }

  void startChattingSession() {
    _session = model.startChat();
  }

  Future<String?> sendMessage(String message, [File? image]) async {
    late final Content content;

    if (image != null) {
      final bytes = await image.readAsBytes();
      content = Content.multi([
        TextPart(message),
        DataPart("image/jpeg", bytes),
      ]);
    } else {
      content = Content.text(message);
    }
    final response = await _session.sendMessage(content);

    print(response.text);
    return response.text;
  }
}
