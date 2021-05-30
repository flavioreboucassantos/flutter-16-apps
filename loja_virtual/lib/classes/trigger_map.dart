import 'package:flutter/material.dart';

/// Class to trigger functions when updating keys at an internal Map<String, dynamic>
///
/// Author: flavioReboucasSantos@gmail.com

class TriggerMap {
  static Map<String, TriggerMap> _instances = Map<String, TriggerMap>();
  static List<TriggerMap> _singletons = [];

  Map<String, dynamic> map = Map<String, dynamic>();
  List<void Function(Map<String, dynamic>)> _anyUpdateFunctions = [];
  List<List<String>> _listKeys = [];
  List<void Function(Map<String, dynamic>)> _listKeysFunctions = [];

  /// Initializes or retrieves a TriggerMap instance by [id] parameter.
  static TriggerMap instance(String id) {
    if (_instances[id] == null) {
      final TriggerMap newInstance = TriggerMap();
      _instances[id] = newInstance;
      return newInstance;
    }
    return _instances[id];
  }

  /// Provides a [TriggerMap] instance of type [T] from the [model] argument.
  ///
  /// If an instance of type [T] is already been provided, it will be overwritten.
  ///
  /// If the [model] argument is null, finds a [TriggerMap] instance of type [T] provided.
  static T singleton<T extends TriggerMap>({T model}) {
    if (model == null) {
      for (var i = 0; i < _singletons.length; i++)
        if (_singletons[i] is T) return _singletons[i];
      return null;
    } else {
      for (var i = 0; i < _singletons.length; i++)
        if (_singletons[i] is T) {
          _singletons[i] = model;
          return model;
        }
      _singletons.add(model);
      return model;
    }
  }

  /// Removes a TriggerMap instance by [id] parameter, releasing it to store a new instance.
  static void clear(String id) {
    _instances.remove(id);
  }

  void _triggerByPair(String key, dynamic value) {
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _anyUpdateFunctions[i]({key: value}));
    for (var i = 0; i < _listKeys.length; i++)
      if (_listKeys[i].contains(key))
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _listKeysFunctions[i]({key: value}));
  }

  /// Subscribes a [function] to be triggered if one of the [keys] of the argument is updated.
  ///
  /// If the [keys] argument is null, the [function] will be triggered after any update.
  /// Many functions of any update can be registered.
  ///
  /// The [first parameter] of the [function] contains a map of what was updated.
  void subscribe(void Function(Map<String, dynamic>) function,
      {List<String> keys}) {
    if (keys == null)
      _anyUpdateFunctions.add(function);
    else {
      _listKeysFunctions.add(function);
      _listKeys.add(keys);
    }
  }

  /// Removes the first occurrence of [function] from the list of subscribers.
  void unsubscribe(void Function(Map<String, dynamic>) function) {
    _anyUpdateFunctions.remove(function);
    int i = _listKeysFunctions.indexOf(function);
    if (i != -1) {
      _listKeys.removeAt(i);
      _listKeysFunctions.removeAt(i);
    }
  }

  /// Adds all key/value pairs of [other] to the internal map.
  ///
  /// If a key of [other] is already in the internal map, its value is overwritten.
  void mergeAll(Map<String, dynamic> other) {
    map.addAll(other);
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _anyUpdateFunctions[i](other));
    for (var i = 0; i < _listKeys.length; i++)
      if (other.keys.any((key) => _listKeys[i].contains(key)))
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _listKeysFunctions[i](other));
  }

  /// Adds all key/value pairs of [other] to the map of the [key].
  ///
  /// If a key of [other] is already in the map of the [key], its value is overwritten.
  void mergeKey(String key, Map<String, dynamic> other) {
    (map[key] as Map<String, dynamic>).addAll(other);
    _triggerByPair(key, other);
  }

  /// Defines a [key/value] pair to the internal map.
  void setKey(String key, dynamic value) {
    map[key] = value;
    _triggerByPair(key, value);
  }

  /// Just trigger the subscribed functions associated with the [keys] argument and functions of any update.
  void trigger({List<String> keys}) {
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _anyUpdateFunctions[i](
                keys == null
                    ? {}
                    : Map.fromIterables(
                        keys,
                        List.filled(keys.length, null, growable: false),
                      ),
              ));
    if (keys != null)
      for (var i = 0; i < _listKeys.length; i++)
        if (keys.any((key) => _listKeys[i].contains(key)))
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _listKeysFunctions[i](
                    Map.fromIterables(
                      keys,
                      List.filled(keys.length, null, growable: false),
                    ),
                  ));
  }
}
