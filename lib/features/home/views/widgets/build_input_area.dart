import 'dart:io';

import 'package:chat_app_ai/features/home/chat_ai_cubit/chat_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildInputArea extends StatefulWidget {
  const BuildInputArea({
    super.key,
    required this.cubit,
    required this.textController,
    required this.focusNode,
    this.scrollToBottom,
  });

  final ChatCubit cubit;
  final TextEditingController textController;
  final FocusNode focusNode;
  final void Function()? scrollToBottom;

  @override
  State<BuildInputArea> createState() => _BuildInputAreaState();
}

class _BuildInputAreaState extends State<BuildInputArea> {
  void openOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                widget.cubit.pickImageFromCamera();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                widget.cubit.pickImageFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder(
                bloc: widget.cubit,
                buildWhen: (previous, current) =>
                    current is ImagePicked || current is ImageCleared,
                builder: (context, state) {
                  if (state is ImageCleared) {
                    return const SizedBox.shrink();
                  }
                  if (state is ImagePicked) {
                    return Stack(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Image.file(
                            File(state.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () {
                                widget.cubit.clearImage();
                              },
                              child: Icon(
                                Icons.close,
                                size: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      openOptions();
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: TextField(
                        controller: widget.textController,
                        focusNode: widget.focusNode,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        style: TextStyle(fontSize: 15.sp),
                        onSubmitted: (_) => _sendMessage(widget.cubit),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  BlocBuilder<ChatCubit, ChatState>(
                    bloc: widget.cubit,
                    buildWhen: (previous, current) =>
                        current is SendingMessage || current is MessageSent,
                    builder: (context, state) {
                      if (state is SendingMessage) {
                        return Container(
                          width: 44.w,
                          height: 44.w,
                          padding: EdgeInsets.all(10.w),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.blue.shade600,
                          ),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade400,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: BlocBuilder<ChatCubit, ChatState>(
                          bloc: widget.cubit,
                          buildWhen: (previous, current) =>
                              current is MessageSent ||
                              current is SendingMessage,
                          builder: (context, state) {
                            if (state is SendingMessage) {
                              return Container(
                                width: 44.w,
                                height: 44.w,
                                padding: EdgeInsets.all(10.w),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return IconButton(
                              icon: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 22.sp,
                              ),
                              onPressed: () {
                                _sendMessage(widget.cubit);
                                widget.textController.clear();
                                widget.cubit.clearImage();
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(ChatCubit cubit) {
    if (widget.textController.text.trim().isEmpty) return;
    cubit.sendMessage(widget.textController.text.trim());
    widget.textController.clear();

    Future.delayed(const Duration(milliseconds: 100), widget.scrollToBottom);
  }
}
