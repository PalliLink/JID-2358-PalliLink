import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class ChatCard extends StatelessWidget {
  const ChatCard(
      {super.key,
      required this.name,
      required this.lastMessage,
      required this.timeSent,
      required this.refresh});

  final String name;

  final String lastMessage;
  final DateTime timeSent;
  final Function refresh;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                flex: 1,
                child: Icon(Icons.account_circle, size: 48),
              ),
              Expanded(
                flex: 4,
                child: _ChatDescription(
                    name: name,
                    lastMessage: lastMessage,
                    timeSent: timeSent),
              ),
            ],
          ),
        )));
  }
}

class _ChatDescription extends StatelessWidget {
  const _ChatDescription({
    required this.name,
    required this.lastMessage,
    required this.timeSent,
  });

  final String name;
  final String lastMessage;
  final DateTime timeSent;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en,', null);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
          Text(
            lastMessage,
            style: const TextStyle(fontSize: 16.0),
          ),
          Text(
            DateFormat('h:mm a').format(timeSent),
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
