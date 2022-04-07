import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/widgets/chat/message_bubble.dart';
import '../widgets/chat/new_message.dart';
import '../widgets/chat/messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUser = FirebaseAuth.instance.currentUser;
  var chatDocsId;
  final adminUid = '9EAXrUIg5ffzH6ZBA7rAIkiMjwp1';
  var userData;
  var adminData;
  var _enteredMessage = '';

  @override
  void initState() {
    super.initState();

    _getUserDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: chats
                    .doc(chatDocsId)
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                  if (chatSnapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong!'),
                    );
                  }
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (chatSnapshot.hasData) {
                    final messageDocs = chatSnapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messageDocs.length,
                      itemBuilder: (ctx, index) => MessageBubble(
                        messageDocs[index].data()['text'],
                        messageDocs[index].data()['uid'] == currentUser!.uid
                            ? userData.data()['username']
                            : adminData.data()['username'],
                        messageDocs[index].data()['uid'] == currentUser!.uid
                            ? userData.data()['image_url']
                            : adminData.data()['image_url'],
                        messageDocs[index].data()['uid'] == currentUser!.uid,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            NewMessage(chatDocsId)
          ],
        ),
      ),
    );
  }

  Future<void> _getUserDocs() async {
    await chats
        .where('users',
            isEqualTo: {'user': currentUser!.uid, 'admin': adminUid})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            chatDocsId = querySnapshot.docs.single.id;
          } else {
            chats.add({
              'users': {
                'user': currentUser!.uid,
                'admin': adminUid,
              }
            }).then(
              (value) => {chatDocsId = value.id},
            );
          }
        })
        .catchError((error) {});

    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    adminData = await FirebaseFirestore.instance
        .collection('users')
        .doc('9EAXrUIg5ffzH6ZBA7rAIkiMjwp1')
        .get();

    setState(() {});
  }
}
