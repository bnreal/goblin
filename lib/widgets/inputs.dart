import 'package:flutter/material.dart';

class GoblinTextField extends StatelessWidget {
  GoblinTextField({Key? key, required this.hintText, required this.onSubmitted})
      : super(key: key);

  final String hintText;
  final ValueChanged<String> onSubmitted;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: _controller.clear,
          icon: const Icon(Icons.clear_rounded),
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
