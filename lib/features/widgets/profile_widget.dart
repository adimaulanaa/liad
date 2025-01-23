import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/set_alarm_time.dart';
import 'package:liad/features/model/schedule_sholat_model.dart';
import 'package:liad/features/model/weather_model.dart';
import 'package:liad/features/widgets/widget_dash.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> changeName(
  BuildContext context,
  Size size,
  TextEditingController nameController,
  VoidCallback onTap,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgScreen,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: size.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Your Name",
                style: blackTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: StringResources.changeName,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 13.0),
                  hintStyle: transTextstyle.copyWith(
                    fontSize: 15,
                    color: AppColors.bgGrey,
                    fontWeight: semiBold,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.tertiary,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: semiBold,
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  onTap();
                },
                child: Container(
                  // width: size.width * 0.25,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Simpan',
                      style: whiteTextstyle.copyWith(
                        fontSize: 19,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> connectPartner(
  BuildContext context,
  Size size,
  TextEditingController loveController,
  VoidCallback onTap,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgScreen,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: size.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Connect Your Love",
                style: blackTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: loveController,
                decoration: InputDecoration(
                  hintText: StringResources.connectPatner,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 13.0),
                  hintStyle: transTextstyle.copyWith(
                    fontSize: 15,
                    color: AppColors.bgGrey,
                    fontWeight: semiBold,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.tertiary,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: semiBold,
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  onTap();
                },
                child: Container(
                  // width: size.width * 0.25,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Simpan',
                      style: whiteTextstyle.copyWith(
                        fontSize: 19,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> inputWeather(
  BuildContext context,
  Size size,
  TextEditingController weather,
  VoidCallback onTap,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgScreen,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: size.height * 0.31,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Input Id wilayahmu",
                style: blackTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: blackTextstyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                  children: [
                    const TextSpan(
                      text: "Cari id wilayahmu di link: ",
                    ),
                    TextSpan(
                      text: "https://kodewilayah.id/",
                      style: transTextstyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                        color: AppColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _launchUrl,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                StringResources.yourIdLocationNote,
                style: greyTextstyle.copyWith(
                  fontSize: 7,
                  fontWeight: bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: weather,
                decoration: InputDecoration(
                  hintText: StringResources.yourIdLocation,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 13.0),
                  hintStyle: transTextstyle.copyWith(
                    fontSize: 15,
                    color: AppColors.bgGrey,
                    fontWeight: semiBold,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.tertiary,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: semiBold,
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  try {
                    Navigator.pop(context);
                    onTap();
                  } catch (e) {
                    // print('Error saat menyimpan data: $e');
                  }
                },
                child: Container(
                  // width: size.width * 0.25,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Simpan',
                      style: whiteTextstyle.copyWith(
                        fontSize: 19,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _launchUrl() async {
  final Uri url = Uri.parse('https://kodewilayah.id/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

void showSnackbar(BuildContext context, String message, bool isSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: whiteTextstyle.copyWith(
          fontSize: 15,
          fontWeight: light,
        ),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating, // Membuat snackbar muncul melayang
      margin: const EdgeInsets.all(16), // Jarak dari tepi layar
      duration: const Duration(seconds: 3), // Durasi snackbar
    ),
  );
}

void showSnackbars(BuildContext context, String message, int isSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: whiteTextstyle.copyWith(
          fontSize: 13,
          fontWeight: light,
        ),
      ),
      backgroundColor: isSuccess == 1
          ? Colors.green
          : isSuccess == 2
              ? Colors.red
              : Colors.yellow,
      duration: const Duration(seconds: 2),
    ),
  );
}

Padding listPrays(Size size, String title, schadule, prays) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 13,
              height: 13,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            // Garis
            Container(
              width: 2,
              height: 40,
              color: Colors.blue,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Jadwal : ',
                        style: blackTextstyle.copyWith(
                          fontSize: 13,
                          fontWeight: medium,
                        ),
                      ),
                      Text(
                        schadule,
                        style: blackTextstyle.copyWith(
                          fontSize: 13,
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: size.width * 0.1),
                  Row(
                    children: [
                      Text(
                        'Sholat : ',
                        style: blackTextstyle.copyWith(
                          fontSize: 13,
                          fontWeight: medium,
                        ),
                      ),
                      Text(
                        prays,
                        style: blackTextstyle.copyWith(
                          fontSize: 13,
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Column viewWeather(Size size, String text) {
  return Column(
    children: [
      Container(
        width: size.width * 0.28,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Update \nLocation \n$text',
          style: blackTextstyle.copyWith(
            fontSize: 12,
            fontWeight: bold,
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        text,
        style: blackTextstyle.copyWith(
          fontSize: 12,
          fontWeight: bold,
        ),
      ),
    ],
  );
}

Column viewDtWeather(Size size, Cuaca modelWe, String text) {
  return Column(
    children: [
      Container(
        width: size.width * 0.28,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SvgPicture.network(
                  modelWe.image.toString(),
                  width: size.width * 0.1,
                  placeholderBuilder: (BuildContext context) =>
                      const CircularProgressIndicator(),
                ),
                Text(
                  modelWe.weatherDesc ?? '',
                  style: blackTextstyle.copyWith(
                    fontSize: 9,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                '${modelWe.t ?? ''}°C',
                style: blackTextstyle.copyWith(
                  fontSize: 9,
                  fontWeight: bold,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      Text(
        text,
        style: blackTextstyle.copyWith(
          fontSize: 12,
          fontWeight: bold,
        ),
      ),
    ],
  );
}

Future<String> selectDate(BuildContext context, DateTime? selectedDate) async {
  String selected = '';
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(), // Default tanggal awal
    firstDate: DateTime(2000), // Tanggal awal yang diizinkan
    lastDate: DateTime(2100), // Tanggal akhir yang diizinkan
  );
  if (picked != null && picked != selectedDate) {
    selected = DateFormat('dd-MM-yyyy').format(picked);
  }
  return selected;
}

Future<void> initAlarmProfile(
    ScheduleSholatModel model, String selectedDates) async {
  if (model.fajr != '') {
    var alarmDateTime =
        setDateTimeSchaduleSecond(model.fajr.toString(), selectedDates);
    await setAlarm(
      1,
      alarmDateTime,
      StringResources.titleFajr,
      StringResources.bodyFajr,
    );
  }
  if (model.dhuhr != '') {
    var alarmDateTime =
        setDateTimeSchaduleSecond(model.dhuhr.toString(), selectedDates);
    await setAlarm(
      2,
      alarmDateTime,
      StringResources.titleDhuhr,
      StringResources.bodyDhuhr,
    );
  }
  if (model.asr != '') {
    var alarmDateTime =
        setDateTimeSchaduleSecond(model.asr.toString(), selectedDates);
    await setAlarm(
      3,
      alarmDateTime,
      StringResources.titleAsr,
      StringResources.bodyAsr,
    );
  }
  if (model.maghrib != '') {
    var alarmDateTime =
        setDateTimeSchaduleSecond(model.maghrib.toString(), selectedDates);
    await setAlarm(
      4,
      alarmDateTime,
      StringResources.titleMaghrib,
      StringResources.bodyMaghrib,
    );
  }
  if (model.isha != '') {
    var alarmDateTime =
        setDateTimeSchaduleSecond(model.isha.toString(), selectedDates);
    await setAlarm(
      5,
      alarmDateTime,
      StringResources.titleIsha,
      StringResources.bodyIsha,
    );
  }
}

Future<dynamic> changeImage(
  BuildContext context,
  Size size,
  TextEditingController imageController,
  VoidCallback onTap,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgScreen,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: size.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Link Drive Images Profile",
                style: blackTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(
                  hintText: 'Link Image',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 13.0),
                  hintStyle: transTextstyle.copyWith(
                    fontSize: 15,
                    color: AppColors.bgGrey,
                    fontWeight: semiBold,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.tertiary,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: semiBold,
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  onTap();
                },
                child: Container(
                  // width: size.width * 0.25,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Simpan',
                      style: whiteTextstyle.copyWith(
                        fontSize: 19,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

