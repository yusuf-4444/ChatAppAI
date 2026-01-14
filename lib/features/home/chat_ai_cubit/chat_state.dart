// lib/features/home/chat_ai_cubit/chat_state.dart

part of 'chat_cubit.dart';

class ChatState {}

final class ChatInitial extends ChatState {}

final class SendingMessage extends ChatState {}

final class MessageSent extends ChatState {
  final List<MessageModel> message;
  MessageSent(this.message);
}

final class MessageError extends ChatState {
  final String message;
  MessageError(this.message);
}

final class ImagePicked extends ChatState {
  final String image;
  ImagePicked(this.image);
}

final class ImageCleared extends ChatState {}

final class LoadingChat extends ChatState {}

final class ChatsHistoryLoaded extends ChatState {
  final List<ChatHistory> chats;
  ChatsHistoryLoaded(this.chats);
}
