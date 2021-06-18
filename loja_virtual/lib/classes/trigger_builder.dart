import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The last shared [safeContext] from [TriggerBuilder].
///
/// Must be used through [Null-aware operators], for example:
/// [safeContext ?? context]
BuildContext get safeContext => _TriggerBuilderState._safeContext;

/// Builds a [Widget] using the shared [safeContext] from [TriggerBuilder]
/// if it exists.
///
/// Author: flavioReboucasSantos@gmail.com
class SafeBuilder extends StatelessWidget {
  final WidgetBuilder builder;

  const SafeBuilder({
    Key key,
    this.builder,
  }) : super(key: key);

  @override
  @nonVirtual
  Widget build(BuildContext context) =>
      builder(_TriggerBuilderState._safeContext ?? context);
}

/// A base class that holds some data and allows other classes to listen to
/// changes to that data.
///
/// In order to notify listeners that the data has changed, you must explicitly
/// call the [notifyListeners] method.
///
/// Author: flavioReboucasSantos@gmail.com
abstract class TriggerModel {
  static SplayTreeMap<int, TriggerModel> _typeSingleton =
      SplayTreeMap<int, TriggerModel>();

  int _type;
  List<String> _keys = <String>[];
  List<_TriggerBuilderState> _builders = <_TriggerBuilderState>[];
  List<_TriggerBuilderState> _nullKeyBuilders = <_TriggerBuilderState>[];

  /// Provides a [TriggerModel] instance of type [T] from the [model] parameter.
  ///
  /// If an instance of type [T] is already been provided, it will
  /// be overwritten.
  ///
  /// If the [model] parameter is null, finds a [TriggerModel] instance of
  /// type [T] provided.
  static T singleton<T extends TriggerModel>([T model]) {
    if (model == null) {
      return _typeSingleton[T.hashCode];
    } else {
      _typeSingleton[T.hashCode] = model;
      return model;
    }
  }

  void _setTree(
    int type,
    List<String> keys,
    List<_TriggerBuilderState> builders,
    List<_TriggerBuilderState> nullKeyBuilders,
  ) {
    _type = type;
    _keys = keys;
    _builders = builders;
    _nullKeyBuilders = nullKeyBuilders;
  }

  void _subscribe(String keyBuilder, _TriggerBuilderState builder) {
    if (keyBuilder == null)
      _nullKeyBuilders.add(builder);
    else {
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
      _builders[i].triggerBuilder(
          <String, dynamic>{key: value} as LinkedHashMap<String, dynamic>);
      start = i + 1;
    }
  }

  @mustCallSuper
  void _triggerByKeys(List<String> keys, LinkedHashMap<String, dynamic> other) {
    for (var i = 0; i < _keys.length; i++)
      if (keys.contains(_keys[i])) _builders[i].triggerBuilder(other);
  }

  @mustCallSuper
  void _triggerNullKey(LinkedHashMap<String, dynamic> other) {
    for (var i = 0; i < _nullKeyBuilders.length; i++)
      _nullKeyBuilders[i].triggerBuilder(other);
  }

  /// Just trigger the subscribed builders associated with the [keys] parameter
  /// and those of [null key].
  void notifyListeners([List<String> keys]) {
    if (keys != null)
      _triggerByKeys(
        keys,
        LinkedHashMap<String, dynamic>.fromIterables(
          keys,
          List.filled(keys.length, null, growable: false),
        ),
      );

    _triggerNullKey(
      keys == null
          ? LinkedHashMap<String, dynamic>()
          : LinkedHashMap<String, dynamic>.fromIterables(
              keys,
              List.filled(keys.length, null, growable: false),
            ),
    );
  }
}

typedef void TriggerFunction(LinkedHashMap<String, dynamic> data);

/// Trigger functions when updating keys at an internal Map<String, dynamic>
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerMap extends TriggerModel {
  static SplayTreeMap<String, TriggerMap> _instances =
      SplayTreeMap<String, TriggerMap>();

  static SplayTreeMap<int, SplayTreeMap<String, TriggerFunction>>
      _typeKeysFunctions =
      SplayTreeMap<int, SplayTreeMap<String, TriggerFunction>>();
  static SplayTreeMap<int, List<TriggerFunction>> _typeNullKeyFunctions =
      SplayTreeMap<int, List<TriggerFunction>>();

  SplayTreeMap<String, TriggerFunction> _keysFunctions;
  List<TriggerFunction> _nullKeyFunctions;

  final LinkedHashMap<String, dynamic> map = LinkedHashMap<String, dynamic>();

  /// Initializes or retrieves a [TriggerMap] instance by [id] parameter.
  ///
  /// If the [id] is present, retrieves a [TriggerMap] instance.
  ///
  /// If the [id] is not present, initializes a [TriggerMap] instance and returns.
  ///
  /// If the [instance] parameter is not null, it overwrites the [id] and returns the same [instance].
  static TriggerMap instance(String id, [TriggerMap instance]) {
    if (instance == null) {
      if (_instances[id] == null) {
        final TriggerMap newInstance = TriggerMap();
        _instances[id] = newInstance;
        return newInstance;
      }
      return _instances[id];
    } else {
      _instances[id] = instance;
      return instance;
    }
  }

  /// Removes a [TriggerMap] instance by [id] parameter, releasing it to store
  /// a new instance.
  static void clear(String id) {
    _instances.remove(id);
  }

  /// Adds all key/value pairs of [other] to the internal map.
  ///
  /// If the [trigger] parameter is false, no events will be triggered from
  /// the constructor.
  TriggerMap([Map<String, dynamic> other, bool trigger = true]) {
    int _type = this.runtimeType.hashCode;
    if (_typeKeysFunctions[_type] == null) {
      SplayTreeMap<String, TriggerFunction> keysFunctions =
          SplayTreeMap<String, TriggerFunction>();
      List<TriggerFunction> nullKeyFunctions = <TriggerFunction>[];
      _typeKeysFunctions[_type] = keysFunctions;
      _typeNullKeyFunctions[_type] = nullKeyFunctions;
      _keysFunctions = keysFunctions;
      _nullKeyFunctions = nullKeyFunctions;
    } else {
      _keysFunctions = _typeKeysFunctions[_type];
      _nullKeyFunctions = _typeNullKeyFunctions[_type];
    }

    if (other != null) {
      if (trigger)
        mergeAll(other);
      else
        map.addAll(other);
    }
  }

  @override
  void _triggerByPair(String key, dynamic value) {
    TriggerFunction function = _keysFunctions[key];
    if (function != null)
      function(<String, dynamic>{key: value} as LinkedHashMap<String, dynamic>);

    super._triggerByPair(key, value);
  }

  @override
  void _triggerByKeys(List<String> keys, LinkedHashMap<String, dynamic> other) {
    TriggerFunction function;
    for (var i = 0; i < keys.length; i++) {
      function = _keysFunctions[keys[i]];
      if (function != null) function(other);
    }

    super._triggerByKeys(keys, other);
  }

  @override
  void _triggerNullKey(LinkedHashMap<String, dynamic> other) {
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
  void subscribe(TriggerFunction function, [String key]) {
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
  void unsubscribe({TriggerFunction function, String key}) {
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
    if (map[key] == null)
      map[key] = other as LinkedHashMap<String, dynamic>;
    else
      (map[key] as LinkedHashMap<String, dynamic>).addAll(other);

    _triggerByPair(key, other);

    _triggerNullKey(
        <String, dynamic>{key: other} as LinkedHashMap<String, dynamic>);
  }

  /// Defines a [key]/[value] pair to the internal map.
  void setKey(String key, dynamic value) {
    map[key] = value;

    _triggerByPair(key, value);

    _triggerNullKey(
        <String, dynamic>{key: value} as LinkedHashMap<String, dynamic>);
  }

  /// Just trigger the subscribed functions and builders associated with
  /// the [keys] parameter and those of [null key].
  @override
  void notifyListeners([List<String> keys]) {
    if (keys != null)
      _triggerByKeys(
        keys,
        LinkedHashMap<String, dynamic>.fromIterables(
          keys,
          List.filled(keys.length, null, growable: false),
        ),
      );

    _triggerNullKey(
      keys == null
          ? LinkedHashMap<String, dynamic>()
          : LinkedHashMap<String, dynamic>.fromIterables(
              keys,
              List.filled(keys.length, null, growable: false),
            ),
    );

    super.notifyListeners(keys);
  }
}

/// An optional method that the return determines whether the Widget will
/// rebuild when the [model] changes.
typedef bool RebuildOnChange<T extends TriggerModel>(T model);

/// Builds a child for a [_TriggerBuilderState].
typedef Widget StateBuilder<T extends TriggerModel>(
  BuildContext context,
  T model,
  LinkedHashMap<String, dynamic> data,
);

/// Rebuilds the Widget whenever the [TriggerModel] changes.
///
/// Author: flavioReboucasSantos@gmail.com
class TriggerBuilder<T extends TriggerModel> extends StatefulWidget {
  /// The type [T] provided is responsible for associating triggers.
  ///
  /// If the [model] argument is null, finds a [TriggerModel] instance of
  /// type [T] provided.
  ///
  /// If the [model] argument is not null, different from the previous and
  /// different of type [T], unsubscribes the previous and subscribe the other.
  ///
  /// It is possible to construct different instances of [TriggerBuilder] using
  /// the same [keyBuilder] argument, triggering all the instances at the
  /// same time.
  ///
  /// If the [keyBuilder] argument is null, the [builder] will trigger
  /// from [any event], always after the others.
  ///
  /// If the [builder] argument is null, it is necessary to at least override
  /// the [build] method.
  const TriggerBuilder({
    Key key,
    this.model,
    this.keyBuilder,
    this.rebuildOnChange,
    this.safeContext = false,
    this.builder,
  }) : super(key: key);

  /// The [TriggerModel] to provide to the [builder].
  final T model;

  /// The [String] to subscribes the [TriggerBuilder] to rebuilds if the [key]
  /// is updated or triggered.
  final String keyBuilder;

  /// An optional method that the return determines whether the Widget will
  /// rebuild when the [model] changes.
  final RebuildOnChange<T> rebuildOnChange;

  /// If the [safeContext] argument is true, it shares the same context for all
  /// the next [TriggerBuilder] through the [build] method. This will discard a
  /// previous shared context and move to share the current context.
  ///
  /// The [safeContext] argument will be evaluated only when the [Widget]
  /// is inserted or removed from the tree so, be careful to never change the
  /// value of this argument.
  ///
  /// Be careful to set the [safeContext] argument true only once per [Route]
  /// because it considers only the last setted.
  ///
  /// If the [Navigator] removes the [Route] on what this object has
  /// the [safeContext] argument true, for example,
  /// via a [Navigator.of(context).pushReplacement] call, then the context
  /// shared by this object will be given as unsafe and will fail.
  final bool safeContext;

  /// Builds a Widget when the Widget is first created and whenever
  /// the [TriggerModel] changes if [rebuildOnChange] is null or returns `true`.
  final StateBuilder<T> builder;

  /// An optional method that the return determines whether the Widget will
  /// rebuild when the [model] changes.
  @protected
  bool rebuild(T model) => rebuildOnChange == null || rebuildOnChange(model);

  @protected
  Widget build(
          BuildContext context, T model, LinkedHashMap<String, dynamic> data) =>
      builder(context, model, data);

  @override
  _TriggerBuilderState createState() => _TriggerBuilderState<T>(model);
}

class _TriggerBuilderState<T extends TriggerModel>
    extends State<TriggerBuilder> {
  static final List<BuildContext> _contexts = <BuildContext>[];
  static BuildContext _safeContext;

  static SplayTreeMap<int, List<String>> _typeKeys =
      SplayTreeMap<int, List<String>>();
  static SplayTreeMap<int, List<_TriggerBuilderState>> _typeBuilders =
      SplayTreeMap<int, List<_TriggerBuilderState>>();
  static SplayTreeMap<int, List<_TriggerBuilderState>> _typeNullKeyBuilders =
      SplayTreeMap<int, List<_TriggerBuilderState>>();

  int type = T.hashCode;
  T model;
  LinkedHashMap<String, dynamic> data;

  _TriggerBuilderState(this.model);

  void setTree() {
    if (model._type != type)
      model._setTree(
        type,
        _typeKeys[type],
        _typeBuilders[type],
        _typeNullKeyBuilders[type],
      );
  }

  void triggerBuilder(LinkedHashMap<String, dynamic> other) {
    if (widget.rebuild(model)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          data = other;
          setState(() {});
        }
      });
      WidgetsBinding.instance.scheduleFrame();
    }
  }

  @override
  void initState() {
    if (widget.safeContext) {
      _contexts.add(context);
      _safeContext = context;
    }

    if (model == null) model = TriggerModel.singleton<T>();

    if (_typeKeys[type] == null) {
      List<String> keys = <String>[];
      List<_TriggerBuilderState> builders = <_TriggerBuilderState>[];
      List<_TriggerBuilderState> nullKeyBuilders = <_TriggerBuilderState>[];
      _typeKeys[type] = keys;
      _typeBuilders[type] = builders;
      _typeNullKeyBuilders[type] = nullKeyBuilders;
      model._setTree(
        type,
        keys,
        builders,
        nullKeyBuilders,
      );
    } else
      setTree();

    model._subscribe(widget.keyBuilder, this);
    super.initState();
  }

  @override
  void didUpdateWidget(TriggerBuilder oldWidget) {
    if (oldWidget.keyBuilder == widget.keyBuilder) {
      if (widget.model == null) {
        T singleton = TriggerModel.singleton<T>();
        if (model != singleton) {
          model = singleton;
          setTree();
        }
      } else if (model != widget.model) {
        model = widget.model;
        setTree();
      }
    } else {
      model._unsubscribe(this);
      if (widget.model == null) {
        T singleton = TriggerModel.singleton<T>();
        if (model != singleton) model = singleton;
      } else if (model != widget.model) model = widget.model;
      setTree();
      model._subscribe(widget.keyBuilder, this);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    if (widget.safeContext) {
      _contexts.remove(context);
      _safeContext = (_contexts.length > 0) ? _contexts.last : null;
    }

    model._unsubscribe(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => widget.build(
        _safeContext ?? context,
        model,
        data,
      );
}
