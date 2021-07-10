import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/image_source_sheet.dart';

class ImagesWidget extends FormField<List<dynamic>> {
  ImagesWidget({
    required BuildContext context,
    void Function(List<dynamic>? l)? onSaved,
    String? Function(List<dynamic>? l)? validator,
    List? initialValue = const [],
    AutovalidateMode? autovalidateMode,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            List<dynamic> value = List.of(state.value!.whereType());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 124,
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: state.value!.map<Widget>((i) {
                      Widget image;
                      if (i is String)
                        image = Image.network(
                          i,
                          fit: BoxFit.cover,
                        );
                      else
                        image = Image.file(
                          i,
                          fit: BoxFit.cover,
                        );
                      return Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          child: image,
                          onLongPress: () {
                            state.didChange(value..remove(i));
                          },
                        ),
                      );
                    }).toList()
                      ..add(
                        GestureDetector(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Icon(
                              Icons.camera_enhance,
                              color: Colors.white,
                            ),
                            color: Colors.white.withAlpha(50),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ImageSourceSheet((image) {
                                state.didChange(value..add(image));
                                Navigator.of(context).pop();
                              }),
                            );
                          },
                        ),
                      ),
                  ),
                ),
                state.hasError
                    ? Text(
                        state.errorText ?? '',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      )
                    : Container(),
              ],
            );
          },
        );
}
