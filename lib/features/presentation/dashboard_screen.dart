import 'package:flutter/material.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}