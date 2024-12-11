import 'package:flutter/material.dart';
import 'package:liad/core/firebase/get_services_key.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/features/data/dashboard_provider.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:provider/provider.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key});

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Enter notification title',
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Message',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Enter notification message',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () {
          sendNotif();
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: AppColors.bgGreen,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              'Send Notification',
              style: whiteTextstyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void sendNotif() async {
    final title = _titleController.text;
    final message = _messageController.text;
    GetServicesKey getServicesKey = GetServicesKey();
    String accessToken = await getServicesKey.getServicesKeyToken();
    if (accessToken != '') {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      SendNotifModel send = await provider.sendNotif(accessToken, 'title', 'message');
      print(send.isError);

      // Handle sending notification logic here
      print('Title: $title');
      print('Message: $message');
      print('accessToken: $accessToken');
    }
  }
}
