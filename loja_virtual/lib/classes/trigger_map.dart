import 'package:flutter/material.dart';

/// It trigger functions when updating keys at an internal Map<String, dynamic>
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerMap {
  static Map<String, TriggerMap> _instances = Map<String, TriggerMap>();
  static List<TriggerMap> _singletons = [];

  final Map<String, dynamic> map = Map<String, dynamic>();

  final List<void Function(Map<String, dynamic>)> _anyUpdateFunctions = [];

  final _mapKeysFunctions = Map<String, void Function(Map<String, dynamic>)>();

  final List<_TriggerBuilderState> _anyTriggerBuilder = [];
  final List<String> _listkeyBuilder = [];
  final List<_TriggerBuilderState> _listBuilder = [];

  /// Initializes or retrieves a [TriggerMap] instance by [id] parameter.
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

  /// Removes a [TriggerMap] instance by [id] parameter, releasing it to store a new instance.
  static void clear(String id) {
    _instances.remove(id);
  }

  void _triggerAny(Map<String, dynamic> other) {
    for (var i = 0; i < _anyUpdateFunctions.length; i++)
      _anyUpdateFunctions[i](other);

    for (var i = 0; i < _anyTriggerBuilder.length; i++)
      _anyTriggerBuilder[i]._triggerBuilder(other);
  }

  void _triggerByPair(String key, dynamic value) {
    void Function(Map<String, dynamic>) function = _mapKeysFunctions[key];
    if (function != null) function({key: value});

    for (var start = 0; start < _listkeyBuilder.length; start++) {
      int i = _listkeyBuilder.indexOf(key, start);
      if (i == -1) break;
      _listBuilder[i]._triggerBuilder({key: value});
      start = i + 1;
    }
  }

  void _triggerByKeys(List<String> keys, Map<String, dynamic> other) {
    void Function(Map<String, dynamic>) function;
    for (var i = 0; i < keys.length; i++) {
      function = _mapKeysFunctions[keys[i]];
      if (function != null) function(other);
    }

    for (var i = 0; i < _listkeyBuilder.length; i++)
      if (keys.contains(_listkeyBuilder[i]))
        _listBuilder[i]._triggerBuilder(other);
  }

  /// Subscribes a [function] to be triggered if the [key] parameter is updated or triggered.
  ///
  /// If the [key] parameter is already subscribed, its [function] is overwritten.
  ///
  /// If the [key] parameter is null, the [function] will trigger from [any update] or [trigger event], always after the others.
  ///
  /// Take care to unsubscribe functions of [null key] using the same subscribed item.
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

  void _subscribeBuilder(String keyBuilder, _TriggerBuilderState builder) {
    if (keyBuilder == null) {
      if (!_anyTriggerBuilder.contains(builder)) {
        _anyTriggerBuilder.add(builder);
      }
    } else {
      _listkeyBuilder.add(keyBuilder);
      _listBuilder.add(builder);
    }
  }

  void _unsubscribeBuilder(_TriggerBuilderState builder) {
    _anyTriggerBuilder.remove(builder);
    final int i = _listBuilder.indexOf(builder);
    if (i != -1) {
      _listkeyBuilder.removeAt(i);
      _listBuilder.removeAt(i);
    }
  }

  /// Adds all key/value pairs of [other] to the internal map.
  ///
  /// If a key of [other] is already in the internal map, its value is overwritten.
  void mergeAll(Map<String, dynamic> other) {
    map.addAll(other);

    _triggerByKeys(other.keys.toList(growable: false), other);

    _triggerAny(other);
  }

  /// Adds all key/value pairs of [other] to the map of the [key].
  ///
  /// If a key of [other] is already in the map of the [key], its value is overwritten.
  void mergeKey(String key, Map<String, dynamic> other) {
    (map[key] as Map<String, dynamic>).addAll(other);

    _triggerByPair(key, other);

    _triggerAny({key: other});
  }

  /// Defines a [key]/[value] pair to the internal map.
  void setKey(String key, dynamic value) {
    map[key] = value;

    _triggerByPair(key, value);

    _triggerAny({key: value});
  }

  /// Just trigger the subscribed functions and builders associated with the [keys] parameter and those of [null key].
  void notifyListeners([List<String> keys]) {
    if (keys != null)
      _triggerByKeys(
        keys,
        Map.fromIterables(
          keys,
          List.filled(keys.length, null, growable: false),
        ),
      );

    _triggerAny(
      keys == null
          ? {}
          : Map.fromIterables(
              keys,
              List.filled(keys.length, null, growable: false),
            ),
    );
  }
}

/// An optional function that determines whether the Widget will rebuild when the event is triggered.
typedef bool RebuildOnTrigger();

/// Builds a child for a [_TriggerBuilderState].
typedef Widget StateBuilder<T extends TriggerMap>(
  BuildContext context,
  T model,
  Map<String, dynamic> data,
);

/// If the [model] argument is null, finds a [TriggerMap] instance of type [T] provided.
///
/// If the [model] argument is not null and different from the previous, unsubscribes the previous and subscribe the other.
///
/// It is possible to construct different instances of [TriggerBuilder] using the same [keyBuilder] argument, triggering all the instances at the same time.
///
/// If the [keyBuilder] argument is null, the [builder] will trigger from [any update] or [trigger event], always after the others.
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerBuilder<T extends TriggerMap> extends StatefulWidget {
  final T model;
  final String keyBuilder;
  final RebuildOnTrigger rebuildOnTrigger;
  final StateBuilder<T> builder;

  const TriggerBuilder({
    Key key,
    this.model,
    this.keyBuilder,
    this.rebuildOnTrigger,
    @required this.builder,
  }) : super(key: key);

  StateBuilder<E> _getBuilder<E extends TriggerMap>() {
    return builder as StateBuilder<E>;
  }

  @override
  _TriggerBuilderState createState() => _TriggerBuilderState<T>(model);
}

class _TriggerBuilderState<T extends TriggerMap> extends State<TriggerBuilder> {
  T model;
  Map<String, dynamic> data;

  _TriggerBuilderState(this.model);

  void _triggerBuilder(Map<String, dynamic> other) {
    if (widget.rebuildOnTrigger == null || widget.rebuildOnTrigger())
      WidgetsBinding.instance.scheduleFrameCallback((_) {
        if (mounted) {
          data = other;
          setState(() {});
        }
      });
  }

  @override
  void initState() {
    if (model == null) model = TriggerMap.singleton<T>();
    model._subscribeBuilder(widget.keyBuilder, this);
    super.initState();
  }

  @override
  void didUpdateWidget(TriggerBuilder oldWidget) {
    if (oldWidget.keyBuilder == widget.keyBuilder) {
      if (widget.model != null && widget.model != model) {
        model._unsubscribeBuilder(this);
        model = widget.model;
        model._subscribeBuilder(widget.keyBuilder, this);
      }
    } else {
      model._unsubscribeBuilder(this);
      if (widget.model != null && widget.model != model) model = widget.model;
      model._subscribeBuilder(widget.keyBuilder, this);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    model._unsubscribeBuilder(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) =>
      widget._getBuilder<T>()(context, model, data);
}
