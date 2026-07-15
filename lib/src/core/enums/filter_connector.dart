enum FilterConnector {
  and("AND"),
  or("OR");

  final String text;

  const FilterConnector(this.text);
}
