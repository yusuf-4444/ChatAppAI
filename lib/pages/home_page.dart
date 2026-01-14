import 'package:chat_app_ai/chat_ai_cubit/chat_cubit.dart';
import 'package:chat_app_ai/widgets/build_input_area.dart';
import 'package:chat_app_ai/widgets/build_suggested_questions.dart';
import 'package:chat_app_ai/widgets/custom_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChatCubit>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                color: Colors.blue.shade700,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade700),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        bloc: cubit,
        buildWhen: (previous, current) =>
            current is MessageSent || current is MessageError,
        builder: (context, state) {
          if (state is MessageError) {
            return Center(
              child: RefreshIndicator(
                onRefresh: () {
                  cubit.startChattingSession();
                  return Future.value();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "limit reached!, please try again later.",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is MessageSent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    itemCount: state.message.length,
                    itemBuilder: (context, index) {
                      final message = state.message[index];
                      final isLastMessage = index == state.message.length - 1;

                      return CustomMessageWidget(
                        message: message,
                        onAnimationProgress: isLastMessage && !message.isUser
                            ? _scrollToBottom
                            : null,
                      );
                    },
                  ),
                ),

                BuildInputArea(
                  cubit: cubit,
                  textController: textController,
                  focusNode: focusNode,
                  scrollToBottom: _scrollToBottom,
                ),
              ],
            );
          }

          // Empty State
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: ListView(
                    children: [
                      SizedBox(height: 48.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 64.sp,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "Hello! How can I help you today?",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Ask me anything...",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          BuildSuggestedQuestions(
                            textController: textController,
                            focusNode: focusNode,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              BuildInputArea(
                cubit: cubit,
                textController: textController,
                focusNode: focusNode,
                scrollToBottom: _scrollToBottom,
              ),
            ],
          );
        },
      ),
    );
  }
}
