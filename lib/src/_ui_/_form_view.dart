part of '../../flutter_artist.dart';

abstract class FormView<FORM_MODEL extends FormModel> extends StatelessWidget {
  final FORM_MODEL formModel;
  final bool showIconIfError;

  const FormView({
    required this.formModel,
    this.showIconIfError = true,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _FormViewBuilder(
      ownerClassInstance: this,
      description: '',
      formModel: formModel,
      showIconIfError: showIconIfError,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
