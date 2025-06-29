part of '../../../flutter_artist.dart';

class _FormModelDebugView extends StatelessWidget {
  final FormModel formModel;

  const _FormModelDebugView({
    required this.formModel,
  });

  @override
  Widget build(BuildContext context) {
    return _CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formModel._classDefinition),
          Divider(),
          IconLabelText(
            label: "Form Mode: ",
            text: formModel.formMode.toString(),
          ),
          SizedBox(height: 5),
          IconLabelText(
            label: "Form Data State: ",
            text: formModel.formDataState.toString(),
          ),
          SizedBox(height: 5),
          IconLabelText(
            label: "Initial Form Data Ready?: ",
            text: "",
            suffixIcon: Icon(
              formModel.formInitialDataReady
                  ? _formInitialDataReadyTrueIconData
                  : _formInitialDataReadyFalseIconData,
              color: formModel.formInitialDataReady //
                  ? Colors.indigo
                  : Colors.red,
              size: 20,
            ),
          ),
          if (formModel.formDataState == DataState.error &&
              !formModel.formInitialDataReady)
            SizedBox(height: 5),
          if (formModel.formDataState == DataState.error &&
              !formModel.formInitialDataReady)
            ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -3, horizontal: -3),
              contentPadding: EdgeInsets.all(0),
              leading: Icon(
                _formErrorDisabledIconData2,
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
                suffixIcon: _SmallTextButton(
                  onPressed: () {
                    _showErrorDetails();
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
          if (formModel.formDataState == DataState.error &&
              formModel.formErrorInfo != null)
            SizedBox(height: 10),
          if (formModel.formDataState == DataState.error &&
              formModel.formErrorInfo != null)
            IconLabelText(
              label: "Error Method: ",
              text: formModel.formErrorInfo!.methodName,
              textStyle: TextStyle(
                fontSize: 13,
                color: Colors.red,
              ),
            ),
          if (formModel.formDataState == DataState.error &&
              formModel.formErrorInfo != null)
            SizedBox(height: 10),
          if (formModel.formDataState == DataState.error &&
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

  void _showErrorDetails() {
    //
  }
}
