// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppOtpForm extends StatefulWidget {
  const AppOtpForm({
    required this.onCompleted,
    required this.onChange,
    this.numberOfInputs = 4,
    this.obscured = true,
    this.enabled = true,
    super.key,
    this.errorText,
  });

  final void Function(String) onCompleted; // Callback when OTP is completed
  final void Function(String) onChange; // Callback when OTP is completed
  final int numberOfInputs;
  final bool obscured;
  final bool enabled;
  final String? errorText;
  @override
  State<AppOtpForm> createState() => _AppOtpFormState();
}

class _AppOtpFormState extends State<AppOtpForm> {
  late final List<TextEditingController> _controllers;

  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.numberOfInputs,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.numberOfInputs, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field if not the last one
      if (index < widget.numberOfInputs - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus(); // Close keyboard on last digit
      }
    }

    // If all fields are filled, trigger the callback
    final otp = _controllers.map((e) => e.text).join();
    widget.onChange(otp);

    if (otp.length == widget.numberOfInputs) {
      widget.onCompleted(otp);
    }
  }

  void _onKeyPress(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.sm,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.md,
            children: List.generate(
              widget.numberOfInputs,
              (index) {
                return KeyboardListener(
                  focusNode: FocusNode(), // Needed for backspace detection
                  onKeyEvent: (event) => _onKeyPress(event, index),
                  child: AppTextField.underlineBorder(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.errorText != null
                            ? AppColors.red
                            : AppColors.grey.withValues(alpha: 0.5),
                      ),
                    ),

                    textController: _controllers[index],
                    focusNode: _focusNodes[index],
                    enabled: widget.enabled,
                    textAlign: TextAlign.center,
                    textInputType: TextInputType.number,
                    obscureText: widget.obscured,
                    obscuringCharacter: '*',
                    maxLength: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    constraints: const BoxConstraints(
                      maxHeight: 35,
                      maxWidth: 35,
                    ),
                    style: const TextStyle(
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    onChanged: (value) => _onChanged(value, index),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.errorText != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.errorText!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.red,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
