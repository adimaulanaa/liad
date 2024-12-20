import 'package:flutter/material.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/features/widgets/widget_dash.dart';

class SholatContentWidget extends StatelessWidget {
  final String day;
  final String location;
  final String formattedDate;
  final String formattedTime;
  final bool isData;
  final String nameSholat;
  final String scheduleSholat;
  final DateTime currentTime;
  final bool isSholatFinish;

  const SholatContentWidget({
    super.key,
    required this.day,
    required this.location,
    required this.formattedDate,
    required this.formattedTime,
    required this.isData,
    required this.nameSholat,
    required this.scheduleSholat,
    required this.currentTime,
    required this.isSholatFinish,
  });

  @override
  Widget build(BuildContext context) {
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
                formattedTime,
                style: whiteTextstyle.copyWith(
                  fontSize: 17,
                  fontWeight: bold,
                ),
              ),
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
                      getRemainingTime(scheduleSholat, currentTime),
                      style: whiteTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                )
              : noData(isSholatFinish),
        ],
      ),
    );
  }
}
