import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_selection_widget.dart';
import './widgets/settings_stepper_widget.dart';
import './widgets/settings_switch_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Display settings
  int _decimalPlaces = 4;
  bool _thousandsSeparator = true;
  String _resultFormat = 'Standard';

  // Calculation settings
  String _angleUnit = 'Degrees';
  bool _autoParentheses = true;
  String _calculationPrecision = 'High';

  // Memory settings
  String _memoryState = 'Empty';

  // History settings
  int _maxHistoryEntries = 100;
  String _autoDeleteTimeframe = 'Never';

  // Accessibility settings
  double _hapticIntensity = 0.5;
  bool _buttonSounds = true;
  bool _voiceOverAnnouncements = false;

  // App info
  final String _appVersion = '1.0.0';
  final String _developerInfo = 'Osura Development Team';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _decimalPlaces = prefs.getInt('decimal_places') ?? 4;
      _thousandsSeparator = prefs.getBool('thousands_separator') ?? true;
      _resultFormat = prefs.getString('result_format') ?? 'Standard';
      _angleUnit = prefs.getString('angle_unit') ?? 'Degrees';
      _autoParentheses = prefs.getBool('auto_parentheses') ?? true;
      _calculationPrecision =
          prefs.getString('calculation_precision') ?? 'High';
      _maxHistoryEntries = prefs.getInt('max_history_entries') ?? 100;
      _autoDeleteTimeframe =
          prefs.getString('auto_delete_timeframe') ?? 'Never';
      _hapticIntensity = prefs.getDouble('haptic_intensity') ?? 0.5;
      _buttonSounds = prefs.getBool('button_sounds') ?? true;
      _voiceOverAnnouncements =
          prefs.getBool('voice_over_announcements') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('decimal_places', _decimalPlaces);
    await prefs.setBool('thousands_separator', _thousandsSeparator);
    await prefs.setString('result_format', _resultFormat);
    await prefs.setString('angle_unit', _angleUnit);
    await prefs.setBool('auto_parentheses', _autoParentheses);
    await prefs.setString('calculation_precision', _calculationPrecision);
    await prefs.setInt('max_history_entries', _maxHistoryEntries);
    await prefs.setString('auto_delete_timeframe', _autoDeleteTimeframe);
    await prefs.setDouble('haptic_intensity', _hapticIntensity);
    await prefs.setBool('button_sounds', _buttonSounds);
    await prefs.setBool('voice_over_announcements', _voiceOverAnnouncements);
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reset to Defaults',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _resetToDefaults();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningLight,
              ),
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _resetToDefaults() {
    setState(() {
      _decimalPlaces = 4;
      _thousandsSeparator = true;
      _resultFormat = 'Standard';
      _angleUnit = 'Degrees';
      _autoParentheses = true;
      _calculationPrecision = 'High';
      _maxHistoryEntries = 100;
      _autoDeleteTimeframe = 'Never';
      _hapticIntensity = 0.5;
      _buttonSounds = true;
      _voiceOverAnnouncements = false;
    });
    _saveSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings reset to defaults'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _clearMemory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear Memory',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to clear all stored memory values?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _memoryState = 'Empty';
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Memory cleared'),
                    backgroundColor: AppTheme.successLight,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningLight,
              ),
              child: Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _exportHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('History exported successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Text(
              'Osura Cal respects your privacy. This calculator app does not collect, store, or transmit any personal data. All calculations and settings are stored locally on your device.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              // Display Section
              SettingsSectionWidget(
                title: 'Display',
                children: [
                  SettingsStepperWidget(
                    title: 'Decimal Places',
                    subtitle: 'Number of decimal places to show',
                    value: _decimalPlaces,
                    min: 2,
                    max: 10,
                    onChanged: (value) {
                      setState(() {
                        _decimalPlaces = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SettingsSwitchWidget(
                    title: 'Thousands Separator',
                    subtitle: 'Show comma separators in large numbers',
                    value: _thousandsSeparator,
                    onChanged: (value) {
                      setState(() {
                        _thousandsSeparator = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SettingsSelectionWidget(
                    title: 'Result Format',
                    subtitle: 'How results are displayed',
                    value: _resultFormat,
                    options: ['Standard', 'Scientific', 'Engineering'],
                    onChanged: (value) {
                      setState(() {
                        _resultFormat = value;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Calculation Section
              SettingsSectionWidget(
                title: 'Calculation',
                children: [
                  SettingsSelectionWidget(
                    title: 'Angle Unit',
                    subtitle: 'Unit for trigonometric functions',
                    value: _angleUnit,
                    options: ['Degrees', 'Radians'],
                    onChanged: (value) {
                      setState(() {
                        _angleUnit = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SettingsSwitchWidget(
                    title: 'Auto Parentheses',
                    subtitle: 'Automatically close parentheses',
                    value: _autoParentheses,
                    onChanged: (value) {
                      setState(() {
                        _autoParentheses = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SettingsSelectionWidget(
                    title: 'Calculation Precision',
                    subtitle: 'Precision level for calculations',
                    value: _calculationPrecision,
                    options: ['Standard', 'High', 'Maximum'],
                    onChanged: (value) {
                      setState(() {
                        _calculationPrecision = value;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Memory Section
              SettingsSectionWidget(
                title: 'Memory',
                children: [
                  SettingsItemWidget(
                    title: 'Memory State',
                    subtitle: 'Current memory status: $_memoryState',
                    trailing: CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  SettingsItemWidget(
                    title: 'Clear Memory',
                    subtitle: 'Clear all stored memory values',
                    trailing: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.warningLight,
                      size: 20,
                    ),
                    onTap: _clearMemory,
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // History Section
              SettingsSectionWidget(
                title: 'History',
                children: [
                  SettingsStepperWidget(
                    title: 'Max History Entries',
                    subtitle: 'Maximum number of calculations to store',
                    value: _maxHistoryEntries,
                    min: 50,
                    max: 500,
                    step: 50,
                    onChanged: (value) {
                      setState(() {
                        _maxHistoryEntries = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SettingsSelectionWidget(
                    title: 'Auto Delete',
                    subtitle: 'Automatically delete old history',
                    value: _autoDeleteTimeframe,
                    options: ['Never', '1 Week', '1 Month', '3 Months'],
                    onChanged: (value) {
                      setState(() {
                        _autoDeleteTimeframe = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SettingsItemWidget(
                    title: 'Export History',
                    subtitle: 'Export calculation history to file',
                    trailing: CustomIconWidget(
                      iconName: 'file_download',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    onTap: _exportHistory,
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Accessibility Section
              SettingsSectionWidget(
                title: 'Accessibility',
                children: [
                  SettingsItemWidget(
                    title: 'Haptic Intensity',
                    subtitle:
                        'Vibration strength: ${(_hapticIntensity * 100).round()}%',
                    trailing: SizedBox(
                      width: 30.w,
                      child: Slider(
                        value: _hapticIntensity,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _hapticIntensity = value;
                          });
                          _saveSettings();
                        },
                        activeColor: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    onTap: () {},
                  ),
                  SettingsSwitchWidget(
                    title: 'Button Sounds',
                    subtitle: 'Play sound when buttons are pressed',
                    value: _buttonSounds,
                    onChanged: (value) {
                      setState(() {
                        _buttonSounds = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SettingsSwitchWidget(
                    title: 'Voice Announcements',
                    subtitle: 'Announce calculations for accessibility',
                    value: _voiceOverAnnouncements,
                    onChanged: (value) {
                      setState(() {
                        _voiceOverAnnouncements = value;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // About Section
              SettingsSectionWidget(
                title: 'About',
                children: [
                  SettingsItemWidget(
                    title: 'App Version',
                    subtitle: _appVersion,
                    trailing: CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  SettingsItemWidget(
                    title: 'Developer',
                    subtitle: _developerInfo,
                    trailing: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  SettingsItemWidget(
                    title: 'Privacy Policy',
                    subtitle: 'View our privacy policy',
                    trailing: CustomIconWidget(
                      iconName: 'privacy_tip',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    onTap: _showPrivacyPolicy,
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Reset Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton(
                  onPressed: _showResetDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warningLight,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Reset to Defaults',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
