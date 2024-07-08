import 'package:flutter/material.dart';
import 'notifyservice.dart';

DateTime scheduleTime = DateTime.now();

class ReminderScreen extends StatelessWidget {
  final String title;

  const ReminderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                DatePickerTxt(),
                ScheduleBtn(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({Key? key}) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (time != null) {
            final combinedDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );

            setState(() {
              scheduleTime = combinedDateTime;
            });
            debugPrint('Selected DateTime: $scheduleTime');
          }
        }
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
          title: 'Time for some fruits',
          body: 'Notification for $scheduleTime',
          scheduledNotificationDateTime: scheduleTime,
        );
      },
    );
  }
}
