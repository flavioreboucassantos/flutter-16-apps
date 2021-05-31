import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:loja_virtual/models/cart_product_model.dart';

class ClothesSizes extends StatefulWidget {
  final List<dynamic> sizes;

  ClothesSizes(this.sizes);

  @override
  _ClothesSizesState createState() => _ClothesSizesState();
}

class _ClothesSizesState extends State<ClothesSizes> {
  final CartProductModel model = TriggerMap.singleton<CartProductModel>();

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
        children: widget.sizes
            .map(
              (size) => GestureDetector(
                onTap: () {
                  model.size = size;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        4.0,
                      ),
                    ),
                    border: Border.all(
                      color:
                          model.size == size ? primaryColor : Colors.grey[500],
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
