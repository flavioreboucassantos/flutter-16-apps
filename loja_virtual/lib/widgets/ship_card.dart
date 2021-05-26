import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          'Calcular Frete',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(Icons.location_on),
        collapsedTextColor: Colors.grey[700],
        iconColor: primaryColor,
        textColor: primaryColor,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu CEP',
              ),
              initialValue: '',
              onFieldSubmitted: (text) {},
            ),
          ),
        ],
      ),
    );
  }
}
