import 'package:hive/hive.dart';

import '_fake_query.dart';

class FakeCollection<T> {
  final Box<T> box;
  int _autoIncrementId = 0;

  FakeCollection(this.box) {
    if (box.isNotEmpty && box.keys.first is int) {
      _autoIncrementId =
          (box.keys.cast<int>().reduce((a, b) => a > b ? a : b)) + 1;
    }
  }

  // Truyền List data và instance của collection (this) vào FakeQuery
  FakeQuery<T> filter() => FakeQuery<T>(box.values.toList(), this);

  FakeQuery<T> where() => FakeQuery<T>(box.values.toList(), this);

  Future<void> put(T item) async {
    final mirror = item as dynamic;
    if (mirror.id == null || mirror.id == 0) {
      mirror.id = _autoIncrementId++;
    }
    await box.put(mirror.id, item);
    await box.flush();
  }

  Future<void> delete(dynamic id) async => await box.delete(id);

  Future<void> deleteAll(List<dynamic> ids) async => await box.deleteAll(ids);

  // Hàm tạo Index (nếu ông vẫn muốn dùng cho Unique logic)
  void createIndex(String fieldName, dynamic Function(T) getter,
      {bool unique = false}) {
    // Logic xử lý index tương tự như bản trước
  }
}
