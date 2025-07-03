import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './calculator_button_widget.dart';

class CalculatorButtonGridWidget extends StatelessWidget {
  final bool isScientificMode;
  final bool isDegreeMode;
  final Function(String) onButtonPressed;
  final double memory;

  const CalculatorButtonGridWidget({
    super.key,
    required this.isScientificMode,
    required this.isDegreeMode,
    required this.onButtonPressed,
    required this.memory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      child: isScientificMode ? _buildScientificGrid() : _buildBasicGrid(),
    );
  }

  Widget _buildBasicGrid() {
    final List<List<Map<String, dynamic>>> basicButtons = [
      [
        {'text': 'AC', 'type': 'clear', 'flex': 1},
        {'text': 'C', 'type': 'clear', 'flex': 1},
        {'text': '⌫', 'type': 'function', 'flex': 1},
        {'text': '÷', 'type': 'operator', 'flex': 1},
      ],
      [
        {'text': '7', 'type': 'number', 'flex': 1},
        {'text': '8', 'type': 'number', 'flex': 1},
        {'text': '9', 'type': 'number', 'flex': 1},
        {'text': '×', 'type': 'operator', 'flex': 1},
      ],
      [
        {'text': '4', 'type': 'number', 'flex': 1},
        {'text': '5', 'type': 'number', 'flex': 1},
        {'text': '6', 'type': 'number', 'flex': 1},
        {'text': '-', 'type': 'operator', 'flex': 1},
      ],
      [
        {'text': '1', 'type': 'number', 'flex': 1},
        {'text': '2', 'type': 'number', 'flex': 1},
        {'text': '3', 'type': 'number', 'flex': 1},
        {'text': '+', 'type': 'operator', 'flex': 1},
      ],
      [
        {'text': '±', 'type': 'function', 'flex': 1},
        {'text': '0', 'type': 'number', 'flex': 1},
        {'text': '.', 'type': 'number', 'flex': 1},
        {'text': '=', 'type': 'equals', 'flex': 1},
      ],
    ];

    return Column(
      children: basicButtons
          .map(
            (row) => Expanded(
              child: Row(
                children: row
                    .map(
                      (button) => Expanded(
                        flex: button['flex'] as int,
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: CalculatorButtonWidget(
                            text: button['text'] as String,
                            type: button['type'] as String,
                            onPressed: () =>
                                onButtonPressed(button['text'] as String),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildScientificGrid() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Scientific functions row 1
          SizedBox(
            height: 8.h,
            child: Row(
              children: [
                _buildScientificButton('sin', 'function'),
                _buildScientificButton('cos', 'function'),
                _buildScientificButton('tan', 'function'),
                _buildScientificButton('ln', 'function'),
                _buildScientificButton('log', 'function'),
              ],
            ),
          ),

          // Scientific functions row 2
          SizedBox(
            height: 8.h,
            child: Row(
              children: [
                _buildScientificButton('(', 'function'),
                _buildScientificButton(')', 'function'),
                _buildScientificButton('π', 'constant'),
                _buildScientificButton('e', 'constant'),
                _buildScientificButton('^', 'operator'),
              ],
            ),
          ),

          // Memory functions row
          SizedBox(
            height: 8.h,
            child: Row(
              children: [
                _buildScientificButton('MC', 'memory'),
                _buildScientificButton('MR', 'memory'),
                _buildScientificButton('M+', 'memory'),
                _buildScientificButton('M-', 'memory'),
                _buildScientificButton(
                    isDegreeMode ? 'DEG' : 'RAD', 'function'),
              ],
            ),
          ),

          // Basic calculator grid
          SizedBox(
            height: 40.h,
            child: _buildBasicGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildScientificButton(String text, String type) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: CalculatorButtonWidget(
          text: text,
          type: type,
          onPressed: () => onButtonPressed(text),
        ),
      ),
    );
  }
}
