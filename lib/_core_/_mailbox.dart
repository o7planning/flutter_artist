part of '../flutter_artist.dart';

class Mailbox {
  final Map<String, dynamic> _letters = {};

  void put(String name, dynamic letter) {
    _letters[name] = letter;
  }

  void clear() {
    _letters.clear();
  }
}
