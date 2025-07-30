import 'package:graphview/GraphView.dart';

class CustomBuchheimWalkerConfiguration extends BuchheimWalkerConfiguration {
  @override
  int siblingSeparation = 40;

  @override
  int levelSeparation = 40;

  @override
  int subtreeSeparation = 40;

  @override
  int getSiblingSeparation() {
    return siblingSeparation;
  }

  @override
  int getLevelSeparation() {
    return levelSeparation;
  }

  @override
  int getSubtreeSeparation() {
    return subtreeSeparation;
  }
}

class GalerryBuchheimWalkerConfiguration extends BuchheimWalkerConfiguration {
  @override
  int siblingSeparation = 20;

  @override
  int levelSeparation = 40;

  @override
  int subtreeSeparation = 20;

  @override
  int getSiblingSeparation() {
    return siblingSeparation;
  }

  @override
  int getLevelSeparation() {
    return levelSeparation;
  }

  @override
  int getSubtreeSeparation() {
    return subtreeSeparation;
  }
}
