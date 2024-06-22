import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyNote extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final DateTime date;

  const MyNote({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMM').format(date);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey[600]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
