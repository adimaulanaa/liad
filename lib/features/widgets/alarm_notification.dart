import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
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
  String dateTime = '';
  String formattedDate = '';
  String formattedTime = '';
  String myName = '';
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    notification = widget.alarmSettings.notificationSettings;
    formattedDate = DateFormat('dd MMMM').format(now);
    String day = getDayName();
    dateTime = '$day, $formattedDate';
    formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    getNames();

    // Menambahkan logika untuk otomatis mematikan alarm setelah 30 detik
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(MediaRes.alarmBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.2),
                Text(
                  dateTime,
                  style: blackTextstyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  formattedTime,
                  style: blackTextstyle.copyWith(
                    fontSize: 80,
                    fontWeight: bold,
                  ),
                ),
                Expanded(child: Container()),
                Flexible(
                  child: Text(
                    "It's Time $myName !",
                    style: whiteTextstyle.copyWith(
                      fontSize: 20,
                      fontWeight: bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "Don't forget your pray.",
                  style: whiteTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    stop();
                  },
                  child: Container(
                    width: size.width * 0.25,
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.bgColor,
                    ),
                    child: Center(
                      child: Text(
                        'STOP',
                        style: blackTextstyle.copyWith(
                          fontSize: 19,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: () {
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
                      // ignore: use_build_context_synchronously
                    ).then((_) => Navigator.pop(context));
                  },
                  child: Container(
                    width: size.width * 0.16,
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.bgColor,
                    ),
                    child: Center(
                      child: Text(
                        'Snooze',
                        style: blackTextstyle.copyWith(
                          fontSize: 12,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getNames() async {
    myName = await getName();
  }

  void stop() {
    //stop alarm
    setValueSchadule(widget.alarmSettings.id, true);
    Alarm.stop(widget.alarmSettings.id)
        // ignore: use_build_context_synchronously
        .then((_) => Navigator.pop(context));
  }
}
