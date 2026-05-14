import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../core/widgets/_floating_copy_button.dart';

class JsonView extends StatelessWidget {
  final String json;

  const JsonView({
    super.key,
    required this.json,
  });

  factory JsonView.map({
    Key? key,
    required Map<String, dynamic> map,
  }) {
    return JsonView(key: key, json: map.toString()); // Demo
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.faColors.surface.standard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.faColors.divider.subtle,
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: TextFormField(
              initialValue: json,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              readOnly: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 52, 12),
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Courier',
                color: context.faColors.ink.sourceCode,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: FloatingCopyButton(
              getText: () {
                return json;
              },
            ),
          ),
        ],
      ),
    );
  }
}
