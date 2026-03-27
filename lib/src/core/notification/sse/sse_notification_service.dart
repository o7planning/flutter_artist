import 'dart:async';

import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../../flutter_artist.dart';

/// Service manages the lifecycle of the SSE connection.
class SSENotificationService
    extends FlutterArtistNotificationService<SSENotificationAdapter> {
  StreamSubscription<INotification>? _subscription;

  SSENotificationService(super.adapter);

  @override
  Future<void> initialize() async {
    print(
        "${getClassName(this)}.initialize() - SSE pipeline is being set up....");

    adapter.connect();

    // 1. Listen to the data stream from the Adapter
    _subscription = adapter.sseStream.listen(
      (INotification summary) {
        print("Receive Notification: $summary");
        // FlutterArtist._notifyNotification(summary);
      },
      onError: (error) {
        print("Notification Error: $error");
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    adapter.closeStream();
    print("${getClassName(this)}.dispose() - Close SSE.");
  }
}
