enum FilterOperator {
  equalTo("equalTo"),
  notEqualTo("notEqualTo"),
  greaterThan("greaterThan"),
  greaterThanOrEqualTo("greaterThanOrEqualTo"),
  lessThan("lessThan"),
  lessThanOrEqualTo("lessThanOrEqualTo"),
  contains("contains"),
  containsIgnoreCase("containsIgnoreCase"),
  startsWith("startsWith"),
  startsWithIgnoreCase("startsWithIgnoreCase"),
  endsWith("endsWith"),
  endsWithIgnoreCase("endsWithIgnoreCase"),
  isEmpty("isEmpty"),
  isEmptyOrNull("isEmptyOrNull"),
  inCollection("in");

  final String text;

  const FilterOperator(this.text);
}

enum ConditionConnector {
  and("AND"),
  or("OR");

  final String text;

  const ConditionConnector(this.text);
}
