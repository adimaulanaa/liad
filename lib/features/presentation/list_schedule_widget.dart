import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';

class ListScheduleWidget extends StatelessWidget {
  final String type;
  final String time;
  final ValueNotifier<bool> checkBox;
  final VoidCallback onTapCheckBox;

  const ListScheduleWidget({
    super.key,
    required this.type,
    required this.time,
    required this.checkBox,
    required this.onTapCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Ganti dengan AppColors.primary jika ada
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  type,
                  style: blackTextstyle.copyWith(
                    fontSize: 20,
                    fontWeight: medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Flexible(
                child: Text(
                  time,
                  style: blackTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              checkBox.value = !checkBox.value; // Toggle status ValueNotifier
              onTapCheckBox(); // Callback tambahan
            },
            child: ValueListenableBuilder<bool>(
              valueListenable: checkBox,
              builder: (context, isEnabled, child) {
                return Row(
                  children: [
                    SvgPicture.asset(
                      isEnabled ? MediaRes.checklist : MediaRes.unChecklist,
                      fit: BoxFit.cover,
                      // ignore: deprecated_member_use
                      color: isEnabled
                          ? Colors.grey
                          : Colors.black, // Ganti sesuai warna
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Selesai",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isEnabled ? Colors.grey : Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
