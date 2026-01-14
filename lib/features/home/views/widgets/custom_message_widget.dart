import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app_ai/features/home/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMessageWidget extends StatefulWidget {
  const CustomMessageWidget({
    super.key,
    required this.message,
    this.onAnimationProgress,
  });

  final MessageModel message;
  final VoidCallback? onAnimationProgress;

  @override
  State<CustomMessageWidget> createState() => _CustomMessageWidgetState();
}

class _CustomMessageWidgetState extends State<CustomMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: widget.message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.message.isUser) ...[
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 18.sp,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 280.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: widget.message.isUser
                    ? LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade500],
                      )
                    : null,
                color: widget.message.isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                  bottomLeft: widget.message.isUser
                      ? Radius.circular(20.r)
                      : Radius.circular(4.r),
                  bottomRight: widget.message.isUser
                      ? Radius.circular(4.r)
                      : Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.message.isUser
                        ? Colors.blue.withOpacity(0.15)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: widget.message.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  widget.message.isUser
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.message.image != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.file(
                                  widget.message.image!,
                                  width: 200.w,
                                  height: 200.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Text(
                              widget.message.message,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                height: 1.4,
                              ),
                            ),
                          ],
                        )
                      : AnimatedTextKit(
                          totalRepeatCount: 1,
                          repeatForever: false,
                          isRepeatingAnimation: false,
                          onTap: null,
                          displayFullTextOnTap: true,
                          animatedTexts: [
                            TyperAnimatedText(
                              widget.message.message,
                              textStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 15.sp,
                                height: 1.4,
                              ),
                              speed: const Duration(milliseconds: 10),
                            ),
                          ],
                          onNext: (index, isLast) {
                            if (widget.onAnimationProgress != null) {
                              widget.onAnimationProgress!();
                            }
                          },
                        ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(widget.message.time),
                        style: TextStyle(
                          color: widget.message.isUser
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade500,
                          fontSize: 11.sp,
                        ),
                      ),
                      if (widget.message.isUser) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.done_all,
                          size: 14.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (widget.message.isUser) ...[
            SizedBox(width: 8.w),
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 18.sp, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
