import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconContainer extends StatelessWidget {
  final String assetPath; // Path SVG yang dinamis
  final Size size;
  final bool colorIcon;
  final Color borderColor;

  const SvgIconContainer({
    super.key,
    required this.assetPath, // Path harus diisi
    required this.size, // Default width
    this.colorIcon = false,
    this.borderColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.23,
      height: size.width * 0.2,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: colorIcon ? SvgPicture.asset(
        assetPath,
        fit: BoxFit.contain,
        // ignore: deprecated_member_use
        color:  Colors.black
      ) : SvgPicture.asset(
        assetPath,
        fit: BoxFit.contain,
      ),
    );
  }
}
