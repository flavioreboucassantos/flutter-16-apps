/// Class to trigger functions by keys when updating values at a Map<String, dynamic>
///
/// Author: flavioReboucasSantos@gmail.com

class TriggerMap {
  static Map<String, TriggerMap> _instances = Map();
  Map<String, dynamic> map = Map();
  List<void Function(Map<String, dynamic>)> _anyUpdateFunctions = [];
  List<List<String>> _listKeys = [];
  List<void Function(Map<String, dynamic>)> _listKeysFunctions = [];

  /// Initializes or retrieves a TriggerMap instance by [id] parameter.
  static TriggerMap instance(String id) {
    if (_instances[id] == null) {
      final newInstance = TriggerMap();
      _instances[id] = newInstance;
      return newInstance;
    }
    return _instances[id];
  }

  /// Removes a TriggerMap instance by [id] parameter, releasing the identifier to store a new instance.
  static void clear(String id) {
    _instances.remove(id);
  }

  /// Adds a [function] to be triggered if one of the [keys] of the argument is updated.
  ///
  /// If the [keys] argument is null, the [function] will be triggered after any update.
  /// Many of this [function] can be registered.
  ///
  /// The [first parameter] of the [function] contains a map of what was updated.
  void addListener(void Function(Map<String, dynamic>) function,
      {List<String> keys}) {
    if (keys == null)
      _anyUpdateFunctions.add(function);
    else {
      _listKeysFunctions.add(function);
      _listKeys.add(keys);
    }
  }

  /// Merges an entire map with the current.
  ///
  /// If a key of [data] is already in the current map, its value is overwritten.
  void mergeMap(Map<String, dynamic> data) {
    map.addAll(data);
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      _anyUpdateFunctions[i](data);
    for (var i = 0; i < _listKeys.length; i++)
      if (data.keys.any((key) => _listKeys[i].contains(key)))
        _listKeysFunctions[i](data);
  }

  /// Defines a [key-value] pair in the current map.
  void setKey(String key, dynamic value) {
    map[key] = value;
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      _anyUpdateFunctions[i]({key: value});
    for (var i = 0; i < _listKeys.length; i++)
      if (_listKeys[i].contains(key)) _listKeysFunctions[i]({key: value});
  }
}
