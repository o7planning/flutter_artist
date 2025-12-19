import 'package:flutter/material.dart';

const double _debugBoxFontSize = 11.5;

abstract class BaseDebugBox extends StatelessWidget {
  final labelStyle0 = const TextStyle(
    color: Colors.indigo,
    fontWeight: FontWeight.bold,
    fontSize: _debugBoxFontSize,
  );

  final textStyle0 = const TextStyle(
    color: Colors.deepOrange,
    fontSize: _debugBoxFontSize,
  );

  final labelStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: _debugBoxFontSize,
  );

  final labelStyle1 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: _debugBoxFontSize,
    color: Colors.blue,
  );

  final textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: _debugBoxFontSize,
  );

  const BaseDebugBox({super.key});

  List<Widget> getChildIconLabelTexts();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = getChildIconLabelTexts();
    return Container(
      padding: EdgeInsets.all(5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.isEmpty
            ? children
            : children
                .expand(
                  (w) => [
                    w,
                    const SizedBox(height: 5),
                  ],
                )
                .toList(),
      ),
    );
  }
}
