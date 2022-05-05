import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats/gSaRd2atYtp53LZMdaqb/messages')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data?.docs;
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (ctx, index) => Container(
              padding: const EdgeInsets.all(
                8,
              ),
              child: Text(
                docs?[index]['text'],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/gSaRd2atYtp53LZMdaqb/messages')
              .add(
            {'text': 'This was added by clicking the button!'},
          );
        },
        // stream of data, listener to data changes
        // set up a listener trought firebase sdk
        // print()
        child: const Icon(Icons.add),
      ),
    );
  }
}
