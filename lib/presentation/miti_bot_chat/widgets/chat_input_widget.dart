import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;
  final VoidCallback onVoiceMessage;
  final VoidCallback onCameraCapture;
  final bool isRecording;

  const ChatInputWidget({
    Key? key,
    required this.controller,
    required this.onSendMessage,
    required this.onVoiceMessage,
    required this.onCameraCapture,
    this.isRecording = false,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.controller.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Camera button
            GestureDetector(
              onTap: widget.onCameraCapture,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            // Text input field
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 10.w,
                  maxHeight: 20.w,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(5.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Ask MitiBot about trees...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            // Voice/Send button
            GestureDetector(
              onTap: _hasText
                  ? () {
                      if (widget.controller.text.trim().isNotEmpty) {
                        widget.onSendMessage(widget.controller.text.trim());
                        widget.controller.clear();
                      }
                    }
                  : widget.onVoiceMessage,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: _hasText
                      ? AppTheme.lightTheme.colorScheme.primary
                      : (widget.isRecording
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: CustomIconWidget(
                  iconName:
                      _hasText ? 'send' : (widget.isRecording ? 'stop' : 'mic'),
                  color: _hasText
                      ? Colors.white
                      : (widget.isRecording
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.primary),
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
