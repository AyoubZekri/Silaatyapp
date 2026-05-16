import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') return newValue;
    if (RegExp(r'^\d*\.?\d{0,3}$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class QuantityInput extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? Mycontroller;
  final double initialValue;
  final Function(double) onChanged;
  final bool isDecimal;

  const QuantityInput({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.hintText,
    this.Mycontroller,
    this.isDecimal = false,
  });

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  late TextEditingController _controller;
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;

    _controller = widget.Mycontroller ?? TextEditingController();
    _controller.text =
        _value % 1 == 0 ? _value.toInt().toString() : _value.toString();

    _controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    if (!mounted) return;
    final parsed = double.tryParse(_controller.text);
    if (parsed != null && parsed != _value) {
      _value = parsed;
      widget.onChanged(_value);
    }
  }

  void _updateValue(double newValue) {
    if (!mounted) return;
    setState(() {
      _value = newValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.text =
            _value % 1 == 0 ? _value.toInt().toString() : _value.toString();
      });
    });
    widget.onChanged(_value);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    if (widget.Mycontroller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.grey, width: 2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Icon(Icons.production_quantity_limits,
              color: AppColor.backgroundcolor),
          const SizedBox(width: 10),
          Container(height: 30, width: 1, color: AppColor.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _controller,
              keyboardType: widget.isDecimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number,
              inputFormatters: widget.isDecimal
                  ? [DecimalTextInputFormatter()]
                  : [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.grey),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (_value >= 1) _updateValue(_value - 1);
                },
                icon:
                    Icon(Icons.arrow_back_ios, color: AppColor.grey, size: 16),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  _updateValue(_value + 1);
                },
                icon: Icon(Icons.arrow_forward_ios,
                    color: AppColor.grey, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
