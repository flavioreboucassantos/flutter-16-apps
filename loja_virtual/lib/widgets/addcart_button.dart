import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';

class AddCartButton extends StatefulWidget {
  final TriggerMap triggerMap;

  AddCartButton(this.triggerMap);

  @override
  _AddCartButtonState createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  Map<String, dynamic> cartMap;

  @override
  void initState() {
    super.initState();
    widget.triggerMap.addListener(['size'], (Map<String, dynamic> data) {
      if (cartMap == null) {
        cartMap = widget.triggerMap.map;
        setState(() {});
      }
    });
  }

  Color _getBackgroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return Colors.grey;
    }
    return Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: ElevatedButton(
        onPressed: cartMap != null ? () {} : null,
        child: Text(
          'Adicionar ao Carrinho',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(_getBackgroundColor),
        ),
      ),
    );
  }
}
