enum FilterCriterionOperator {
  equalTo("equalTo"),
  notEqualTo("notEqualTo"),
  greaterThan("greaterThan"),
  greaterThanOrEqualTo("greaterThanOrEqualTo"),
  lessThan("lessThan"),
  lessThanOrEqualTo("lessThanOrEqualTo"),
  between("between"),
  contains("contains"),
  containsIgnoreCase("containsIgnoreCase"),
  startsWith("startsWith"),
  startsWithIgnoreCase("startsWithIgnoreCase"),
  endsWith("endsWith"),
  endsWithIgnoreCase("endsWithIgnoreCase"),
  isEmpty("isEmpty"),
  isNull("isNull"),
  isEmptyOrNull("isEmptyOrNull"),
  inCollection("in");

  final String text;

  const FilterCriterionOperator(this.text);
}

enum FilterCriteriaOperator {
  and("and"),
  or("or");

  final String text;

  const FilterCriteriaOperator(this.text);
}
