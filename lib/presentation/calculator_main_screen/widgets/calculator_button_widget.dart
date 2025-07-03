import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalculatorButtonWidget extends StatefulWidget {
  final String text;
  final String type;
  final VoidCallback onPressed;

  const CalculatorButtonWidget({
    super.key,
    required this.text,
    required this.type,
    required this.onPressed,
  });

  @override
  State<CalculatorButtonWidget> createState() => _CalculatorButtonWidgetState();
}

class _CalculatorButtonWidgetState extends State<CalculatorButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getButtonColor() {
    switch (widget.type) {
      case 'number':
        return AppTheme.lightTheme.colorScheme.surface;
      case 'operator':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'equals':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'clear':
        return AppTheme.lightTheme.colorScheme.error;
      case 'function':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'memory':
        return AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1);
      case 'constant':
        return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
      default:
        return AppTheme.lightTheme.colorScheme.surface;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case 'number':
        return AppTheme.lightTheme.colorScheme.onSurface;
      case 'operator':
      case 'equals':
        return AppTheme.lightTheme.colorScheme.onPrimary;
      case 'clear':
        return AppTheme.lightTheme.colorScheme.onError;
      case 'function':
        return AppTheme.lightTheme.colorScheme.onSecondary;
      case 'memory':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'constant':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  Color _getBorderColor() {
    switch (widget.type) {
      case 'memory':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'constant':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              constraints: BoxConstraints(
                minHeight: 6.h,
                minWidth: 8.w,
              ),
              decoration: BoxDecoration(
                color: _getButtonColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getBorderColor(),
                  width: widget.type == 'memory' || widget.type == 'constant'
                      ? 1.5
                      : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.text,
                    style: _getTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle? _getTextStyle() {
    final baseStyle = AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
      color: _getTextColor(),
      fontWeight: FontWeight.w600,
    );

    // Adjust font size based on button type and text length
    if (widget.text.length > 3) {
      return baseStyle?.copyWith(fontSize: 12.sp);
    } else if (widget.type == 'number' && widget.text.length == 1) {
      return baseStyle?.copyWith(fontSize: 18.sp);
    } else {
      return baseStyle?.copyWith(fontSize: 14.sp);
    }
  }
}
