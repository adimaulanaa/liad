import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading.dart';
import 'package:liad/features/data/dashboard_provider.dart';
import 'package:liad/features/model/schedule_sholat_model.dart';
import 'package:liad/features/presentation/list_schedule_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  bool isData = false;
  bool isSholatFinish = false;
  late Timer _timer;
  late DateTime _currentTime;
  String formattedDate = '-';
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
  ScheduleSholatModel model = ScheduleSholatModel();

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now(); // Inisialisasi waktu saat ini
    day = getDayName();
    _startTimer(); // Memulai Timer
    _loadData();
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
    location = await provider.loadLocation();
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgScreen,
      appBar: AppBar(
        backgroundColor: AppColors.bgScreen,
        title: Text(
          'Hi, ${StringResources.myName}',
          style: blackTextstyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
      ),
      body: isLoading
          ? const UIDialogLoading(text: StringResources.loading)
          : bodyData(context, size),
    );
  }

  SingleChildScrollView bodyData(BuildContext context, Size size) {
    formattedDate = DateFormat('dd MMMM yyyy').format(now);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            _contentSholat(),
            SizedBox(height: size.height * 0.06),
            ListScheduleWidget(
              type: "Fajr",
              time: model.fajr.toString(),
              checkBox: isFajr,
              onTapCheckBox: () {
                updateFinish(1, isFajr.value);
              },
            ),
            ListScheduleWidget(
              type: "Dhuhr",
              time: model.dhuhr.toString(),
              checkBox: isDhuhr,
              onTapCheckBox: () {
                updateFinish(2, isDhuhr.value);
              },
            ),
            ListScheduleWidget(
              type: "Asr",
              time: model.asr.toString(),
              checkBox: isAsr,
              onTapCheckBox: () {
                updateFinish(3, isAsr.value);
              },
            ),
            ListScheduleWidget(
              type: "Maghrib",
              time: model.maghrib.toString(),
              checkBox: isMaghrib,
              onTapCheckBox: () {
                updateFinish(4, isMaghrib.value);
              },
            ),
            ListScheduleWidget(
              type: "Isha",
              time: model.isha.toString(),
              checkBox: isIsha,
              onTapCheckBox: () {
                updateFinish(5, isIsha.value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _contentSholat() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: whiteTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: medium,
                ),
              ),
              Flexible(
                child: Text(
                  location,
                  style: whiteTextstyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: whiteTextstyle.copyWith(
                  fontSize: 17,
                  fontWeight: bold,
                ),
              ),
              Text(
                _formatTime(_currentTime),
                style: whiteTextstyle.copyWith(
                  fontSize: 17,
                  fontWeight: bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          isData
              ? Column(
                  children: [
                    Text(
                      nameSholat,
                      style: whiteTextstyle.copyWith(
                        fontSize: 23,
                        fontWeight: medium,
                      ),
                    ),
                    Text(
                      scheduleSholat,
                      style: whiteTextstyle.copyWith(
                        fontSize: 40,
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _getRemainingTime(scheduleSholat),
                      style: whiteTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                )
              : _noData(),
        ],
      ),
    );
  }

  Center _noData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: isSholatFinish
            ? Text(
                'Jadwal sholat hari ini \nsudah selesai',
                textAlign: TextAlign.center,
                style: whiteTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              )
            : Text(
                'Data tidak tersedia',
                style: whiteTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
      ),
    );
  }

  /// Memulai Timer untuk memperbarui waktu setiap detik
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  /// Format waktu ke bentuk yang lebih user-friendly
  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  /// Menghitung waktu yang tersisa menuju waktu sholat
  String _getRemainingTime(String prayerTime) {
    // Ambil jam dan menit dari waktu sholat, misalnya "12:30"
    List<String> prayerTimeParts = prayerTime.split(":");
    int prayerHour = int.parse(prayerTimeParts[0]);
    int prayerMinute = int.parse(prayerTimeParts[1]);

    // Waktu sholat dalam objek DateTime
    DateTime prayerDateTime = DateTime(
      _currentTime.year,
      _currentTime.month,
      _currentTime.day,
      prayerHour,
      prayerMinute,
    );

    // Jika waktu sholat sudah lewat, tambahkan sehari
    if (prayerDateTime.isBefore(_currentTime)) {
      prayerDateTime = prayerDateTime.add(const Duration(days: 1));
    }

    // Menghitung selisih waktu
    Duration remainingDuration = prayerDateTime.difference(_currentTime);

    // Mengonversi durasi menjadi format jam:menit:detik
    String remainingTime = _formatDuration(remainingDuration);
    return "Next Prayer in : $remainingTime";
  }

  /// Format durasi menjadi format jam:menit:detik
  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void updateFinish(int type, bool value) async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    await provider.updateScheduleSholat(type, value);
  }

  String getDayName() {
    switch (now.weekday) {
      case 1:
        return "Senin";
      case 2:
        return "Selasa";
      case 3:
        return "Rabu";
      case 4:
        return "Kamis";
      case 5:
        return "Jumat";
      case 6:
        return "Sabtu";
      case 7:
        return "Minggu";
      default:
        return "Tidak diketahui";
    }
  }

  String getAmPm(String time) {
    // Format waktu ke DateTime
    final dateFormat = DateFormat("HH:mm");
    final dateTime = dateFormat.parse(time);
    String check = dateTime.hour >= 12 ? "PM" : "AM";
    String res = '$time $check';

    // Cek AM atau PM
    return res;
  }
}
