import 'package:flutter/material.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';

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
