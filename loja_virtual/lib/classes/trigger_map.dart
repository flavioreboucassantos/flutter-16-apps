/// Class to trigger functions by keys when updating values at a Map<String, dynamic>
///
/// Author: FlavioReboucasSantos@gmail.com

class TriggerMap {
  Map<String, dynamic> map = {};
  List<List<String>> _listCombinedKeys = [];
  List<void Function(Map<String, dynamic>)> _listListeners = [];

  /// Adds a function to be triggered if one of the keys in the list is updated.
  ///
  /// The [first parameter] of the function contains a map of what was updated.
  void addListener(List<String> combinedKeys, void Function(Map<String, dynamic>) f) {
    _listCombinedKeys.add(combinedKeys);
    _listListeners.add(f);
  }

  /// Merges an entire map with the current.
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
