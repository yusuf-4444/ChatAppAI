// lib/features/home/chat_ai_cubit/chat_cubit.dart

import 'dart:io';

import 'package:chat_app_ai/core/services/api_path.dart';
import 'package:chat_app_ai/core/services/auth_service.dart';
import 'package:chat_app_ai/core/services/firestore_services.dart';
import 'package:chat_app_ai/features/home/models/chat_history.dart';
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
  final NativeServices nativeServices = NativeServices();

  List<MessageModel> messageModel = [];
  File? selectedImage;
  String? currentChatID;

  void startChattingSession() {
    chatAIServices.startChattingSession();
    currentChatID = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void createNewChat() {
    messageModel.clear();
    selectedImage = null;
    currentChatID = DateTime.now().millisecondsSinceEpoch.toString();
    chatAIServices.startChattingSession();
    emit(ChatInitial());
  }

  Future<void> sendMessage(String message) async {
    final currentUser = authService.getCurrentUser();
    if (currentUser == null || currentChatID == null) return;

    try {
      emit(SendingMessage());

      final userMessage = MessageModel(
        message: message,
        isUser: true,
        time: DateTime.now(),
        image: selectedImage,
      );

      messageModel.add(userMessage);
      emit(MessageSent(messageModel));
      emit(SendingMessage());

      final response = await chatAIServices.sendMessage(message, selectedImage);

      final aiMessage = MessageModel(
        message: response!,
        isUser: false,
        time: DateTime.now(),
      );

      messageModel.add(aiMessage);
      emit(MessageSent(messageModel));

      await firestoreServices.setData(
        path: ApiPath.chat(currentUser.uid, currentChatID!),
        data: {
          'messages': messageModel.map((m) => m.toMap()).toList(),
          'lastUpdate': DateTime.now().millisecondsSinceEpoch,
          'lastMessage': message,
        },
      );

      selectedImage = null;
    } catch (e) {
      print(e);
      emit(MessageError(e.toString()));
    }
  }

  Future<void> loadChat(String chatID) async {
    final currentUser = authService.getCurrentUser();
    if (currentUser == null) return;

    try {
      emit(LoadingChat());

      final data = await firestoreServices.getDocument(
        path: ApiPath.chat(currentUser.uid, chatID),
        builder: (data, id) => data,
      );

      if (data['messages'] != null) {
        currentChatID = chatID;
        messageModel = (data['messages'] as List)
            .map(
              (messageMap) =>
                  MessageModel.fromMap(messageMap as Map<String, dynamic>),
            )
            .toList();

        chatAIServices.startChattingSession();

        emit(MessageSent(messageModel));
      }
    } catch (e) {
      print(e);
      emit(MessageError(e.toString()));
    }
  }

  Future<List<ChatHistory>> loadChatsHistory() async {
    final currentUser = authService.getCurrentUser();
    if (currentUser == null) return [];

    try {
      final chats = await firestoreServices.getCollection<ChatHistory>(
        path: ApiPath.chats(currentUser.uid),
        builder: (data, id) {
          final messages = data['messages'] as List?;
          final lastMessage =
              data['lastMessage'] as String? ??
              (messages?.isNotEmpty == true
                  ? messages!.last['message'] as String
                  : 'New chat');

          return ChatHistory(
            chatId: id,
            lastMessage: lastMessage,
            lastUpdate: DateTime.fromMillisecondsSinceEpoch(
              data['lastUpdate'] as int,
            ),
            messagesCount: messages?.length ?? 0,
          );
        },
        sort: (a, b) => b.lastUpdate.compareTo(a.lastUpdate),
      );

      emit(ChatsHistoryLoaded(chats));
      return chats;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteChat(String chatID) async {
    final currentUser = authService.getCurrentUser();
    if (currentUser == null) return;

    try {
      await firestoreServices.deleteData(
        path: ApiPath.chat(currentUser.uid, chatID),
      );

      if (currentChatID == chatID) {
        createNewChat();
      }

      await loadChatsHistory();
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
