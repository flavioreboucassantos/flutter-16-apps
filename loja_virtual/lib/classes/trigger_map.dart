/// Class to trigger functions by keys when updating values at a Map<String, dynamic>
///
/// Author: FlavioReboucasSantos@gmail.com

class TriggerMap {
  static Map<String, TriggerMap> _instances = Map();
  Map<String, dynamic> map = Map();
  List<List<String>> _listCombinedKeys = [];
  List<void Function(Map<String, dynamic>)> _listListeners = [];

  /// Initializes or retrieves a TriggerMap instance by [id] parameter.
  static TriggerMap instance(String id) {
    if (_instances[id] == null) {
      final newInstance = TriggerMap();
      _instances[id] = newInstance;
      return newInstance;
    }
    return _instances[id];
  }

  /// Deletes a TriggerMap instance by [id] parameter.
  static void delete(String id) {
    _instances.remove(id);
  }

  /// Adds a function to be triggered if one of the keys in the list is updated.
  ///
  /// The [first parameter] of the function contains a map of what was updated.
  void addListener(
    List<String> combinedKeys,
    void Function(Map<String, dynamic>) f,
  ) {
    _listCombinedKeys.add(combinedKeys);
    _listListeners.add(f);
  }

  /// Merges an entire map with the current.
  ///
  /// If a key of [data] is already in the current map, its value is overwritten.
  void mergeMap(Map<String, dynamic> data) {
    map.addAll(data);
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (data.keys.any((key) => _listCombinedKeys[i].contains(key)))
        _listListeners[i](data);
  }

  /// Defines a [key-value] pair in the current map.
  void setKey(String key, dynamic value) {
    map[key] = value;
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (_listCombinedKeys[i].contains(key)) _listListeners[i]({key: value});
  }
}
