part of '_enums.dart';

enum FilterConnector {
  and("AND"),
  or("OR");

  final String text;

  const FilterConnector(this.text);
}
