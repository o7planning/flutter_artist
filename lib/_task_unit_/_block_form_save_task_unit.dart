part of '../flutter_artist.dart';

class _SaveFormSaveTaskUnit extends _TaskUnit {
  _XBlockForm xBlockForm;

  _SaveFormSaveTaskUnit({
    required this.xBlockForm,
  });

  @override
  Shelf get shelf => xBlockForm.blockForm.block.shelf;

  @override
  String getObjectName() {
    return xBlockForm.blockForm.block.name;
  }
}
