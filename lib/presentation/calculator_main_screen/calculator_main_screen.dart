import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calculator_button_grid_widget.dart';
import './widgets/calculator_display_widget.dart';
import './widgets/mode_toggle_widget.dart';

class CalculatorMainScreen extends StatefulWidget {
  const CalculatorMainScreen({super.key});

  @override
  State<CalculatorMainScreen> createState() => _CalculatorMainScreenState();
}

class _CalculatorMainScreenState extends State<CalculatorMainScreen>
    with TickerProviderStateMixin {
  // Calculator state
  String _display = '0';
  String _expression = '';
  String _previousResult = '';
  bool _isScientificMode = false;
  bool _isDegreeMode = true;
  double _memory = 0.0;
  bool _hasError = false;
  String _errorMessage = '';

  // Animation controllers
  late AnimationController _modeToggleController;
  late AnimationController _buttonPressController;
  late Animation<double> _modeToggleAnimation;
  late Animation<double> _buttonPressAnimation;

  // History storage
  final List<Map<String, String>> _calculationHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _modeToggleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonPressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _modeToggleAnimation = CurvedAnimation(
      parent: _modeToggleController,
      curve: Curves.easeInOut,
    );

    _buttonPressAnimation = CurvedAnimation(
      parent: _buttonPressController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _modeToggleController.dispose();
    _buttonPressController.dispose();
    super.dispose();
  }

  void _onButtonPressed(String value) {
    HapticFeedback.lightImpact();
    _buttonPressController.forward().then((_) {
      _buttonPressController.reverse();
    });

    setState(() {
      _hasError = false;
      _errorMessage = '';

      switch (value) {
        case 'C':
          _clear();
          break;
        case 'AC':
          _allClear();
          break;
        case '⌫':
          _backspace();
          break;
        case '=':
          _calculate();
          break;
        case '+':
        case '-':
        case '×':
        case '÷':
        case '^':
          _addOperator(value);
          break;
        case '.':
          _addDecimal();
          break;
        case '(':
        case ')':
          _addParenthesis(value);
          break;
        case '%':
          _calculatePercentage();
          break;
        case '±':
          _toggleSign();
          break;
        case 'sin':
        case 'cos':
        case 'tan':
        case 'ln':
        case 'log':
        case 'sqrt':
        case '!':
          _addFunction(value);
          break;
        case 'π':
          _addConstant(math.pi.toString());
          break;
        case 'e':
          _addConstant(math.e.toString());
          break;
        case 'MC':
          _memoryClear();
          break;
        case 'MR':
          _memoryRecall();
          break;
        case 'M+':
          _memoryAdd();
          break;
        case 'M-':
          _memorySubtract();
          break;
        case 'DEG':
        case 'RAD':
          _toggleAngleMode();
          break;
        default:
          _addNumber(value);
      }
    });
  }

  void _clear() {
    _display = '0';
    _expression = '';
  }

  void _allClear() {
    _display = '0';
    _expression = '';
    _previousResult = '';
    _memory = 0.0;
  }

  void _backspace() {
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
  }

  void _addNumber(String number) {
    if (_display == '0' || _hasError) {
      _display = number;
    } else {
      _display += number;
    }
  }

  void _addOperator(String operator) {
    if (_expression.isNotEmpty && !_isLastCharOperator()) {
      _expression += ' $operator ';
      _display = '0';
    } else if (_expression.isEmpty) {
      _expression = '$_display $operator ';
      _display = '0';
    }
  }

  void _addDecimal() {
    if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _addParenthesis(String parenthesis) {
    if (parenthesis == '(') {
      if (_display == '0') {
        _display = '(';
      } else {
        _display += '(';
      }
    } else {
      _display += ')';
    }
  }

  void _addFunction(String function) {
    if (_display == '0') {
      _display = '$function(';
    } else {
      _display = '$function($_display';
    }
  }

  void _addConstant(String constant) {
    if (_display == '0') {
      _display = constant;
    } else {
      _display += constant;
    }
  }

  void _calculatePercentage() {
    try {
      double value = double.parse(_display);
      _display = (value / 100).toString();
    } catch (e) {
      _showError('Invalid percentage operation');
    }
  }

  void _toggleSign() {
    if (_display != '0') {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else {
        _display = '-$_display';
      }
    }
  }

  void _memoryClear() {
    _memory = 0.0;
  }

  void _memoryRecall() {
    _display = _memory.toString();
  }

  void _memoryAdd() {
    try {
      _memory += double.parse(_display);
    } catch (e) {
      _showError('Invalid memory operation');
    }
  }

  void _memorySubtract() {
    try {
      _memory -= double.parse(_display);
    } catch (e) {
      _showError('Invalid memory operation');
    }
  }

  void _toggleAngleMode() {
    _isDegreeMode = !_isDegreeMode;
  }

  void _calculate() {
    try {
      String fullExpression = _expression + _display;
      double result = _evaluateExpression(fullExpression);

      _addToHistory(fullExpression, result.toString());
      _previousResult = _display;
      _display = _formatResult(result);
      _expression = '';
    } catch (e) {
      _showError('Invalid calculation');
    }
  }

  double _evaluateExpression(String expression) {
    // Basic expression evaluation
    // This is a simplified version - in production, use a proper math parser
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

    // Handle basic arithmetic
    try {
      // This is a simplified evaluation - in production use math_expressions package
      return _basicEvaluate(expression);
    } catch (e) {
      throw Exception('Calculation error');
    }
  }

  double _basicEvaluate(String expression) {
    // Simplified evaluation for demo purposes
    // In production, use a proper expression parser
    if (expression.contains('+')) {
      List<String> parts = expression.split('+');
      return double.parse(parts[0].trim()) + double.parse(parts[1].trim());
    } else if (expression.contains('-')) {
      List<String> parts = expression.split('-');
      if (parts.length == 2) {
        return double.parse(parts[0].trim()) - double.parse(parts[1].trim());
      }
    } else if (expression.contains('*')) {
      List<String> parts = expression.split('*');
      return double.parse(parts[0].trim()) * double.parse(parts[1].trim());
    } else if (expression.contains('/')) {
      List<String> parts = expression.split('/');
      double divisor = double.parse(parts[1].trim());
      if (divisor == 0) throw Exception('Division by zero');
      return double.parse(parts[0].trim()) / divisor;
    }
    return double.parse(expression);
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'0*\$'), '')
          .replaceAll(RegExp(r'\.\$'), '');
    }
  }

  void _addToHistory(String expression, String result) {
    _calculationHistory.insert(0, {
      'expression': expression,
      'result': result,
      'timestamp': DateTime.now().toString(),
    });

    // Keep only last 50 calculations
    if (_calculationHistory.length > 50) {
      _calculationHistory.removeRange(50, _calculationHistory.length);
    }
  }

  void _showError(String message) {
    _hasError = true;
    _errorMessage = message;
    _display = 'Error';
  }

  bool _isLastCharOperator() {
    if (_expression.isEmpty) return false;
    String lastChar = _expression.trim().split(' ').last;
    return ['+', '-', '×', '÷', '^'].contains(lastChar);
  }

  void _toggleMode() {
    setState(() {
      _isScientificMode = !_isScientificMode;
    });

    if (_isScientificMode) {
      _modeToggleController.forward();
    } else {
      _modeToggleController.reverse();
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _display));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Osura Cal',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/calculation-history-screen'),
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings-screen'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display Area (30% of screen)
            Expanded(
              flex: 3,
              child: GestureDetector(
                onLongPress: _copyToClipboard,
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    // Swipe right - clear
                    _clear();
                  } else if (details.primaryVelocity! < 0) {
                    // Swipe left - backspace
                    _backspace();
                  }
                },
                child: CalculatorDisplayWidget(
                  display: _display,
                  expression: _expression,
                  hasError: _hasError,
                  errorMessage: _errorMessage,
                  memory: _memory,
                ),
              ),
            ),

            // Mode Toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: ModeToggleWidget(
                isScientificMode: _isScientificMode,
                isDegreeMode: _isDegreeMode,
                onModeToggle: _toggleMode,
                animation: _modeToggleAnimation,
              ),
            ),

            // Button Grid (60% of screen)
            Expanded(
              flex: 6,
              child: AnimatedBuilder(
                animation: _buttonPressAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 - (_buttonPressAnimation.value * 0.02),
                    child: CalculatorButtonGridWidget(
                      isScientificMode: _isScientificMode,
                      isDegreeMode: _isDegreeMode,
                      onButtonPressed: _onButtonPressed,
                      memory: _memory,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
