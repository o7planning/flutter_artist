part of '../../_fa_core.dart';

var _encoder = const JsonEncoder.withIndent("   ");

String toBeautifulJson(dynamic data) {
  if (data == null) {
    return "";
  }
  try {
    if (data is Map) {
      return _encoder.convert(data);
    }
    if (data is List) {
      return _encoder.convert(data);
    }
    if (data is String) {
      dynamic obj = jsonDecode(data);
      return _encoder.convert(obj);
    }
  } catch (e) {}
  return data.toString();
}
