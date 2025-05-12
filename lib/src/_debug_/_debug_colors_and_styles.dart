part of '../../flutter_artist.dart';

const List<Color> _filterColors = [
  Colors.lightBlueAccent, //
  Colors.indigo, //
  Colors.greenAccent, //
  Colors.brown, //
  Colors.purple, //
  Colors.teal, //
  Colors.purpleAccent, //
  Colors.black54, //
  Colors.deepOrangeAccent, //
  Colors.amber, //
  Colors.deepOrangeAccent, //
];

final Color _rootGraphBoxBgColor = Colors.indigo.withAlpha(60);
final Color _selectedGraphBoxBgColor = Colors.green.withAlpha(20);
const Color _activeGraphBoxBgColor = Colors.white;
final Color? _inactiveGraphBoxBgColor = Colors.grey[200];

final Color _shadowGraphBoxColor = Colors.grey.withOpacity(0.5);

final BoxShadow _graphBoxShadow = BoxShadow(
  color: _shadowGraphBoxColor,
  spreadRadius: 1,
  blurRadius: 5,
  offset: const Offset(0, 3),
);

const double _graphBoxImageWidth = 32;
const double _graphBoxImageHeight = 24;

const double _graphBoxFontSizeRootBox = 13;

const double _debugFontSize = 13;

const double _graphBoxFontSizeChildBox = 11.5;

const double _blockOrScalaInfoFontSize = 12;

const Color _graphBoxDataStateReadyBgColor = Colors.green;
const Color _graphBoxDataStatePendingBgColor = Colors.black54;
const Color _graphBoxDataStateErrorBgColor = Colors.deepOrangeAccent;
const Color _graphBoxDataStateNoneBgColor = Colors.white;

const Color _graphBoxTextColor = Colors.white;
final Color _graphBoxHighlighFilterColor = Colors.amberAccent.withAlpha(80);

//

final TextStyle _listenerTextStyle = TextStyle(
  color: _listenerTextColor,
  fontWeight: FontWeight.bold,
);

final TextStyle _eventSourceTextStyle = TextStyle(
  color: _eventSourceTextColor,
  fontWeight: FontWeight.bold,
);
