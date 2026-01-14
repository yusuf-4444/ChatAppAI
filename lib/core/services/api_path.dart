class ApiPath {
  static const String users = 'users/';
  static String user(String userId) => 'users/$userId';
  static String chats(String userId) => 'users/$userId/chats/';
  static String chat(String userId, String chatId) =>
      'users/$userId/chats/$chatId';
}
