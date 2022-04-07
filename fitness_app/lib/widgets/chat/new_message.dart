import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  final chatDocsId;

  NewMessage(this.chatDocsId);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteretmessage = '';
  final currentUser = FirebaseAuth.instance.currentUser;
  final _controller = new TextEditingController();

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatDocsId)
        .collection('messages')
        .add({
      'text': _enteretmessage,
      'createdAt': Timestamp.now(),
      'uid': currentUser!.uid
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chatDocsId);
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send a message..'),
              onChanged: (value) {
                setState(() {
                  _enteretmessage = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: _enteretmessage.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
