part of '../../_fa_core.dart';

class _FormErrorPropView extends StatelessWidget {
  final bool formInitialDataReady;
  final FormErrorInfo formErrorInfo;

  const _FormErrorPropView({
    required this.formInitialDataReady,
    required this.formErrorInfo,
  });

  @override
  Widget build(BuildContext context) {
    return _CustomAppContainer(
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
              suffixIcon: _SmallTextButton(
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
    _showErrorViewerDialog(
        context: context, title: "Error", errorInfo: errorInfo);
  }
}
