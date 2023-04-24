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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10.0, 16.0, .0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0, 6, 10.0, 12.0),
          
          child:Text(
            lastMessage,
            style: const TextStyle(fontSize: 16.0),
          ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              
              Text(
                DateFormat('MM-dd-yyyy').format(timeSent),
                style: const TextStyle(fontSize: 12.0),
               ),
               Text(
                DateFormat('h:mm a').format(timeSent),
                style: const TextStyle(fontSize: 12.0),
              ),
          ])
        
        ],
      ),
    );
  }
}
