import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../error/_form_error_info.dart';
import '../../../icon/icon_constants.dart';
import '../../../widgets/_custom_app_container.dart';
import '../../../widgets/_small_text_button.dart';
import '../../dialog/_error_viewer_dialog.dart';

class FormErrorPropView extends StatelessWidget {
  final bool formInitialDataReady;
  final FormErrorInfo formErrorInfo;

  const FormErrorPropView({
    super.key,
    required this.formInitialDataReady,
    required this.formErrorInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!formInitialDataReady)
            IconLabelText(
              icon: Icon(
                FaIconConstants.formErrorDisabledIconData,
                size: 16,
                color: Colors.red,
              ),
              text: "Form is disabled due to data initialization error.",
              textStyle: TextStyle(fontSize: 13, color: Colors.red),
              suffixIcon: SmallTextButton(
                onPressed: () {
                  _showErrorDetails(context);
                },
                child: Text(
                  "View Details",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          if (!formInitialDataReady) SizedBox(height: 5),
          IconLabelText(
            label: "Error method: ",
            text: formErrorInfo.methodName,
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            textStyle: TextStyle(fontSize: 13, color: Colors.red),
          ),
          SizedBox(height: 5),
          IconLabelText(
            label: "Error message: ",
            text: formErrorInfo.errorMessage,
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            textStyle: TextStyle(fontSize: 13, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showErrorDetails(BuildContext context) {
    ErrorInfo? errorInfo = formErrorInfo.toErrorInfo();
    //
    ErrorViewerDialog.showErrorViewerDialog(
      context: context,
      title: "Error",
      errorInfo: errorInfo,
    );
  }
}
