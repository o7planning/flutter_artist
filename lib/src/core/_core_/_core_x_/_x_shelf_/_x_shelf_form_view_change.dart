part of '../../core.dart';

class _XShelfFormViewChange extends XShelf {
  _XShelfFormViewChange({
    required BlockFormModel formModel,
  }) : super(
          xShelfType: XShelfType.formViewChange,
          shelf: formModel.shelf,
        ) {
    //
  }
}
