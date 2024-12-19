import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:liad/features/widgets/widget_dash.dart';

// ignore: must_be_immutable
class AlarmNotificationScreen extends StatefulWidget {
  AlarmSettings alarmSettings;
  AlarmNotificationScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  NotificationSettings? notification;

  @override
  void initState() {
    super.initState();
    notification = widget.alarmSettings.notificationSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Alram is ringing......."),
          Text(notification!.title),
          Text(notification!.body),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    //skip alarm for next time
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: widget.alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child: const Text("Snooze")),
              ElevatedButton(
                  onPressed: () {
                    //stop alarm
                    setValueSchadule(widget.alarmSettings.id, true);
                    Alarm.stop(widget.alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },
                  child: const Text("Stop")),
            ],
          )
        ],
      ),
    );
  }
}
