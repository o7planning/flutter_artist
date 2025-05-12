part of '../../flutter_artist.dart';

abstract class FormView<FORM_MODEL extends FormModel> extends StatelessWidget {
  final FORM_MODEL formModel;

  const FormView({
    required this.formModel,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _FormViewBuilder(
      ownerClassInstance: this,
      description: '',
      formModel: formModel,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
