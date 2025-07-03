import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ModeToggleWidget extends StatelessWidget {
  final bool isScientificMode;
  final bool isDegreeMode;
  final VoidCallback onModeToggle;
  final Animation<double> animation;

  const ModeToggleWidget({
    super.key,
    required this.isScientificMode,
    required this.isDegreeMode,
    required this.onModeToggle,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Mode Toggle
          Expanded(
            flex: 2,
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Animated background
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Positioned(
                        left: animation.value * 50.w,
                        top: 0,
                        bottom: 0,
                        width: 50.w - 4.w,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    },
                  ),

                  // Toggle buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isScientificMode ? onModeToggle : null,
                          child: SizedBox(
                            height: double.infinity,
                            child: Center(
                              child: Text(
                                'Basic',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: !isScientificMode
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                  fontWeight: !isScientificMode
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: !isScientificMode ? onModeToggle : null,
                          child: SizedBox(
                            height: double.infinity,
                            child: Center(
                              child: Text(
                                'Scientific',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: isScientificMode
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                  fontWeight: isScientificMode
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 2.w),

          // Angle mode indicator (only in scientific mode)
          if (isScientificMode)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isDegreeMode
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDegreeMode
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.secondary,
                  width: 1,
                ),
              ),
              child: Text(
                isDegreeMode ? 'DEG' : 'RAD',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: isDegreeMode
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
