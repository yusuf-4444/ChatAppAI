import 'dart:io';

import 'package:chat_app_ai/core/services/api_path.dart';
import 'package:chat_app_ai/core/services/auth_service.dart';
import 'package:chat_app_ai/core/services/firestore_services.dart';
import 'package:chat_app_ai/features/home/models/message_model.dart';
import 'package:chat_app_ai/features/home/services/chat_with_ai_services.dart';
import 'package:chat_app_ai/features/home/services/native_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final ChatWithAiServices chatAIServices = ChatWithAiServices();
  final FirestoreServices firestoreServices = FirestoreServices.instance;
  final AuthServiceImpl authService = AuthServiceImpl();

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
    final currentUser = authService.getCurrentUser();
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
      firestoreServices.setData(
        path: ApiPath.chat(currentUser!.uid),
        data: MessageModel(
          message: message,
          isUser: true,
          time: DateTime.now(),
          image: selectedImage,
        ).toMap(),
      );
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
