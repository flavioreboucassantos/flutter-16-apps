import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final TextStyle textStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'title',
        style: textStyle,
      ),
      subtitle: Text(
        'subtitle',
        style: textStyle,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Pedidos: 0',
            style: textStyle,
          ),
          Text(
            'Gasto: 0',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
