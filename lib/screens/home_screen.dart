import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Lawazia Pulse"),
      ),

      body: ValueListenableBuilder<int>(
        valueListenable: NotificationService.notifier,
        builder: (context, value, child) {

          final notifications = NotificationService.notifications;

          if (notifications.isEmpty) {

            return const Center(
              child: Text("No Notifications Yet"),
            );

          }

          return ListView.builder(

            itemCount: notifications.length,

            itemBuilder: (context, index) {

              final n = notifications[index];

              return ListTile(

                title: Text(n.title),

                subtitle: Text(n.body),

                trailing: Text(
                  "${n.time.hour}:${n.time.minute}",
                ),

              );

            },

          );

        },
      ),

    );
  }

}