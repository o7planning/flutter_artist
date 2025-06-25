part of '../../../flutter_artist.dart';

class _FormModelDebugView extends StatelessWidget {
  final FormModel formModel;

  const _FormModelDebugView({
    required this.formModel,
  });

  @override
  Widget build(BuildContext context) {
    Actionable actionable = formModel.block._isEnableFormToModify();
    //
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
              color:
                  formModel.formInitialDataReady ? Colors.indigo : Colors.red,
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
                color: Colors.red,
                size: 40,
              ),
              title: Text(
                "Form Disabled.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Form is disabled due to data initialization error.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
            ),
          if (formModel.formDataState == DataState.error) SizedBox(height: 10),
          if (formModel.formDataState == DataState.error)
            Text(
              "Error Message: ${formModel.errorMessage ?? ' - '}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
