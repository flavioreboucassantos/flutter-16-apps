import 'package:flutter/material.dart';

/// A base class that holds some data and allows other classes to listen to
/// changes to that data.
///
/// In order to notify listeners that the data has changed, you must explicitly
/// call the [notifyListeners] method.
///
/// Author: flavioReboucasSantos@gmail.com
abstract class TriggerModel {
  static Map<Type, List<String>> _typeKeys = Map<Type, List<String>>();
  static Map<Type, List<_TriggerBuilderState>> _typeBuilders =
      Map<Type, List<_TriggerBuilderState>>();
  static Map<Type, List<_TriggerBuilderState>> _typeNullKeyBuilders =
      Map<Type, List<_TriggerBuilderState>>();

  static List<TriggerModel> _singletons = <TriggerModel>[];

  List<String> _keys;
  List<_TriggerBuilderState> _builders;
  List<_TriggerBuilderState> _nullKeyBuilders;

  TriggerModel() {
    if (_typeKeys.containsKey(this.runtimeType)) {
      _keys = _typeKeys[this.runtimeType];
      _builders = _typeBuilders[this.runtimeType];
      _nullKeyBuilders = _typeNullKeyBuilders[this.runtimeType];
    } else {
      List<String> keys = <String>[];
      List<_TriggerBuilderState> builders = <_TriggerBuilderState>[];
      List<_TriggerBuilderState> nullKeyBuilders = <_TriggerBuilderState>[];
      _typeKeys[this.runtimeType] = keys;
      _typeBuilders[this.runtimeType] = builders;
      _typeNullKeyBuilders[this.runtimeType] = nullKeyBuilders;
      _keys = keys;
      _builders = builders;
      _nullKeyBuilders = nullKeyBuilders;
    }
  }

  /// Provides a [TriggerModel] instance of type [T] from the [model] parameter.
  /// If an instance of type [T] is already been provided,
  /// it will be overwritten.
  ///
  /// If the [model] parameter is null, finds a [TriggerModel]
  /// instance of type [T] provided.
  static T singleton<T extends TriggerModel>([T model]) {
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

  void _subscribe(String keyBuilder, _TriggerBuilderState builder) {
    if (keyBuilder == null) {
      if (!_nullKeyBuilders.contains(builder)) {
        _nullKeyBuilders.add(builder);
      }
    } else {
      _keys.add(keyBuilder);
      _builders.add(builder);
    }
  }

  void _unsubscribe(_TriggerBuilderState builder) {
    _nullKeyBuilders.remove(builder);
    final int i = _builders.indexOf(builder);
    if (i != -1) {
      _keys.removeAt(i);
      _builders.removeAt(i);
    }
  }

  @mustCallSuper
  void _triggerByPair(String key, dynamic value) {
    for (var start = 0; start < _keys.length; start++) {
      int i = _keys.indexOf(key, start);
      if (i == -1) break;
      _builders[i]._triggerBuilder({key: value});
      start = i + 1;
    }
  }

  @mustCallSuper
  void _triggerByKeys(List<String> keys, Map<String, dynamic> other) {
    for (var i = 0; i < _keys.length; i++)
      if (keys.contains(_keys[i])) _builders[i]._triggerBuilder(other);
  }

  @mustCallSuper
  void _triggerNullKey(Map<String, dynamic> other) {
    for (var i = 0; i < _nullKeyBuilders.length; i++)
      _nullKeyBuilders[i]._triggerBuilder(other);
  }

  /// Just trigger the subscribed builders associated with the [keys] parameter
  /// and those of [null key].
  void notifyListeners([List<String> keys]) {
    if (keys != null)
      _triggerByKeys(
        keys,
        Map.fromIterables(
          keys,
          List.filled(keys.length, null, growable: false),
        ),
      );

    _triggerNullKey(
      keys == null
          ? {}
          : Map.fromIterables(
              keys,
              List.filled(keys.length, null, growable: false),
            ),
    );
  }
}

/// Trigger functions when updating keys at an internal Map<String, dynamic>
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerMap extends TriggerModel {
  static Map<String, TriggerMap> _instances = Map<String, TriggerMap>();

  final _keysFunctions = Map<String, void Function(Map<String, dynamic>)>();
  final List<void Function(Map<String, dynamic>)> _nullKeyFunctions =
      <void Function(Map<String, dynamic>)>[];

  final Map<String, dynamic> map = Map<String, dynamic>();

  /// Initializes or retrieves a [TriggerMap] instance by [id] parameter.
  static TriggerMap instance(String id) {
    if (_instances[id] == null) {
      final TriggerMap newInstance = TriggerMap();
      _instances[id] = newInstance;
      return newInstance;
    }
    return _instances[id];
  }

  /// Removes a [TriggerMap] instance by [id] parameter, releasing it to store
  /// a new instance.
  static void clear(String id) {
    _instances.remove(id);
  }

  @override
  void _triggerByPair(String key, dynamic value) {
    void Function(Map<String, dynamic>) function = _keysFunctions[key];
    if (function != null) function({key: value});

    super._triggerByPair(key, value);
  }

  @override
  void _triggerByKeys(List<String> keys, Map<String, dynamic> other) {
    void Function(Map<String, dynamic>) function;
    for (var i = 0; i < keys.length; i++) {
      function = _keysFunctions[keys[i]];
      if (function != null) function(other);
    }

    super._triggerByKeys(keys, other);
  }

  @override
  void _triggerNullKey(Map<String, dynamic> other) {
    for (var i = 0; i < _nullKeyFunctions.length; i++)
      _nullKeyFunctions[i](other);

    super._triggerNullKey(other);
  }

  /// Subscribes a [function] to be triggered if the [key] parameter is
  /// updated or triggered.
  ///
  /// If the [key] parameter is already subscribed, its [function]
  /// is overwritten.
  ///
  /// If the [key] parameter is null, the [function] will trigger
  /// from [any event], always after the others.
  ///
  /// Take care to unsubscribe functions of [null key] using the same
  /// subscribed item.
  ///
  /// The [first parameter] of the [function] contains a map of what
  /// was updated.
  void subscribe(void Function(Map<String, dynamic>) function, [String key]) {
    if (key == null)
      _nullKeyFunctions.add(function);
    else
      _keysFunctions[key] = function;
  }

  /// If the [function] argument is not null, finds the [function] and removes
  /// the key/function pair from the list of subscribers.
  ///
  /// If the [key] argument is not null, finds the [key] and removes the
  /// key/function pair from the list of subscribers.
  void unsubscribe({void Function(Map<String, dynamic>) function, String key}) {
    if (function != null) {
      _nullKeyFunctions.remove(function);
      _keysFunctions.removeWhere((key, value) => value == function);
    }
    if (key != null) {
      _keysFunctions.remove(key);
    }
  }

  /// Adds all key/value pairs of [other] to the internal map.
  ///
  /// If a key of [other] is already in the internal map, its value
  /// is overwritten.
  void mergeAll(Map<String, dynamic> other) {
    map.addAll(other);

    _triggerByKeys(other.keys.toList(growable: false), other);

    _triggerNullKey(other);
  }

  /// Adds all key/value pairs of [other] to the map of the [key].
  ///
  /// If a key of [other] is already in the map of the [key], its value
  /// is overwritten.
  void mergeKey(String key, Map<String, dynamic> other) {
    (map[key] as Map<String, dynamic>).addAll(other);

    _triggerByPair(key, other);

    _triggerNullKey({key: other});
  }

  /// Defines a [key]/[value] pair to the internal map.
  void setKey(String key, dynamic value) {
    map[key] = value;

    _triggerByPair(key, value);

    _triggerNullKey({key: value});
  }

  /// Just trigger the subscribed functions and builders associated with
  /// the [keys] parameter and those of [null key].
  @override
  void notifyListeners([List<String> keys]) {
    if (keys != null)
      _triggerByKeys(
        keys,
        Map.fromIterables(
          keys,
          List.filled(keys.length, null, growable: false),
        ),
      );

    _triggerNullKey(
      keys == null
          ? {}
          : Map.fromIterables(
              keys,
              List.filled(keys.length, null, growable: false),
            ),
    );

    super.notifyListeners(keys);
  }
}

/// An optional function that determines whether the Widget will rebuild when
/// the event is triggered.
typedef bool RebuildOnChange();

/// Builds a child for a [_TriggerBuilderState].
typedef Widget StateBuilder<T extends TriggerModel>(
  BuildContext context,
  T model,
  Map<String, dynamic> data,
);

/// If the [model] argument is null, finds a [TriggerModel] instance of
/// type [T] provided.
///
/// If the [model] argument is not null and different from the previous,
/// unsubscribes the previous and subscribe the other.
///
/// It is possible to construct different instances of [TriggerBuilder]
/// using the same [keyBuilder] argument, triggering all the instances
/// at the same time.
///
/// If the [keyBuilder] argument is null, the [builder] will trigger
/// from [any event], always after the others.
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerBuilder<T extends TriggerModel> extends StatefulWidget {
  /// The [TriggerModel] to provide to the [builder].
  final T model;

  /// The [String] to subscribes the [TriggerBuilder] to rebuilds if the [key]
  /// is updated or triggered.
  final String keyBuilder;

  /// An optional value that determines whether the Widget will rebuild when
  /// the model changes.
  final RebuildOnChange rebuildOnChange;

  /// Builds a Widget when the Widget is first created and whenever
  /// the [TriggerModel] changes if [rebuildOnChange] is null or returns `true`.
  final StateBuilder<T> builder;

  const TriggerBuilder({
    Key key,
    this.model,
    this.keyBuilder,
    this.rebuildOnChange,
    @required this.builder,
  }) : super(key: key);

  StateBuilder<E> _getBuilder<E extends TriggerModel>() {
    return builder as StateBuilder<E>;
  }

  @override
  _TriggerBuilderState createState() => _TriggerBuilderState<T>(model);
}

class _TriggerBuilderState<T extends TriggerModel>
    extends State<TriggerBuilder> {
  T model;
  Map<String, dynamic> data;

  _TriggerBuilderState(this.model);

  void _triggerBuilder(Map<String, dynamic> other) {
    if (widget.rebuildOnChange == null || widget.rebuildOnChange()) {
      WidgetsBinding.instance.scheduleFrame();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          data = other;
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    if (model == null) model = TriggerModel.singleton<T>();
    model._subscribe(widget.keyBuilder, this);
    super.initState();
  }

  @override
  void didUpdateWidget(TriggerBuilder oldWidget) {
    if (oldWidget.keyBuilder == widget.keyBuilder) {
      if (widget.model != null &&
          widget.model.runtimeType != model.runtimeType) {
        model._unsubscribe(this);
        model = widget.model;
        model._subscribe(widget.keyBuilder, this);
      }
    } else {
      model._unsubscribe(this);
      if (widget.model != null && widget.model.runtimeType != model.runtimeType)
        model = widget.model;
      model._subscribe(widget.keyBuilder, this);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    model._unsubscribe(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) =>
      widget._getBuilder<T>()(context, model, data);
}
