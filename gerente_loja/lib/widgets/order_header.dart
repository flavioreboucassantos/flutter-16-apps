import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Carlos'),
            Text('Rua Asdfghjk Asdfghj'),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Preço Produtos',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text('Preço total'),
          ],
        ),
      ],
    );
  }
}
