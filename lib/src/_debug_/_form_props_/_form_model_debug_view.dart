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
          SizedBox(height: 5),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: actionable.yes,
            dense: true,
            checkboxScaleFactor: actionable.yes ? 1.0 : 1.5,
            visualDensity: VisualDensity(vertical: -3, horizontal: -3),
            contentPadding: EdgeInsets.all(0),
            title: Text("Form Enabled?"),
            subtitle: actionable.yes
                ? null
                : Text(
                    actionable.message ?? " - ",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                    ),
                  ),
            onChanged: null,
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
