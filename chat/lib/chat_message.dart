import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool mine;

  ChatMessage(this.data, this.mine);

  Widget _getWidgetMessage() {
    Widget widgetMessage;
    if (data['imgUrl'] != null) {
      widgetMessage = Image.network(
        data['imgUrl'],
        width: 250.0,
      );
    } else {
      widgetMessage = Text(
        data['text'],
        textAlign: mine ? TextAlign.end : TextAlign.start,
        style: TextStyle(fontSize: 16.0),
      );
    }
    return widgetMessage;
  }

  Widget _getWidgetAvatar({double left = 0.0, double right = 0.0}) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right),
      child: CircleAvatar(
        backgroundImage: NetworkImage(data['senderPhotoUrl']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: [
          mine ? Container() : _getWidgetAvatar(right: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _getWidgetMessage(),
                Text(
                  data['senderName'],
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          mine ? _getWidgetAvatar(left: 16.0) : Container(),
        ],
      ),
    );
  }
}
