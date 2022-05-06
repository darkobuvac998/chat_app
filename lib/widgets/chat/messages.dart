import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: Future.delayed(
          Duration.zero,
          () async {
            return await FirebaseAuth.instance.currentUser;
          },
        ),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final docs = snapshot.data?.docs;
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, i) => MessageBubble(
                    isMe: docs![i]['userId'] == futureSnapshot.data?.uid,
                    message: docs[i]['text'],
                    key: ValueKey(docs[i].id),
                    userName: docs[i]['username'],
                  ),
                  itemCount: docs?.length,
                );
              });
        });
  }
}
