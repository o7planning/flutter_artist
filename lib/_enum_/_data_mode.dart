part of '../flutter_artist.dart';

enum DataMode {
  real,
  fake;
}

enum QueryType {
  realQuery,
  emptyQuery;
}

extension QueryTypeE on QueryType {
  DataMode toDataMode() {
    switch (this) {
      case QueryType.realQuery:
        return DataMode.real;
      case QueryType.emptyQuery:
        return DataMode.fake;
    }
  }
}
