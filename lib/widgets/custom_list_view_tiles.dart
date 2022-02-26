// Packages
import 'package:chatifyapp/models/chat_message_model.dart';
import 'package:chatifyapp/models/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; //Custom Animations

// Widgets
import '../widgets/rounded_image_network.dart';

// Models
// import '../models/chat_message_model.dart';
// import '../models/chat_user_model.dart';

class CustomListViewTileWithActivity extends StatelessWidget {
  const CustomListViewTileWithActivity({
    Key? key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
  }) : super(key: key);

  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: height * .20,
      onTap: () => onTap(),
      leading: RoundedIMageNetworkWithStatusIndicator(
        key: UniqueKey(),
        imagePath: imagePath,
        size: height / 2,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: isActivity
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // * Typing animation (...)
                SpinKitThreeBounce(
                  color: Colors.white54,
                  size: height * .10,
                ),
              ],
            )
          : Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  const CustomChatListViewTile({
    Key? key,
    required this.width,
    required this.deviceHeight,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  }) : super(key: key);

  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUserModel sender;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                  imagePath: sender.imageUrl,
                  size: width * .04,
                )
              : Container(),
          SizedBox(
            width: width * .05,
          ),
          message.type == MessageType.text
              ? Text(message.content)
              : Text(message.content),
        ],
      ),
    );
  }
}
