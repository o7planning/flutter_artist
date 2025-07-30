part of '../../_fa_core.dart';

int __visibilityDetectorIdx = 0;

const Uuid _uuid = Uuid();

String _generateVisibilityDetectorId({required String prefix}) {
  __visibilityDetectorIdx++;
  return "$prefix-${_uuid.v1()}-${_uuid.v4()}-$__visibilityDetectorIdx";
}
