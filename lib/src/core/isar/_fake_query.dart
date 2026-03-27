import '_fake_collection.dart';

class FakeQuery<T> {
  List<T> _data;
  final FakeCollection<T> _collection; // Thêm reference tới collection

  FakeQuery(this._data, this._collection);

  FakeQuery<T> where(bool Function(T) test) {
    _data = _data.where(test).toList();
    return this;
  }

  FakeQuery<T> sortBy(Comparable Function(T) keySelector, {bool desc = false}) {
    _data.sort((a, b) {
      final ka = keySelector(a);
      final kb = keySelector(b);
      return desc ? kb.compareTo(ka) : ka.compareTo(kb);
    });
    return this;
  }

  Future<T?> findFirst() async => _data.isEmpty ? null : _data.first;

  Future<List<T>> findAll() async => _data;

  /// Thực hiện xóa tất cả các item khớp với query
  Future<int> deleteAll() async {
    final count = _data.length;
    for (final item in _data) {
      // Gọi ngược lại hàm delete của collection thông qua ID
      await _collection.delete((item as dynamic).id);
    }
    return count;
  }
}
