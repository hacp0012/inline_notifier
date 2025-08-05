This package simplifies method calls from Widget to Widget or from a child 
widget (Page B) to a parent widget (Page A).

This package is very simplistic and avoids complicated or high-level
implementations.

Similary to `ValueNotifier`

## Features

It allows you to update data, simply with a reference key of yours. 
(Often, when you are on a page to modify data and after saving you want 
to update the data on the previous page)

## Getting started

```dart
import 'package:inline_notifier/inline_notifier.dart';
```

Ajoutez ceci dans votre code, après avoir fait ceci :

```bash
flutter add inline_notifier
```

## Usage

```dart
class _PageAState extends State<PageA> {
  DisposeInlineNotifier? disposer;
  DisposeInlineNotifier? multiDisposer;

  @override
  void initState() {
    super.initState();

    // REGISTER A NOTIFIER.
    disposer = InlineNotifier.registerNotifier("MY_CUSTOM_KEY_NAME", (p0) => sampleSnackbar());
    
    // REGISTER MANY NOTIFIERS.
    multiDisposer = InlineNotifier.registerNotifiers({
      "MY_CUSTOM_KEY_NAME": (p0) => sampleSnackbar(), 
      "MY_SECOND_CUSTOM_KEY_NAME": (p0) => sampleSnackbar(),
    });
  }

  // CALLABLE.
  void sampleSnackbar() {
    // ....
  }

  @override
  void dispose() {
    // DISPOSE IT.
    // It importent to avoid call error.
    disposer?.dispose();
    multiDisposer?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("UPDATE NOTIFIER"),
            SizedBox(height: 9),

            // -------- CALL NOTIFIERS --------
            ElevatedButton(
              onPressed: () {
                InlineNotifier.notify('MY_CUSTOM_KEY_NAME');
                InlineNotifier.notifyAGroup(['MY_SECOND_CUSTOM_KEY_NAME', 'MY_CUSTOM_KEY_NAME', '...']);
              },
              child: Text("Notify it"),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Additional information

Other package of same dev : run_it, ui_value
