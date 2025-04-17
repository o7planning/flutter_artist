part of '../../flutter_artist.dart';

class _FormPropView extends StatelessWidget {
  final Prop prop;

  const _FormPropView({
    required this.prop,
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
          _IconLabelText(
            icon: Icon(
              prop is SimpleProp
                  ? _simplePropOrCriterionIconData
                  : _optPropOrCriterionIconData,
              size: 18,
            ),
            label: prop is SimpleProp ? 'Prop Name: ' : 'Multi Opt Prop Name: ',
            text: prop.propName,
          ),
          if (prop is MultiOptProp) SizedBox(height: 5),
          if (prop is MultiOptProp)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  value: (prop as MultiOptProp).singleSelection,
                  onChanged: null,
                  groupValue: true,
                ),
                Text(
                  "Single Selection",
                  style: TextStyle(
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5),
                Radio(
                  value: !(prop as MultiOptProp).singleSelection,
                  onChanged: null,
                  groupValue: true,
                ),
                Expanded(child:
                Text(
                  "Multi Selection",
                  style: TextStyle(
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),),
              ],
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
              headerSubtitle: _headerSubtitle(prop._initialValue),
              content: _PropValueView(value: prop._initialValue),
            ),
            _SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Current Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(prop._currentValue),
              content: _PropValueView(value: prop._currentValue),
            ),
            if (prop is MultiOptProp)
              _SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Initial XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(prop._initialXData),
                content: _PropXDataView(xData: prop._initialXData),
              ),
            if (prop is MultiOptProp)
              _SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Current XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(prop._currentXData),
                content: _PropXDataView(xData: prop._currentXData),
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
