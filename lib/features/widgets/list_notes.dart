import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/features/model/notes_model.dart';

class ListNotes extends StatelessWidget {
  final Size size;
  final NotesModel dt;
  final ValueNotifier<bool> checkBox;
  final VoidCallback onTapCheckBox;
  const ListNotes({
    super.key,
    required this.size,
    required this.dt,
    required this.checkBox,
    required this.onTapCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    // String formattedDate = DateFormat('MMMM dd, yyyy').format(dt.updatedOn!);
    String formattedDate = formatDateBasedOnToday(dt.updatedOn!);
    return Container(
      width: (size.width - 40) / 2,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        color: AppColors.bgScreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Text(
                  dt.title.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: blackTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Text(
                  dt.content.toString(),
                  maxLines: 4,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: greyTextstyle.copyWith(
                    fontSize: 13,
                    fontWeight: medium,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      formattedDate,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: greyTextstyle.copyWith(
                        fontSize: 12,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, bottom: 5),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        checkBox.value =
                            !checkBox.value; // Toggle status ValueNotifier
                        onTapCheckBox(); // Callback tambahan
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: checkBox,
                        builder: (context, isEnabled, child) {
                          return SvgPicture.asset(
                            MediaRes.checklistNote,
                            fit: BoxFit.cover,
                            // ignore: deprecated_member_use
                            color: isEnabled ? AppColors.primary : Colors.grey,
                            width: 25,
                            height: 25,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

String formatDateBasedOnToday(DateTime date) {
  DateTime now = DateTime.now();

  // Check if the date is today
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return DateFormat('HH:mm').format(date); // Format as 'hour:minute'
  } else {
    return DateFormat('MMMM dd, yyyy')
        .format(date); // Format as 'Month dd, yyyy'
  }
}
