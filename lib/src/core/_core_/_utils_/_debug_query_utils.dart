part of '../core.dart';

class _DebugQueryUtils {
  static String toDebugString({
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_FormModelOpt> forceQueryFormModelOpts,
  }) {
    String info = "";
    if (forceQueryScalarOpts.isNotEmpty) {
      String s = forceQueryScalarOpts
          .map((opt) => getClassName(opt.scalar))
          .join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    if (forceQueryBlockOpts.isNotEmpty) {
      String s =
          forceQueryBlockOpts.map((opt) => getClassName(opt.block)).join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    if (forceQueryFormModelOpts.isNotEmpty) {
      String s = forceQueryFormModelOpts
          .map((opt) => getClassName(opt.formModel))
          .join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    return info;
  }
}
