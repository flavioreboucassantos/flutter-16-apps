import 'package:flutter/material.dart';

import 'add_size_dialog.dart';

class ProductSizes extends FormField<List<String>> {
  ProductSizes({
    required BuildContext context,
    List<String>? initialValue,
    FormFieldSetter<List<String>>? onSaved,
    FormFieldValidator<List<String>>? validator,
  }) : super(
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (state) {
            Widget _getSize(String text) {
              return GestureDetector(
                onLongPress: text == '+'
                    ? null
                    : () {
                        state.didChange(state.value!..remove(text));
                      },
                onTap: text == '+'
                    ? () async {
                        String? size = await showDialog(
                          context: context,
                          builder: (context) => AddSizeDialog(),
                        );
                        if (size != null)
                          state.didChange(state.value!..add(size));
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      color: state.hasError ? Colors.red : Colors.pinkAccent,
                      width: 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 34,
              child: GridView(
                padding: EdgeInsets.symmetric(vertical: 4),
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.5,
                ),
                children: state.value!
                    .map(
                      (s) => _getSize(s),
                    )
                    .toList()
                      ..add(_getSize('+')),
              ),
            );
          },
        );
}
