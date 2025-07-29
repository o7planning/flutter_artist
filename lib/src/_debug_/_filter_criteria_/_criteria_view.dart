part of '../../_fa_core.dart';

class _FilterCriterionView extends StatelessWidget {
  final Criterion criterion;

  const _FilterCriterionView({
    required this.criterion,
  });

  @override
  Widget build(BuildContext context) {
    return _CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconLabelText(
            icon: Icon(
              criterion is SimpleCriterion
                  ? FaIconConstants.simplePropOrCriterionIconData
                  : FaIconConstants.optPropOrCriterionIconData,
              size: 18,
            ),
            label: criterion is SimpleCriterion
                ? 'Criterion Name: '
                : 'Multi Opt Criterion Name: ',
            text: criterion.criterionName,
          ),
          if (criterion is MultiOptCriterion) SizedBox(height: 5),
          if (criterion is MultiOptCriterion)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Single Selection",
                      child: Radio(
                        value: (criterion as MultiOptCriterion).singleSelection,
                        onChanged: null,
                        groupValue: true,
                      ),
                    ),
                    if (constraints.constrainWidth() > 200)
                      Text(
                        "Single Selection",
                        style: TextStyle(
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    SizedBox(width: 5),
                    Tooltip(
                      message: "Multi Selection",
                      child: Radio(
                        value:
                            !(criterion as MultiOptCriterion).singleSelection,
                        onChanged: null,
                        groupValue: true,
                      ),
                    ),
                    if (constraints.constrainWidth() > 200)
                      Expanded(
                        child: Text(
                          "Multi Selection",
                          style: TextStyle(
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: _buildDetails(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SimpleAccordion(
          children: [
            _SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Initial Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(criterion._initialValue),
              content: _CriterionValueView(value: criterion._initialValue),
            ),
            _SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Current Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(criterion._currentValue),
              content: _CriterionValueView(value: criterion._currentValue),
            ),
            if (criterion is MultiOptCriterion)
              _SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Initial XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(criterion._initialXData),
                content: _XDataView(xData: criterion._initialXData),
              ),
            if (criterion is MultiOptCriterion)
              _SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Current XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(criterion._currentXData),
                content: _XDataView(xData: criterion._currentXData),
              ),
          ],
        ),
      ],
    );
  }

  Text? _headerSubtitle(dynamic value) {
    return value == null
        ? null
        : Text(
            " - ${value!.runtimeType?.toString()}" ?? "",
            style: TextStyle(
              fontSize: 12,
            ),
          );
  }
}
