/// Class to trigger functions by keys when updating values at a Map<String, dynamic>
///
/// Author: FlavioReboucasSantos@gmail.com

class TriggerForm {
  Map<String, dynamic> form = {};
  List<List<String>> _listCombinedKeys = [];
  List<void Function()> _listListeners = [];

  /// Adds a function to be triggered if one of the keys in the list is updated.
  void addListener(List<String> combinedKeys, void Function() f) {
    _listCombinedKeys.add(combinedKeys);
    _listListeners.add(f);
  }

  /// Merges an entire formulary with the current.
  void setForm(Map<String, dynamic> data) {
    form.addAll(data);
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (data.keys.any((key) => _listCombinedKeys[i].contains(key))) _listListeners[i]();
  }

  /// Defines a [key-value] pair in the current formulary.
  void setKey(String key, dynamic value) {
    form[key] = value;
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (_listCombinedKeys[i].contains(key)) _listListeners[i]();
  }
}
