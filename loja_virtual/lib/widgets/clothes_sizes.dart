import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';

class ClothesSizes extends StatefulWidget {
  final List<dynamic> sizes;

  ClothesSizes(this.sizes);

  @override
  _ClothesSizesState createState() => _ClothesSizesState(sizes);
}

class _ClothesSizesState extends State<ClothesSizes> {
  TriggerMap _cartTriggerMap = TriggerMap.instance('cart');
  final List<dynamic> sizes;

  _ClothesSizesState(this.sizes);

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
                    _cartTriggerMap.setKey('size', size);
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
                      color: _cartTriggerMap.map['size'] == size
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
