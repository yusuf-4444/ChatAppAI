import 'dart:io';

class MessageModel {
  final String message;
  final bool isUser;
  final File? image;
  final DateTime time;

  MessageModel({
    required this.message,
    required this.isUser,
    required this.time,
    this.image,
  });

  MessageModel copyWith({String? message, bool? isUser, DateTime? time}) {
    return MessageModel(
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      time: time ?? this.time,
      image: image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'isUser': isUser,
      'time': time.millisecondsSinceEpoch,
      'image': image,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] as String,
      isUser: map['isUser'] as bool,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      image: map['image'] as File?,
    );
  }
}
