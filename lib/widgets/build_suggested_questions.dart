import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildSuggestedQuestions extends StatefulWidget {
  const BuildSuggestedQuestions({
    super.key,
    required this.textController,
    required this.focusNode,
  });

  final TextEditingController textController;

  final FocusNode focusNode;

  @override
  State<BuildSuggestedQuestions> createState() =>
      _BuildSuggestedQuestionsState();
}

class _BuildSuggestedQuestionsState extends State<BuildSuggestedQuestions> {
  final suggestions = [
    {'icon': Icons.lightbulb_outline, 'text': 'Give me ideas'},
    {'icon': Icons.code, 'text': 'Help me code'},
    {'icon': Icons.article_outlined, 'text': 'Write an article'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        alignment: WrapAlignment.center,
        children: suggestions.map((suggestion) {
          return InkWell(
            onTap: () {
              widget.textController.text = suggestion['text'] as String;
              widget.focusNode.requestFocus();
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    suggestion['icon'] as IconData,
                    size: 18.sp,
                    color: Colors.blue.shade600,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    suggestion['text'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
