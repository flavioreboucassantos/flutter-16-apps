import 'package:loja_virtual/classes/trigger_map.dart';

class CartProductModel extends TriggerMap {
  String _size;

  String get size => _size;

  set size(String size) {
    _size = size;
    triggerEvent();
  }
}
