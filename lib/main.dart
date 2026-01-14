import 'package:chat_app_ai/core/utils/app_themes.dart';
import 'package:chat_app_ai/core/utils/router/app_router.dart';
import 'package:chat_app_ai/core/utils/router/app_routes.dart';
import 'package:chat_app_ai/features/auth/auth_cubit/auth_cubit.dart';
import 'package:chat_app_ai/features/home/chat_ai_cubit/chat_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const ChatAppAI());
}

class ChatAppAI extends StatelessWidget {
  const ChatAppAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatCubit()..startChattingSession()),
        BlocProvider(create: (context) => AuthCubit()..isUserLoggedIn()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: Builder(
          builder: (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              bloc: BlocProvider.of<AuthCubit>(context),
              buildWhen: (previous, current) => current is UserLoggedIn,
              builder: (context, state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Chat App AI',
                  theme: AppThemes.themeData,
                  onGenerateRoute: AppRouter.onGenerateRouter,
                  initialRoute: state is UserLoggedIn
                      ? AppRoutes.chat
                      : AppRoutes.login,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
