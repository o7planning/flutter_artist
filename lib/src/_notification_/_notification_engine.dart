part of '../../flutter_artist.dart';

class _NotificationEngine {
  final INotificationAdapter? adapter;

  _NotificationEngine(this.adapter);

  String __keyForNotificationSummary(String loggedInUserName) {
    return "$loggedInUserName-short-notification-summary--";
  }

  String __keyForLastFetchNotificationSummary(String loggedInUserName) {
    return "$loggedInUserName-last-fetch-notification-summary--";
  }

  Future<void> start() async {
    print("${getClassName(this)}.start()");
    await __getNotificationSummary();
    Timer.periodic(
      Duration(seconds: FlutterArtist.notificationFetchPeriodInSeconds),
          (Timer timer) {
        __getNotificationSummary();
      },
    );
  }

  Future<void> __getNotificationSummary() async {
    if (adapter == null) {
      print("No NotificationAdapter");
      return;
    }
    ILoggedInUser? user = FlutterArtist.loggedInUser;
    if (user == null) {
      print("No ILoggedInUser");
      return;
    }
    final String loggedInUserName = user.userName;
    //
    final Box<DateTime> hiveBoxDateTime = await _openHiveBoxDateTime();
    final Box<String> notificationSummaryBox = await _openHiveBoxNotification();

    //
    final String lastFetchKey =
    __keyForLastFetchNotificationSummary(loggedInUserName);
    final String notificationSummaryKey =
    __keyForNotificationSummary(loggedInUserName);

    try {
      final DateTime? lastFetch = hiveBoxDateTime.get(lastFetchKey);
      await hiveBoxDateTime.put(lastFetchKey, DateTime.now());
      //
      final String? notificationSummaryJsonLocal =
      notificationSummaryBox.get(notificationSummaryKey);
      INotificationSummary? notificationSummaryLocal;
      try {
        if (notificationSummaryJsonLocal != null) {
          notificationSummaryLocal =
              adapter!.fromJson(notificationSummaryJsonLocal);
        }
      } catch (e, stackTrace) {
        FlutterArtist.errorLogger.addError(
          shelfName: null,
          message: "Invalid Local Notification Summary JSON",
          errorDetails: null,
          stackTrace: stackTrace,
        );
        notificationSummaryBox.delete(notificationSummaryKey);
      }
      //
      if (lastFetch != null) {
        DateTime now = DateTime.now();
        Duration diff = now.difference(lastFetch);
        if (diff.inSeconds <
            FlutterArtist.notificationFetchPeriodInSeconds - 1 &&
            notificationSummaryLocal != null) {
          print("Ignore to fetch notification..");
          FlutterArtist._notifyNotification(notificationSummaryLocal);
          return;
        }
      }
      //
      INotificationSummary? fetchedData;
      try {
        // Fetch from Server:
        ApiResult<INotificationSummary> result =
        await adapter!.callApiGetNotificationSummary();
        if (result.isError()) {
          FlutterArtist.errorLogger.addError(
            shelfName: null,
            message: result.errorMessage!,
            errorDetails: result.errorDetails,
            stackTrace: null,
          );
          return;
        }
        fetchedData = result.data;
      } catch (e, stackTrace) {
        print("Fetch Notification Error: $e");
        print(stackTrace);
        FlutterArtist.errorLogger.addError(
          shelfName: null,
          message: "Fetch Notification Error: $e",
          errorDetails: null,
          stackTrace: stackTrace,
        );
        return;
      }
      //
      if (fetchedData == null) {
        FlutterArtist.errorLogger.addError(
          shelfName: null,
          message: "No Notification Summary Data",
          errorDetails: null,
          stackTrace: null,
        );
        if (notificationSummaryLocal != null) {
          FlutterArtist._notifyNotification(notificationSummaryLocal);
        }
        return;
      }
      //
      FlutterArtist._notifyNotification(fetchedData);
      //
      try {
        String notificationSummaryJSON = adapter!.toJson(fetchedData);
        notificationSummaryBox.put(
          notificationSummaryKey,
          notificationSummaryJSON,
        );
      } catch (e, stackTrace) {
        FlutterArtist.errorLogger.addError(
          shelfName: null,
          message: "Error ${getClassName(adapter)}.toJson()",
          errorDetails: null,
          stackTrace: stackTrace,
        );
      }
    } finally {
      await hiveBoxDateTime.close();
      await notificationSummaryBox.close();
    }
  }
}
