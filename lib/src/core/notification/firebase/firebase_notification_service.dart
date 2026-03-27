import 'dart:async';

import 'package:flutter_artist_core/flutter_artist_core.dart';

/// Implementation of Firebase notification service for FlutterArtist.
class FirebaseNotificationService
    extends FlutterArtistNotificationService<FirebaseNotificationAdapter> {
  FirebaseNotificationService(super.adapter);

  @override
  Future<void> initialize() async {
    print("NOTIFICATION Firebase: initialize -1");
    // 1. Initialize Firebase App (Requirement from Firebase Core)
    // Note: This requires DefaultFirebaseOptions from flutterfire_cli
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // 2. Request User Permissions via adapter
    // The adapter should handle the specific FirebaseMessaging.instance logic
    await _setupPermissions();
    print("NOTIFICATION Firebase: initialize -2");

    // 3. Register foreground message listener
    adapter.onNotificationReceived.listen((notification) {
      _handleForegroundArrival(notification);
    });

    print("NOTIFICATION Firebase: initialize -3");

    // 4. Sync device token for backend targeting
    final token = await adapter.getDeviceToken();
    if (token != null) {
      _logDebug("FCM Token: $token");
      // Logic to sync token to backend can be placed here
    }

    print("NOTIFICATION Firebase: initialize -4: $token");
  }

  Future<void> _setupPermissions() async {
    // Adapter handles the complexity of OS-specific requests
  }

  void _handleForegroundArrival(INotification notification) {
    // Logic to update badges or show in-app banners
    adapter.handleNotificationClick(notification);
  }

  @override
  void dispose() {
    // Cleanup any custom streams if necessary
  }

  void _logDebug(String message) {
    print("[FirebaseService] $message");
  }
}
