import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:liad/core/alarm/alarm.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading_page.dart';
import 'package:liad/core/utils/set_alarm_time.dart';
import 'package:liad/core/utils/snackbar_extension.dart';
import 'package:liad/features/data/dashboard_provider.dart';
import 'package:liad/features/model/prays_model.dart';
import 'package:liad/features/model/profile_model.dart';
import 'package:liad/features/model/schedule_sholat_model.dart';
import 'package:liad/features/presentation/list_schedule_widget.dart';
import 'package:liad/features/presentation/notes/notes_screen.dart';
import 'package:liad/features/presentation/profile_screen.dart';
import 'package:liad/features/widgets/alarm_notification.dart';
import 'package:liad/features/widgets/sholat_content_widget.dart';
import 'package:liad/features/widgets/widget_dash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  bool isData = false;
  bool isPeriodeMens = false;
  bool isSholatFinish = false;
  late Timer _timer;
  late DateTime _currentTime;
  String myName = '';
  String _formattedTime = '';
  String formattedDate = '-';
  String formattedTimes = '-';
  DateTime now = DateTime.now();
  String scheduleSholat = '00:00';
  String nameSholat = '-';
  String location = '-';
  String day = '-';
  final ValueNotifier<bool> isFajr = ValueNotifier(false);
  final ValueNotifier<bool> isDhuhr = ValueNotifier(false);
  final ValueNotifier<bool> isAsr = ValueNotifier(false);
  final ValueNotifier<bool> isMaghrib = ValueNotifier(false);
  final ValueNotifier<bool> isIsha = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmFajr = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmDhuhr = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmAsr = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmMaghrib = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmIsha = ValueNotifier(false);
  ScheduleSholatModel model = ScheduleSholatModel();
  PraysModel prays = PraysModel();

  late List<AlarmSettings> alarms;
  late AlarmSettings alarm;
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now(); // Inisialisasi waktu saat ini
    day = getDayName();
    _startTimer(); // Memulai Timer
    _loadData();
    //notifcation permission
    checkAndroidNotificationPermission();
    //schedule alarm permission
    checkAndroidScheduleExactAlarmPermission();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      // Alarm.stop(1);
      // handleActiveAlarmSound(alarmSettings); // Cek status mode suara perangkat saat alarm aktif
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Membatalkan Timer saat widget dihapus
    super.dispose();
  }

  void _loadData() async {
    String date = DateFormat('dd-MM-yyyy').format(now);
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    model = await provider.loadPrayerSchedule(date);
    prays = await provider.loadPrays('');
    location = await provider.loadLocation();
    myName = await getName();
    isPeriodeMens = await getPeriodeMens();
    if (!model.isError) {
      isLoading = false;
      if (model.scheduleTime != '') {
        scheduleSholat = model.scheduleTime;
        isData = true;
      }
      if (model.scheduleName != '') {
        nameSholat = model.scheduleName;
        isData = true;
      }
      isSholatFinish = model.isFinis;
    }
    isFajr.value = await provider.loadScheduleSholat(1);
    isDhuhr.value = await provider.loadScheduleSholat(2);
    isAsr.value = await provider.loadScheduleSholat(3);
    isMaghrib.value = await provider.loadScheduleSholat(4);
    isIsha.value = await provider.loadScheduleSholat(5);
    // initAlarm();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const UIDialogLoading(text: StringResources.loading)
        : Scaffold(
            backgroundColor: AppColors.bgScreen,
            body: bodyData(context, size),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesScreen(),
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              child: SvgPicture.asset(
                MediaRes.listNote,
                fit: BoxFit.contain,
                width: 30,
                // ignore: deprecated_member_use
                color: AppColors.bgColor,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
  }

  SafeArea bodyData(BuildContext context, Size size) {
    formattedDate = DateFormat('dd MMMM yyyy').format(now);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, $myName',
                    style: blackTextstyle.copyWith(
                      fontSize: 20,
                      fontWeight: bold,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: InkWell(
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            isLoading = false;
                            updatePeriode();
                          },
                          child: SvgPicture.asset(
                            MediaRes.periodeMens,
                            fit: BoxFit.contain,
                            width: 50,
                            // ignore: deprecated_member_use
                            color: isPeriodeMens
                                ? AppColors.bgRed
                                : AppColors.bgBlack,
                          ),
                        ),
                      ),
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          MediaRes.settings,
                          fit: BoxFit.contain,
                          width: 35,
                          // ignore: deprecated_member_use
                          color: AppColors.bgBlack,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: size.height * 0.02),
              SholatContentWidget(
                day: day,
                location: location,
                formattedDate: formattedDate,
                formattedTime: _formattedTime,
                isData: isData,
                nameSholat: nameSholat,
                scheduleSholat: scheduleSholat,
                currentTime: _currentTime,
                isSholatFinish: isSholatFinish,
              ),
              SizedBox(height: size.height * 0.02),
              ListScheduleWidget(
                alarm: isAlarmFajr,
                type: "Fajr",
                time: model.fajr.toString(),
                isMens: isPeriodeMens,
                checkBox: isFajr,
                onTapCheckBox: () {
                  updateFinish(1, isFajr.value, model.fajr.toString());
                },
                onTapAlarm: () {
                  setDataPray(
                    context,
                    1,
                    isAlarmFajr.value,
                    model.fajr.toString(),
                  );
                  changeTypePray(1, model.fajr.toString());
                },
              ),
              ListScheduleWidget(
                alarm: isAlarmDhuhr,
                type: "Dhuhr",
                time: model.dhuhr.toString(),
                isMens: isPeriodeMens,
                checkBox: isDhuhr,
                onTapCheckBox: () {
                  updateFinish(2, isDhuhr.value, model.dhuhr.toString());
                },
                onTapAlarm: () {
                  setDataPray(
                    context,
                    2,
                    isAlarmDhuhr.value,
                    model.dhuhr.toString(),
                  );
                  changeTypePray(2, model.dhuhr.toString());
                },
              ),
              ListScheduleWidget(
                alarm: isAlarmAsr,
                type: "Asr",
                time: model.asr.toString(),
                isMens: isPeriodeMens,
                checkBox: isAsr,
                onTapCheckBox: () {
                  updateFinish(3, isAsr.value, model.asr.toString());
                },
                onTapAlarm: () {
                  setDataPray(
                    context,
                    3,
                    isAlarmAsr.value,
                    model.asr.toString(),
                  );
                  changeTypePray(3, model.asr.toString());
                },
              ),
              ListScheduleWidget(
                alarm: isAlarmMaghrib,
                type: "Maghrib",
                time: model.maghrib.toString(),
                isMens: isPeriodeMens,
                checkBox: isMaghrib,
                onTapCheckBox: () {
                  updateFinish(4, isMaghrib.value, model.maghrib.toString());
                },
                onTapAlarm: () {
                  setDataPray(
                    context,
                    4,
                    isAlarmMaghrib.value,
                    model.maghrib.toString(),
                  );
                  changeTypePray(4, model.maghrib.toString());
                },
              ),
              ListScheduleWidget(
                alarm: isAlarmIsha,
                type: "Isha",
                time: model.isha.toString(),
                isMens: isPeriodeMens,
                checkBox: isIsha,
                onTapCheckBox: () {
                  updateFinish(5, isIsha.value, model.isha.toString());
                },
                onTapAlarm: () {
                  setDataPray(
                    context,
                    5,
                    isAlarmIsha.value,
                    model.isha.toString(),
                  );
                  changeTypePray(5, model.isha.toString());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePeriode() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    bool update = false;
    if (!isPeriodeMens) {
      update = true;
    }
    UpdateNameModel response = await provider.updatePeriode(update);
    if (!response.isError) {
      isPeriodeMens = update;
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.error,
        onNavigate: () {}, // bottom close
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        response.error,
        onNavigate: () {}, // bottom close
      );
    }
    isLoading = false;
    setState(() {});
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        _currentTime = DateTime.now();
        String timezone = now.timeZoneName; // Mendapatkan nama timezone
        _formattedTime = '${DateFormat.Hm().format(now.toLocal())} $timezone';
      });
    });
  }

  void updateFinish(int type, bool value, String pray) async {
    if (!isPeriodeMens) {
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      await provider.updateScheduleSholat(type, value, prays.id ?? '', pray);
    }
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            AlarmNotificationScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    try {
      final fetchedAlarms = await Alarm.getAlarms(); // Tunggu hasil Future
      setState(() {
        alarms = fetchedAlarms;
        alarms.sort((a, b) =>
            a.dateTime.isBefore(b.dateTime) ? -1 : 1); // Urutkan dengan benar
      });
    } catch (e) {
      debugPrint('Error loading alarms: $e'); // Tangani error jika ada
    }
  }

  void initAlarm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool init = prefs.getBool('loadAlarm') ?? false;
    if (init) {
      if (model.fajr != '') {
        bool fajr = isTimeBeforeNow(model.fajr.toString());
        if (fajr) {
          isAlarmFajr.value = fajr;
          var alarmDateTime = setDateTimeSchadule(model.fajr.toString());
          setAlarm(1, alarmDateTime, StringResources.titleFajr,
              StringResources.bodyFajr);
        }
      }
      if (model.dhuhr != '') {
        bool dhuhr = isTimeBeforeNow(model.dhuhr.toString());
        if (dhuhr) {
          isAlarmDhuhr.value = dhuhr;
          var alarmDateTime = setDateTimeSchadule(model.dhuhr.toString());
          setAlarm(2, alarmDateTime, StringResources.titleDhuhr,
              StringResources.bodyDhuhr);
        }
      }
      if (model.asr != '') {
        bool asr = isTimeBeforeNow(model.asr.toString());
        if (asr) {
          isAlarmAsr.value = asr;
          var alarmDateTime = setDateTimeSchadule(model.asr.toString());
          setAlarm(3, alarmDateTime, StringResources.titleAsr,
              StringResources.bodyAsr);
        }
      }
      if (model.maghrib != '') {
        bool maghrib = isTimeBeforeNow(model.maghrib.toString());
        if (maghrib) {
          isAlarmMaghrib.value = maghrib;
          var alarmDateTime = setDateTimeSchadule(model.maghrib.toString());
          setAlarm(4, alarmDateTime, StringResources.titleMaghrib,
              StringResources.bodyMaghrib);
        }
      }
      if (model.isha != '') {
        bool isha = isTimeBeforeNow(model.isha.toString());
        if (isha) {
          isAlarmIsha.value = isha;
          var alarmDateTime = setDateTimeSchadule(model.isha.toString());
          setAlarm(5, alarmDateTime, StringResources.titleIsha,
              StringResources.bodyIsha);
        }
      }
      await prefs.setBool('loadAlarm', false);
    }

    loadAlarms();
    setState(() {});
  }

  void changeTypePray(int i, String timer) {
    var alarmDateTime = setDateTimeSchadule(timer);
    if (alarmDateTime.isBefore(now)) {
      return; // Hentikan proses jika waktu tidak valid
    }
    if (i == 1) {
      isAlarmFajr.value = !isAlarmFajr.value;
    } else if (i == 2) {
      isAlarmDhuhr.value = !isAlarmDhuhr.value;
    } else if (i == 3) {
      isAlarmAsr.value = !isAlarmAsr.value;
    } else if (i == 4) {
      isAlarmMaghrib.value = !isAlarmMaghrib.value;
    } else if (i == 5) {
      isAlarmIsha.value = !isAlarmIsha.value;
    }
  }
}
