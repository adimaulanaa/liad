import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Column(
        children: [
          Text('Title : ${message.notification!.title.toString()}'),
          Text('Body : ${message.notification!.body.toString()}'),
          Text('Data : ${message.data.toString()}'),
        ],
      ),
    );
  }
}
