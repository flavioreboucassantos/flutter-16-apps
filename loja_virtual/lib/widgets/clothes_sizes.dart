import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/select_size.dart';

class ClothesSizes extends StatefulWidget {
  final List<dynamic> sizes;

  final SelectSize selectSize;

  ClothesSizes(this.sizes, this.selectSize);

  @override
  _SizesState createState() => _SizesState(sizes);
}

class _SizesState extends State<ClothesSizes> {
  final List<dynamic> sizes;

  _SizesState(this.sizes);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return SizedBox(
      height: 34.0,
      child: GridView(
        padding: EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.5,
        ),
        children: sizes
            .map(
              (size) => GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectSize.doSelect(size);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        4.0,
                      ),
                    ),
                    border: Border.all(
                      color: widget.selectSize.size == size
                          ? primaryColor
                          : Colors.grey[500],
                      width: 3.0,
                    ),
                  ),
                  width: 50.0,
                  alignment: Alignment.center,
                  child: Text(size),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
