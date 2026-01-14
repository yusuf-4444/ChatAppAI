import 'package:chat_app_ai/chat_ai_cubit/chat_cubit.dart';
import 'package:chat_app_ai/utils/app_themes.dart';
import 'package:chat_app_ai/utils/router/app_router.dart';
import 'package:chat_app_ai/utils/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ChatAppAI());
}

class ChatAppAI extends StatelessWidget {
  const ChatAppAI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()..startChattingSession(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App AI',
          theme: AppThemes.themeData,
          onGenerateRoute: AppRouter.onGenerateRouter,
          initialRoute: AppRoutes.chat,
        ),
      ),
    );
  }
}
