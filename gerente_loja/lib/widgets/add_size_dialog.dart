import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _controller,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
              child: Text(
                'Add',
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
