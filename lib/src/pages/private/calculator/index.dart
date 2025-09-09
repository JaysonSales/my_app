import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = '0';
  String _currentInput = '';
  double _num1 = 0;
  String _operator = '';

  void _buttonPressed(String buttonText) {
    if (buttonText == 'C') {
      _clear();
    } else if (buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/') {
      _handleOperator(buttonText);
    } else if (buttonText == '=') {
      _calculate();
    } else {
      _handleNumber(buttonText);
    }
  }

  void _clear() {
    setState(() {
      _output = '0';
      _currentInput = '';
      _num1 = 0;
      _operator = '';
    });
  }

  void _handleNumber(String number) {
    setState(() {
      if (_currentInput.length < 10) {
        _currentInput += number;
        _output = _currentInput;
      }
    });
  }

  void _handleOperator(String operator) {
    if (_currentInput.isNotEmpty) {
      _num1 = double.parse(_currentInput);
      _operator = operator;
      _currentInput = '';
    }
  }

  void _calculate() {
    if (_currentInput.isNotEmpty && _operator.isNotEmpty) {
      double num2 = double.parse(_currentInput);
      double result = 0;

      switch (_operator) {
        case '+':
          result = _num1 + num2;
          break;
        case '-':
          result = _num1 - num2;
          break;
        case '*':
          result = _num1 * num2;
          break;
        case '/':
          if (num2 != 0) {
            result = _num1 / num2;
          } else {
            _output = 'Error';
            return;
          }
          break;
      }

      setState(() {
        _output = result.toString();
        _currentInput = '';
        _num1 = 0;
        _operator = '';
      });
    }
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(),
          Column(
            children: [
              Row(
                children: <Widget>[
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('/'),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('*'),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-'),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton('C'),
                  _buildButton('0'),
                  _buildButton('='),
                  _buildButton('+'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
