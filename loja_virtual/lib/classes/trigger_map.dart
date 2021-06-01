import 'package:flutter/material.dart';

/// Class to trigger functions when updating keys at an internal Map<String, dynamic>
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerMap {
  static Map<String, TriggerMap> _instances = Map<String, TriggerMap>();
  static List<TriggerMap> _singletons = [];

  final Map<String, dynamic> map = Map<String, dynamic>();

  final List<void Function(Map<String, dynamic>)> _anyUpdateFunctions = [];

  final _mapKeysFunctions = Map<String, void Function(Map<String, dynamic>)>();

  final List<_TriggerBuilderState> _anyTriggerBuilder = [];
  final List<String> _listBuilderKey = [];
  final List<_TriggerBuilderState> _listBuilder = [];

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

  void _triggerAny(Map<String, dynamic> other) {
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      _anyUpdateFunctions[i](other);

    for (var i = 0; i < _anyTriggerBuilder.length; i++)
      _anyTriggerBuilder[i].trigger(other);
  }

  void _triggerByPair(String key, dynamic value) {
    void Function(Map<String, dynamic>) function = _mapKeysFunctions[key];
    if (function != null) function({key: value});

    for (var start = 0; start < _listBuilderKey.length; start++) {
      int i = _listBuilderKey.indexOf(key, start);
      if (i == -1) break;
      _listBuilder[i].trigger({key: value});
      start = i + 1;
    }
  }

  void _triggerByKeys(List<String> keys, Map<String, dynamic> other) {
    void Function(Map<String, dynamic>) function;
    for (var i = 0; i < keys.length; i++) {
      function = _mapKeysFunctions[keys[i]];
      if (function != null) function(other);
    }

    for (var i = 0; i < _listBuilderKey.length; i++)
      if (keys.contains(_listBuilderKey[i])) _listBuilder[i].trigger(other);
  }

  /// Subscribes a [function] to be triggered if the [key] parameter is updated or triggered.
  ///
  /// If the [key] parameter is already subscribed, its function is overwritten.
  ///
  /// If the [key] parameter is null, the [function] will be triggered after [any update] or trigger event.
  /// Many functions of [any update] can be registered.
  /// Take care to unsubscribe functions of [any update] using the same subscribed item.
  ///
  /// The [first parameter] of the [function] contains a map of what was updated.
  void subscribe(void Function(Map<String, dynamic>) function, [String key]) {
    if (key == null)
      _anyUpdateFunctions.add(function);
    else
      _mapKeysFunctions[key] = function;
  }

  /// If the [function] argument is not null, finds the [function] and removes the key/function pair from the list of subscribers.
  ///
  /// If the [key] argument is not null, finds the [key] and removes the key/function pair from the list of subscribers.
  void unsubscribe({void Function(Map<String, dynamic>) function, String key}) {
    if (function != null) {
      _anyUpdateFunctions.remove(function);
      _mapKeysFunctions.removeWhere((key, value) => value == function);
    }
    if (key != null) {
      _mapKeysFunctions.remove(key);
    }
  }

  void subscribeBuilder(String builderKey, _TriggerBuilderState builder) {
    if (builderKey == null) {
      if (!_anyTriggerBuilder.contains(builder)) {
        _anyTriggerBuilder.add(builder);
      }
    } else {
      _listBuilderKey.add(builderKey);
      _listBuilder.add(builder);
    }
  }

  void unsubscribeBuilder(_TriggerBuilderState builder) {
    _anyTriggerBuilder.remove(builder);
    final int i = _listBuilder.indexOf(builder);
    if (i != -1) {
      _listBuilderKey.removeAt(i);
      _listBuilder.removeAt(i);
    }
  }

  /// Adds all key/value pairs of [other] to the internal map.
  ///
  /// If a key of [other] is already in the internal map, its value is overwritten.
  void mergeAll(Map<String, dynamic> other) {
    map.addAll(other);

    _triggerAny(other);

    _triggerByKeys(other.keys.toList(growable: false), other);
  }

  /// Adds all key/value pairs of [other] to the map of the [key].
  ///
  /// If a key of [other] is already in the map of the [key], its value is overwritten.
  void mergeKey(String key, Map<String, dynamic> other) {
    (map[key] as Map<String, dynamic>).addAll(other);

    _triggerAny({key: other});

    _triggerByPair(key, other);
  }

  /// Defines a [key]/[value] pair to the internal map.
  void setKey(String key, dynamic value) {
    map[key] = value;

    _triggerAny({key: value});

    _triggerByPair(key, value);
  }

  /// Just trigger the subscribed functions associated with the [keys] parameter and functions of [any update].
  void trigger([List<String> keys]) {
    _triggerAny(
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

/// Class to build Widgets to be updated by the trigger of keys.
///
/// It is possible to construct different instances of TriggerBuilder using the same [builderKey] argument to trigger all builders at the same event.
///
/// If the [builderKey] argument is null, the [builder] will trigger after [any update] or trigger event.
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerBuilder<T extends TriggerMap> extends StatefulWidget {
  final T model;
  final String builderKey;
  final Widget Function(
      BuildContext context, T model, Map<String, dynamic> data) builder;

  const TriggerBuilder({
    Key key,
    this.model,
    this.builderKey,
    @required this.builder,
  }) : super(key: key);

  @override
  _TriggerBuilderState createState() =>
      _TriggerBuilderState<T>(model, builderKey, builder);
}

class _TriggerBuilderState<T extends TriggerMap> extends State<TriggerBuilder> {
  T model;
  String builderKey;
  Map<String, dynamic> data;
  Widget Function(
    BuildContext context,
    T model,
    Map<String, dynamic> data,
  ) builder;

  _TriggerBuilderState(this.model, this.builderKey, this.builder);

  @override
  void initState() {
    if (model == null) model = TriggerMap.singleton<T>();
    model.subscribeBuilder(builderKey, this);
    super.initState();
  }

  @override
  void didUpdateWidget(TriggerBuilder oldWidget) {
    builderKey = widget.builderKey;
    if (oldWidget.builderKey == builderKey) {
      if (widget.model != null && widget.model != model) {
        model.unsubscribeBuilder(this);
        model = widget.model;
        model.subscribeBuilder(builderKey, this);
      }
    } else {
      if (widget.model != null && widget.model != model) {
        model.unsubscribeBuilder(this);
        model = widget.model;
      } else
        model.unsubscribeBuilder(this);
      model.subscribeBuilder(builderKey, this);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    model.unsubscribeBuilder(this);
    super.deactivate();
  }

  void trigger(Map<String, dynamic> other) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        data = other;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => builder(context, model, data);
}
