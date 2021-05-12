/// Formulary to trigger functions when updating values in keys.
///
/// Author: FlavioReboucasSantos@gmail.com

class TriggerForm {
  Map<String, dynamic> formData = {};
  List<List<String>> _listCombinedKeys = [];
  List<void Function(Map<String, dynamic>)> _listListeners = [];

  /// Adds a function to be triggered if one of the keys in the list is updated.
  void addListener(List<String> combinedKeys, void Function(Map<String, dynamic>) f) {
    _listCombinedKeys.add(combinedKeys);
    _listListeners.add(f);
  }

  /// Merges a entire formulary of key values with the current.
  void setForm(Map<String, dynamic> data) {
    formData.addAll(data);
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (data.keys.any((key) => _listCombinedKeys[i].contains(key)))
        _listListeners[i](data);
  }

  /// Defines a key value pair in the current formulary.
  void setKey(String key, dynamic value) {
    formData[key] = value;
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (_listCombinedKeys[i].contains(key)) _listListeners[i]({key: value});
  }

  /// Returns the value of a key.
  dynamic getKey(String key) {
    return formData[key];
  }
}
