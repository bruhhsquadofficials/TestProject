import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalculatorDisplayWidget extends StatelessWidget {
  final String display;
  final String expression;
  final bool hasError;
  final String errorMessage;
  final double memory;

  const CalculatorDisplayWidget({
    super.key,
    required this.display,
    required this.expression,
    required this.hasError,
    required this.errorMessage,
    required this.memory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Memory indicator
          if (memory != 0.0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'memory',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'M: ${_formatMemory(memory)}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

          // Expression display
          if (expression.isNotEmpty && !hasError)
            SizedBox(
              width: double.infinity,
              child: Text(
                expression,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),

          // Main display
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 8.h),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                hasError ? errorMessage : display,
                style: hasError
                    ? AppTheme.lightTheme.textTheme.displayMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      )
                    : AppTheme.lightTheme.textTheme.displayLarge,
                textAlign: TextAlign.right,
                maxLines: 1,
              ),
            ),
          ),

          // Help text
          if (!hasError)
            Text(
              'Long press to copy • Swipe for actions',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  String _formatMemory(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }
}
