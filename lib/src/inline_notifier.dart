import 'dart:math';

export '' show InlineNotifier, DisposeInlineNotifier;

/// Use to raise execution of some methods in all
/// widget that register this notifier.
class InlineNotifier {
  static InlineNotifier? _inst;
  InlineNotifier._();
  static InlineNotifier get inst => _inst ??= InlineNotifier._();
  static InlineNotifier get i => _inst ??= InlineNotifier._();
  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

  Map<String, void Function(dynamic data)> notifiers = {};

  /// Generates a random string of a given length.
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  /// Register a new callback via it's key name.
  ///
  /// It is very indispensable to dispose a notifier when it parent is disposed.
  static DisposeInlineNotifier registerNotifier(String keyName, void Function(dynamic) notifier) {
    var instance = InlineNotifier.inst;

    String groupKey = instance._generateRandomString(18);
    keyName = "$groupKey---$keyName";

    instance.notifiers[keyName] = notifier;

    return DisposeInlineNotifier(groupKey);
  }

  /// Register a new group of callbacks via it's key name.
  ///
  /// It is very indispensable to dispose a notifier when it parent is disposed.
  static DisposeInlineNotifier registerNotifiers(Map<String, void Function(dynamic)> notifiers) {
    var instance = InlineNotifier.inst;

    String groupKey = instance._generateRandomString(18);
    for (String keyName in notifiers.keys) {
      keyName = "$groupKey---$keyName";
      instance.notifiers[keyName] = notifiers[keyName]!;
    }

    return DisposeInlineNotifier(groupKey);
  }

  /// Notify a callback via it's key name.
  ///
  /// Some time error can be raised, please verify if called callback is still valid.
  /// But parent can be disposed.
  ///
  /// If two element have same key name, the last one will be used.
  static void notify(String keyName, [dynamic data]) {
    var instance = InlineNotifier.inst;

    String keyName0 = '';
    for (String key in instance.notifiers.keys) {
      List<String> splied = key.split('---');
      if (keyName == (splied.elementAtOrNull(1) ?? splied.first)) {
        if (instance.notifiers.containsKey(key)) keyName0 = key;
      }
    }
    if (keyName0 == '') return;

    instance.notifiers[keyName0]?.call(data);
  }

  /// Notify a group of callbacks via it's key names.
  static void notifyAGroup(Map<String, dynamic> keyNames, [dynamic data]) {
    var instance = InlineNotifier.inst;

    for (String keyName in keyNames.keys) {
      String keyName0 = '';
      for (String key in instance.notifiers.keys) {
        List<String> splied = key.split('---');
        if (keyName == (splied.elementAtOrNull(1) ?? splied.first)) {
          if (instance.notifiers.containsKey(key)) keyName0 = key;
        }
      }
      if (keyName0 == '') return;

      instance.notifiers[keyName0]?.call(data);
    }
  }
}

/// Dispose update notifier.
///
/// It importent to avoid call error.
///
/// It is very indispensable to dispose a notifier when it parent is disposed.
///
/// ```dart
///  // ...
///  DisposeInlineNotifier? disposer;
///
///  @override
///  void initState() {
///    super.initState();
///
///    // REGISTER A NOTIFIER.
///    disposer = InlineNotifier.registerNotifier("MY_CUSTOM_KEY_NAME", (p0) => sampleSnackbar());
///  }
///
///  @override
///  void dispose() {
///    // DISPOSE IT.
///    // It importent to avoid call error.
///    disposer?.dispose();
///
///    super.dispose();
///  }
///
///  // ...
/// ```
class DisposeInlineNotifier {
  DisposeInlineNotifier(String groupKeyName) : _groupKeyName = groupKeyName;

  /// Notifier group name.
  final String _groupKeyName;

  /// Dispose update notifiers.
  void dispose() {
    for (String key in InlineNotifier.inst.notifiers.keys) {
      List<String> splied = key.split('---');
      if (_groupKeyName == (splied.elementAtOrNull(0) ?? '')) {
        if (InlineNotifier.inst.notifiers.containsKey(key)) {
          InlineNotifier.inst.notifiers.remove(key);
        }
      }
    }
  }
}
