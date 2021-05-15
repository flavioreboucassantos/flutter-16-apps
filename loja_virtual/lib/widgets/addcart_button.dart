import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';

class AddCartButton extends StatefulWidget {
  @override
  _AddCartButtonState createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  TriggerMap _cartTriggerMap = TriggerMap.instance('cart');
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _cartTriggerMap.addListener(['size'], (Map<String, dynamic> data) {
      if (!_loaded) {
        _loaded = true;
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

  Future<String> teste() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Return of teste()';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: ElevatedButton(
        onPressed: _loaded ? () {} : null,
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
