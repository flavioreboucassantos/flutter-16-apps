import 'package:flutter/material.dart';

/// Class to trigger functions when updating keys at an internal Map<String, dynamic>
///
/// Author: flavioReboucasSantos@gmail.com

class TriggerMap {
  static Map<String, TriggerMap> _instances = Map<String, TriggerMap>();
  static List<TriggerMap> _singletons = [];

  Map<String, dynamic> map = Map<String, dynamic>();

  List<void Function(Map<String, dynamic>)> _anyUpdateFunctions = [];

  List<String> _listKeys = [];
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

  /// Provides a [TriggerMap] instance of type [T] from the [model] parameter.
  ///
  /// If an instance of type [T] is already been provided, it will be overwritten.
  ///
  /// If the [model] parameter is null, finds a [TriggerMap] instance of type [T] provided.
  static T singleton<T extends TriggerMap>([T model]) {
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

  void _triggerAnyUpdate(Map<String, dynamic> other) {
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _anyUpdateFunctions[i](other));
  }

  void _triggerByPair(String key, dynamic value) {
    _triggerAnyUpdate({key: value});

    for (var start = 0; start < _listKeys.length; start++) {
      int i = _listKeys.indexOf(key, start);
      if (i == -1) break;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _listKeysFunctions[i]({key: value}));
      start = i + 1;
    }
  }

  void _triggerByKeys(List<String> keys, Map<String, dynamic> other) {
    for (var i = 0; i < _listKeys.length; i++)
      if (keys.contains(_listKeys[i]))
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _listKeysFunctions[i](other));
  }

  /// Subscribes a [function] to be triggered if one of the [keys] of the argument is updated.
  ///
  /// If the [keys] parameter is null, the [function] will be triggered after any update.
  /// Many functions of any update can be registered.
  ///
  /// The [first parameter] of the [function] contains a map of what was updated.
  void subscribe(void Function(Map<String, dynamic>) function, [String key]) {
    if (key == null)
      _anyUpdateFunctions.add(function);
    else {
      int i = _listKeys.indexOf(key);
      if (i == -1) {
        _listKeys.add(key);
        _listKeysFunctions.add(function);
      } else {
        _listKeysFunctions[i] = function;
      }
    }
  }

  /// If the [function] argument is not null, finds the [function] and removes the key/function pair from the list of subscribers.
  ///
  /// If the [key] argument is not null, finds the [key] and removes the key/function pair from the list of subscribers.
  void unsubscribe({void Function(Map<String, dynamic>) function, String key}) {
    if (function != null) {
      _anyUpdateFunctions.remove(function);
      int i = _listKeysFunctions.indexOf(function);
      if (i != -1) {
        _listKeys.removeAt(i);
        _listKeysFunctions.removeAt(i);
      }
    }
    if (key != null) {
      int i = _listKeys.indexOf(key);
      if (i != -1) {
        _listKeys.removeAt(i);
        _listKeysFunctions.removeAt(i);
      }
    }
  }

  /// Adds all key/value pairs of [other] to the internal map.
  ///
  /// If a key of [other] is already in the internal map, its value is overwritten.
  void mergeAll(Map<String, dynamic> other) {
    map.addAll(other);

    _triggerAnyUpdate(other);

    _triggerByKeys(other.keys.toList(growable: false), other);
  }

  /// Adds all key/value pairs of [other] to the map of the [key].
  ///
  /// If a key of [other] is already in the map of the [key], its value is overwritten.
  void mergeKey(String key, Map<String, dynamic> other) {
    (map[key] as Map<String, dynamic>).addAll(other);

    _triggerByPair(key, other);
  }

  /// Defines a [key]/[value] pair to the internal map.
  void setKey(String key, dynamic value) {
    map[key] = value;

    _triggerByPair(key, value);
  }

  /// Just trigger the subscribed functions associated with the [keys] parameter and functions of any update.
  void trigger([List<String> keys]) {
    _triggerAnyUpdate(
      keys == null
          ? {}
          : Map.fromIterables(
              keys,
              List.filled(keys.length, null, growable: false),
            ),
    );

    if (keys != null)
      _triggerByKeys(
        keys,
        Map.fromIterables(
          keys,
          List.filled(keys.length, null, growable: false),
        ),
      );
  }
}
