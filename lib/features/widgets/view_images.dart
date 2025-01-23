import 'package:flutter/material.dart';
import 'package:liad/core/media/media_text.dart';

class NetworkImageWidget extends StatelessWidget {
  final Size size;
  final String imageUrl;

  const NetworkImageWidget(
      {super.key, required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.25,
      height: size.width * 0.25,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: size.width * 0.25,
          height: size.width * 0.25,
          // width: 300.w, // Sesuaikan ukuran sesuai kebutuhan
          errorBuilder: (context, error, stackTrace) {
            // Widget ini akan ditampilkan jika terjadi error dalam memuat gambar
            return Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Text(
                'StringResources.notAvailableData',
                style: greyTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: SizedBox(
                  height: 20,
                  width: 30,
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

extension on int {
  get h => null;
}

class AssetImageWidget extends StatelessWidget {
  final Size size;
  final String imageUrl;

  const AssetImageWidget(
      {super.key, required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        imageUrl,
        width: size.width * 0.25,
        height: size.width * 0.25,
        fit: BoxFit.cover,
      ),
    );
  }
}
