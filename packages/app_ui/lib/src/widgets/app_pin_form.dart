// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class AppPinForm extends StatefulWidget {
  const AppPinForm({
    required this.onCompleted,
    super.key,
    this.length = 4,
    this.onChange,
    this.onFingerprintAuthentication,
    this.obscured = true,
    this.enabled = true,
    this.error = false,
  });
  final void Function(String) onCompleted; // Callback when OTP is completed
  final int length;
  final void Function(String)? onChange; // Callback when OTP is changing
  final VoidCallback? onFingerprintAuthentication;
  final bool obscured;
  final bool enabled;
  final bool error;

  @override
  State<AppPinForm> createState() => _AppPinFormState();
}

class _AppPinFormState extends State<AppPinForm> {
  late final List<String> _otpValues; // Stores OTP values
  int _currentIndex = 0; // Tracks the active input field

  @override
  void initState() {
    super.initState();
    _otpValues = List.filled(widget.length, '');
  }

  void _onNumberPressed(String value) {
    if (!widget.enabled) return;

    if (_currentIndex < widget.length) {
      setState(() {
        _otpValues[_currentIndex] = value;
        _currentIndex++; // Move to the next field
      });

      // Call onChange method
      widget.onChange?.call(_otpValues.join());

      // Call onCompleted method
      if (_currentIndex == widget.length) {
        widget.onCompleted(_otpValues.join());
      }
    }
  }

  void _onBackspacePressed() {
    if (!widget.enabled) return;

    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _otpValues[_currentIndex] = ''; // Clear last entry
      });

      // Call onChange method
      widget.onChange?.call(_otpValues.join());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOtpFields(),
        const SizedBox(height: 24),
        _buildKeyboard(),
      ],
    );
  }

  Widget _buildOtpFields() {
    final hasError = widget.error;
    final shadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 14,
        offset: const Offset(0, 8),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightBlueFilled,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasError
              ? AppColors.red
              : AppColors.brightGrey.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.md,
        children: List.generate(widget.length, (index) {
          final active = _currentIndex == index;
          final filled = _otpValues[index].isNotEmpty;

          return AnimatedContainer(
            duration: 180.ms,
            width: 58,
            height: 64,
            decoration: BoxDecoration(
              gradient: hasError || !active
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.white,
                        Color(0xFFE8F6FF),
                      ],
                    ),
              color: hasError
                  ? AppColors.red.shade50
                  : active
                      ? null
                      : AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasError
                    ? AppColors.red
                    : active
                        ? AppColors.blue
                        : AppColors.brightGrey,
                width: active ? 1.4 : 1,
              ),
              boxShadow: active || filled ? shadow : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: 150.ms,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: hasError ? AppColors.red : AppColors.black,
                  ),
                  child: Text(
                    widget.obscured && filled ? '•' : _otpValues[index],
                  ),
                ),
                AnimatedContainer(
                  duration: 150.ms,
                  margin: const EdgeInsets.only(top: 6),
                  height: 3,
                  width: active ? 18 : 10,
                  decoration: BoxDecoration(
                    color: hasError
                        ? AppColors.red
                        : active
                            ? AppColors.blue
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Custom numeric keyboard layout
  Widget _buildNumberPad(String digit, {String? option}) {
    final text = Text(
      digit,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.brightGrey.withValues(alpha: 0.7),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: widget.enabled ? () => _onNumberPressed(digit) : null,
              borderRadius: BorderRadius.circular(18),
              splashColor: AppColors.blue.withValues(alpha: 0.12),
              highlightColor: AppColors.blue.withValues(alpha: 0.05),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: option == null
                      ? text
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            text,
                            const SizedBox(height: 4),
                            Text(
                              option,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildFingerprintButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.brightGrey.withValues(alpha: 0.7),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: widget.onFingerprintAuthentication,
              borderRadius: BorderRadius.circular(18),
              splashColor: AppColors.blue.withValues(alpha: 0.12),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    Icon(Icons.fingerprint_outlined),
                    Text(
                      'Fingerprint',
                      style: TextStyle(
                        color: Color(0xff171B2A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackSpaceButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.brightGrey.withValues(alpha: 0.7),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: widget.enabled ? _onBackspacePressed : null,
              borderRadius: BorderRadius.circular(18),
              splashColor: AppColors.blue.withValues(alpha: 0.12),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Icon(
                    Icons.backspace_outlined,
                    size: 22,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildKeyboard() => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightBlueFilled,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.brightGrey.withValues(alpha: 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildNumberPad('1'),
                    _buildNumberPad('2'),
                    _buildNumberPad('3'),
                  ],
                ),
                Row(
                  children: [
                    _buildNumberPad('4'),
                    _buildNumberPad('5'),
                    _buildNumberPad('6'),
                  ],
                ),
                Row(
                  children: [
                    _buildNumberPad('7'),
                    _buildNumberPad('8'),
                    _buildNumberPad('9'),
                  ],
                ),
                Row(
                  children: [
                    _buildBackSpaceButton(),
                    _buildNumberPad('0', option: '+'),
                    _buildFingerprintButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
