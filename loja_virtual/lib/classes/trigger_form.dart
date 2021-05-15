/// Class to trigger functions by keys when updating values at a Map<String, dynamic>
///
/// Author: FlavioReboucasSantos@gmail.com

class TriggerForm {
  Map<String, dynamic> formData = {};
  List<List<String>> _listCombinedKeys = [];
  List<void Function(Map<String, dynamic>, Map<String, dynamic>)> _listListeners = [];

  /// Adds a function to be triggered if one of the keys in the list is updated.
  ///
  /// The [first parameter] of the function contains the values of the formulary before the update.
  ///
  /// The [second parameter] of the function contains the values of the formulary after the update.
  void addListener(List<String> combinedKeys,
      void Function(Map<String, dynamic>, Map<String, dynamic>) f) {
    _listCombinedKeys.add(combinedKeys);
    _listListeners.add(f);
  }

  /// Merges a entire formulary with the current.
  void setForm(Map<String, dynamic> form) {
    Map<String, dynamic> previousForm = Map<String, dynamic>.from(formData);
    formData.addAll(form);
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (form.keys.any((key) => _listCombinedKeys[i].contains(key)))
        _listListeners[i](previousForm, formData);
  }

  /// Defines a [key-value] pair in the current formulary.
  void setKey(String key, dynamic value) {
    Map<String, dynamic> previousForm = Map<String, dynamic>.from(formData);
    formData[key] = value;
    for (var i = 0; i < _listCombinedKeys.length; i++)
      if (_listCombinedKeys[i].contains(key)) _listListeners[i](previousForm, formData);
  }

  /// Returns the value of a key.
  dynamic getKey(String key) {
    return formData[key];
  }
}
