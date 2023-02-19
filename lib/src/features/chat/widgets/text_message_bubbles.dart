import 'package:flutter/material.dart';

// Packages
import 'package:timeago/timeago.dart' as timeago;

// Models
import '../../../core/constants/constants_export.dart';
import '../models/chat_message_model.dart';

class TextMessageBubbleWidget extends StatelessWidget {
  const TextMessageBubbleWidget({
    Key? key,
    required this.isOwnMessage,
    required this.message,
    required this.width,
    required this.height,
  }) : super(key: key);

  final bool isOwnMessage;
  final ChatMessage message;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    List<Color> colorScheme = isOwnMessage
        ? [
            AppColors.appOwnMessageBubbleColor,
            AppColors.appPrimaryBackgroundColor,
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1),
            const Color.fromRGBO(51, 49, 68, 1),
          ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: height + (message.content.length / 20 * 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: colorScheme,
          stops: const [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            message.content,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
