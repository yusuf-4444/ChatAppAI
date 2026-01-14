import 'dart:io';

import 'package:chat_app_ai/models/message_model.dart';
import 'package:chat_app_ai/services/chat_with_ai_services.dart';
import 'package:chat_app_ai/services/native_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final ChatWithAiServices chatAIServices = ChatWithAiServices();

  List<MessageModel> messageModel = [];
  final NativeServices nativeServices = NativeServices();
  File? selectedImage;

  // Future<void> sendingMessage(String prompt) async {
  //   try {
  //     emit(SendingMessage());
  //     final response = await chatAIServices.sendingMessage(prompt);
  //     emit(MessageSent(response!));
  //   } catch (e) {
  //     emit(MessageError(e.toString()));
  //   }
  // }

  void startChattingSession() {
    chatAIServices.startChattingSession();
  }

  Future<void> sendMessage(String message) async {
    try {
      emit(SendingMessage());
      messageModel.add(
        MessageModel(
          message: message,
          isUser: true,
          time: DateTime.now(),
          image: selectedImage,
        ),
      );
      emit(MessageSent(messageModel));
      emit(SendingMessage());

      final response = await chatAIServices.sendMessage(message, selectedImage);
      messageModel.add(
        MessageModel(message: response!, isUser: false, time: DateTime.now()),
      );
      emit(MessageSent(messageModel));
    } catch (e) {
      print(e);
      emit(MessageError(e.toString()));
    }
  }

  Future<void> pickImageFromCamera() async {
    final image = await nativeServices.pickImage(ImageSource.camera);
    if (image != null) {
      selectedImage = image;
      emit(ImagePicked(image.path));
    }
  }

  Future<void> pickImageFromGallery() async {
    final image = await nativeServices.pickImage(ImageSource.gallery);
    if (image != null) {
      selectedImage = image;
      emit(ImagePicked(image.path));
    }
  }

  void clearImage() {
    selectedImage = null;
    emit(ImageCleared());
  }
}
