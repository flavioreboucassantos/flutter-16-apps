import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Future<bool> Function({String text, PickedFile pickedFile}) sendMessage;

  TextComposer(this.sendMessage);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _reset(Future<bool> sent) {
    sent.then((value) {
      if (value) {
        _controller.clear();
        setState(() {
          _isComposing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final PickedFile pickedFile =
                  await ImagePicker().getImage(source: ImageSource.camera);
              if (pickedFile == null) return;
              widget.sendMessage(pickedFile: pickedFile);
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: 'Enviar uma Mensagem'),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                if (text != '') _reset(widget.sendMessage(text: text));
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing
                ? () {
                    _reset(widget.sendMessage(text: _controller.text));
                  }
                : null,
          )
        ],
      ),
    );
  }
}
