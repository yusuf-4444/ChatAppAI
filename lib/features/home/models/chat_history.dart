class ChatHistory {
  final String chatId;
  final String lastMessage;
  final DateTime lastUpdate;
  final int messagesCount;

  ChatHistory({
    required this.chatId,
    required this.lastMessage,
    required this.lastUpdate,
    required this.messagesCount,
  });

  String get displayTime {
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastUpdate.day}/${lastUpdate.month}/${lastUpdate.year}';
    }
  }
}
