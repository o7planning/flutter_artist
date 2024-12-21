part of '../flutter_artist.dart';

class NotificationButtonBuilder extends StatefulWidget {
  final Widget Function(BaseNotificationSummary? notificationSummary) build;

  const NotificationButtonBuilder({
    super.key,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _NotificationButtonBuilderState();
  }
}

class _NotificationButtonBuilderState extends State<NotificationButtonBuilder>
    implements FluNotificationListener {
  BaseNotificationSummary? _notificationSummary;

  @override
  void initState() {
    super.initState();
    FlutterArtist.addNotificationListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    FlutterArtist.removeNotificationListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(_notificationSummary);
  }

  @override
  void handleNotification(BaseNotificationSummary notificationSummary) {
    setState(() {
      _notificationSummary = notificationSummary;
    });
  }
}
