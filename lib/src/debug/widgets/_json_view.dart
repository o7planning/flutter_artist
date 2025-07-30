import 'package:flutter/material.dart';

class JsonView extends StatelessWidget {
  final String json;

  const JsonView({
    super.key,
    required this.json,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      child: Align(
        alignment: Alignment.topLeft,
        child: TextFormField(
          initialValue: json,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
