import 'package:flutter/material.dart';
import 'package:my_app/src/provider/core/user_provider.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  final UserProfile user;
  const CalculatorPage({super.key, required this.user});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String userInput = '0', result = '';

  static const ops = ['+', '-', '×', '÷'];
  static const buttons = [
    ['C', '%', '⌫', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', '='],
  ];

  void buttonPressed(String v) => setState(() {
        switch (v) {
          case 'C':
            userInput = '0';
            result = '';
            break;
          case '⌫':
            if (userInput.isNotEmpty) {
              userInput = userInput.substring(0, userInput.length - 1);
              if (userInput.isEmpty) userInput = '0';
            }
            break;
          case '.':
            if (!userInput.split(RegExp(r'[+\-×÷]')).last.contains('.')) {
              userInput += v;
            }
            break;
          case '%':
            final m = RegExp(r'(\d+(\.\d+)?)$').firstMatch(userInput);
            if (m != null) {
              final num = double.parse(m[1]!) / 100;
              userInput = userInput.replaceRange(m.start, null, '$num');
            }
            break;
          case '=':
            userInput = result;
            result = '0';
            break;
          default:
            if (RegExp(r'^\d$').hasMatch(v)) {
              final parts = userInput.split(RegExp(r'[+\-×÷]'));
              final last = parts.isNotEmpty ? parts.last : '';
              if (userInput == '0') {
                userInput = v;
              } else if (last == '0' && !last.contains('.')) {
                userInput = userInput.substring(0, userInput.length - 1) + v;
              } else {
                userInput += v;
              }
            } else if (ops.contains(v)) {
              if (userInput.isEmpty && v != '-') return;
              if (ops.contains(userInput.characters.last)) {
                userInput = userInput.substring(0, userInput.length - 1);
              }
              userInput += v;
            }
        }
        _updateResult();
      });

  void _updateResult() {
    if (userInput.isEmpty ||
        !ops.any(userInput.contains) ||
        ops.contains(userInput.characters.last)) {
      result = '';
      return;
    }
    try {
      final exp = ShuntingYardParser()
          .parse(userInput.replaceAll('×', '*').replaceAll('÷', '/'));
      final val = RealEvaluator().evaluate(exp);
      result = val % 1 == 0 ? val.toInt().toString() : val.toString();
    } catch (_) {
      result = '';
    }
  }

  Widget _display(String t, double s) => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        child: Text(t, style: TextStyle(fontSize: s)),
      );

  Widget _button(String t) => Expanded(
        child: ElevatedButton(
          onPressed: () => buttonPressed(t),
          child: Text(t, style: const TextStyle(fontSize: 24)),
        ),
      );

  Widget _buttonRow(List<String> row) => Row(
        children: [
          for (int i = 0; i < row.length; i++) ...[
            _button(row[i]),
            if (i != row.length - 1) const SizedBox(width: 3),
          ]
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _display(userInput, 32),
            _display(result, 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: Column(
                children: [
                  for (int i = 0; i < buttons.length; i++) ...[
                    _buttonRow(buttons[i]),
                    if (i != buttons.length - 1) const SizedBox(height: 3),
                  ]
                ],
              ),
            )
          ],
        ),
      );
}
