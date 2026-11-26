import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter/services.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/__utils.dart';
import '../utils/_debug.dart';
import '../widgets/_html_info_view.dart';

/// A generalized inspector dialog that accepts any [DataDebugable] target object,
/// displays its root class name fixed at the top, and presents its debug key-value pairs
/// in a scrollable list underneath or safely handles errors and empty states using [HtmlInfoView].
class DataDebugDialog extends StatelessWidget {
  final String title;
  final DataDebugable? targetObject;

  const DataDebugDialog({
    required this.title,
    required this.targetObject,
    super.key,
  });

  /// Opens the debug dialog to inspect runtime data fields and values for a given target.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required DataDebugable? targetObject,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => DataDebugDialog(
        title: title,
        targetObject: targetObject,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedTitle = title.isEmpty ? "Data Debug Inspector" : title;

    final String className =
        targetObject != null ? getClassName(targetObject!) : "Null Object";

    // Safely evaluate toDebugMap() with exception handling
    Map<String, dynamic> debugMap = {};
    Object? caughtException;

    if (targetObject == null) {
      debugMap = {"info": "Target object is null"};
    } else {
      try {
        debugMap = targetObject!.toDebugMap();
      } catch (e) {
        caughtException = e;
      }
    }

    return FaDialog(
      titleText: resolvedTitle,
      iconData: Icons.bug_report_rounded,
      preferredContentWidth: 540,
      preferredContentHeight: 420,
      contentPadding: const EdgeInsets.all(8),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===================================================================
          // FIXED HEADER: Root Class Info
          // ===================================================================
          Row(
            children: [
              const Text(
                "Class name: ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.blueGrey,
                ),
              ),
              Expanded(
                child: Text(
                  className,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // ===================================================================
          // SCROLLABLE BODY OR HTML INFO VIEW FALLBACK
          // ===================================================================
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: _buildBodyContent(
                context,
                className: className,
                debugMap: debugMap,
                exception: caughtException,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the inner body content handling exceptions, empty maps, and normal data rows.
  Widget _buildBodyContent(
    BuildContext context, {
    required String className,
    required Map<String, dynamic> debugMap,
    required Object? exception,
  }) {
    // Case 1: An exception was thrown during toDebugMap() execution
    if (exception != null) {
      return Center(
        child: SingleChildScrollView(
          child: HtmlInfoView(
            infoAsHtml:
                "Error in <b>$className.toDebugMap()</b>: <i>$exception</i>",
          ),
        ),
      );
    }

    // Case 2: Returned map is empty
    if (debugMap.isEmpty) {
      // Check if class name starts with 'Empty' (e.g., EmptyProzessInitData)
      if (className.startsWith("Empty")) {
        return const Center(
          child: HtmlInfoView(
            infoAsHtml: "<b>No Data</b>",
          ),
        );
      } else {
        return Center(
          child: SingleChildScrollView(
            child: HtmlInfoView(
              infoAsHtml:
                  "<b>$className.toDebugMap()</b> returned an empty map. You need to implement it correctly.",
            ),
          ),
        );
      }
    }

    // Case 3: Normal data map available - Render aligned key-value list
    const TextStyle keyTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
      color: Colors.blueGrey,
    );

    double maxKeyWidth = 80.0;
    for (String key in debugMap.keys) {
      final Size size = TextSizeUtils.calculateTextSize(
        text: key,
        style: keyTextStyle,
      );
      if (size.width > maxKeyWidth) {
        maxKeyWidth = size.width;
      }
    }
    final double leftColumnWidth = maxKeyWidth + 16.0;

    return ListView.separated(
      shrinkWrap: true,
      itemCount: debugMap.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = debugMap.entries.elementAt(index);
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: leftColumnWidth,
                child: Text(
                  entry.key,
                  style: keyTextStyle,
                ),
              ),
              const Text(" : ", style: TextStyle(color: Colors.grey)),
              Expanded(
                child: Text(
                  debugObj(entry.value),
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 13,
                    color: entry.value == null ? Colors.grey : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
