import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_data_state.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../../core/widgets/_small_text_button.dart';
import '../dialog/_error_viewer_dialog.dart';
import '../widgets/_html_info_view.dart';

class FormModelDebugView extends StatelessWidget {
  final FormModel formModel;

  const FormModelDebugView({
    super.key,
    required this.formModel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlInfoView(
            padding: EdgeInsets.symmetric(vertical: 5),
            infoAsHtml:
                "<b>${getClassNameWithoutGenerics(formModel)}</b><i>${formModel.debugClassParametersDefinition}</i>",
            style: TextStyle(fontSize: 13),
          ),
          Divider(),
          IconLabelText(
            label: "Form Mode: ",
            text: formModel.formMode.toString(),
          ),
          SizedBox(height: 5),
          IconLabelText(
            label: "Form Data State: ",
            text: formModel.dataState.toString(),
          ),
          SizedBox(height: 5),
          IconLabelText(
            label: "FormModel.formInitialDataReady?: ",
            text: "",
            suffixIcon: Icon(
              formModel.formInitialDataReady
                  ? FaIconConstants.formInitialDataReadyTrueIconData
                  : FaIconConstants.formInitialDataReadyFalseIconData,
              color: formModel.formInitialDataReady //
                  ? Colors.indigo
                  : Colors.red,
              size: 20,
            ),
          ),
          if (formModel.dataState == DataState.error &&
              !formModel.formInitialDataReady)
            SizedBox(height: 5),
          if (formModel.dataState == DataState.error &&
              !formModel.formInitialDataReady)
            ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -3, horizontal: -3),
              contentPadding: EdgeInsets.all(0),
              leading: Icon(
                FaIconConstants.formErrorDisabledIconData2,
                color: Colors.deepOrangeAccent,
                size: 40,
              ),
              title: Text(
                "Form Disabled.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: IconLabelText(
                text: "Form is disabled due to data initialization error.",
                textStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                ),
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
            ),
          if (formModel.dataState == DataState.error &&
              formModel.formErrorInfo != null)
            SizedBox(height: 10),
          if (formModel.dataState == DataState.error &&
              formModel.formErrorInfo != null)
            IconLabelText(
              label: "Error Method: ",
              text: formModel.formErrorInfo!.methodName,
              textStyle: TextStyle(
                fontSize: 13,
                color: Colors.red,
              ),
            ),
          if (formModel.dataState == DataState.error &&
              formModel.formErrorInfo != null)
            SizedBox(height: 10),
          if (formModel.dataState == DataState.error &&
              formModel.formErrorInfo != null)
            IconLabelText(
              label: "Error Message: ",
              text: formModel.formErrorInfo!.errorMessage,
              textStyle: TextStyle(
                fontSize: 13,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  void _showErrorDetails(BuildContext context) {
    ErrorInfo? errorInfo = formModel.formErrorInfo?.toErrorInfo();
    if (errorInfo != null) {
      ErrorViewerDialog.open(
        context: context,
        title: "Error",
        errorInfo: errorInfo,
      );
    }
  }
}
