part of '../flutter_artist.dart';

abstract class FormView<BLOCK_FORM extends BlockForm> extends StatelessWidget {
  final BLOCK_FORM blockForm;

  const FormView({
    required this.blockForm,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockFormWidgetBuilder(
      ownerClassInstance: this,
      description: '',
      blockForm: blockForm,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
