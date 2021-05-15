import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_form.dart';

class AddCartButton extends StatefulWidget {
  final TriggerForm triggerForm;

  AddCartButton(this.triggerForm);

  @override
  _AddCartButtonState createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  Map<String, dynamic> cartForm;

  @override
  void initState() {
    super.initState();
    widget.triggerForm.addListener(['size'], () {
      if (cartForm == null) {
        cartForm = widget.triggerForm.form;
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
        onPressed: cartForm != null ? () {} : null,
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
