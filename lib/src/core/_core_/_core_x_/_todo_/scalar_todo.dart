part of '../../core.dart';

sealed class ScalarTodo<
    ID extends Comparable, //
    VALUE extends Identifiable<ID>> {
  //
}

final class ScalarTodoQuery<
    ID extends Comparable, //
    VALUE extends Identifiable<ID>> extends ScalarTodo<ID, VALUE> {
  //
}

final class ScalarTodoSetCurrentItem<
    ID extends Comparable, //
    VALUE extends Identifiable<ID>> extends ScalarTodo<ID, VALUE> {
  //
}

final class ScalarTodoDone<
    ID extends Comparable, //
    VALUE extends Identifiable<ID>> extends ScalarTodo<ID, VALUE> {
  //
}
