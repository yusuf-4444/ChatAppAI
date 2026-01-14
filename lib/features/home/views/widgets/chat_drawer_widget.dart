import 'package:chat_app_ai/core/utils/router/app_routes.dart';
import 'package:chat_app_ai/features/auth/auth_cubit/auth_cubit.dart';
import 'package:chat_app_ai/features/home/chat_ai_cubit/chat_cubit.dart';
import 'package:chat_app_ai/features/home/models/chat_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({super.key});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  List<ChatHistory> chats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final chatCubit = context.read<ChatCubit>();
    final loadedChats = await chatCubit.loadChatsHistory();
    setState(() {
      chats = loadedChats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();
    final authCubit = context.read<AuthCubit>();
    final userName = authCubit.currentUserData?.userName ?? 'User';

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20.h),
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 35.sp,
                    color: Colors.blue.shade600,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  authCubit.currentUserData?.email ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // New Chat Button
          Padding(
            padding: EdgeInsets.all(12.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  chatCubit.createNewChat();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'New Chat',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),

          Divider(color: Colors.grey.shade300, height: 1),

          // Chat History Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(Icons.history, size: 20.sp, color: Colors.grey.shade600),
                SizedBox(width: 8.w),
                Text(
                  'Recent Chats',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          // Chat History List
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              buildWhen: (previous, current) => current is ChatsHistoryLoaded,
              builder: (context, state) {
                if (state is ChatsHistoryLoaded) {
                  chats = state.chats;
                }
                if (chats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No chats yet',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final isCurrentChat =
                        chat.chatId == chatCubit.currentChatID;

                    return Dismissible(
                      key: Key(chat.chatId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.w),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        chatCubit.deleteChat(chat.chatId);
                        setState(() {
                          chats.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chat deleted')),
                        );
                      },
                      child: Container(
                        color: isCurrentChat
                            ? Colors.blue.shade50
                            : Colors.transparent,
                        child: ListTile(
                          leading: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: isCurrentChat
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 20.sp,
                              color: isCurrentChat
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade600,
                            ),
                          ),
                          title: Text(
                            chat.lastMessage.length > 30
                                ? '${chat.lastMessage.substring(0, 30)}...'
                                : chat.lastMessage,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: isCurrentChat
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${chat.messagesCount} messages • ${chat.displayTime}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onTap: () {
                            chatCubit.loadChat(chat.chatId);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Divider(color: Colors.grey.shade300, height: 1),

          // Logout Button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade400),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              await authCubit.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
