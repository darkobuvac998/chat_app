import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userName;
  const MessageBubble(
      {required this.message,
      required this.isMe,
      required this.userName,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey.shade300
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(
                12,
              ),
              topRight: const Radius.circular(
                12,
              ),
              bottomLeft: !isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(
                      12,
                    ),
              bottomRight: isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(
                      12,
                    ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).textTheme.headline1?.color,
                ),
              ),
              Text(
                message,
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).textTheme.headline1?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
