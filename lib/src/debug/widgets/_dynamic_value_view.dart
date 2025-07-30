import 'package:flutter/material.dart';

class DynamicValueView extends StatelessWidget {
  final dynamic value;

  const DynamicValueView({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        value.toString(),
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
