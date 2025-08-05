import 'package:flutter/material.dart';
import 'package:inline_notifier/inline_notifier.dart';

void main() => runApp(MaterialApp(home: const PageA()));

// --------------------------------------- PAGE A --------------------------------------------
class PageA extends StatefulWidget {
  const PageA({super.key});

  @override
  State<PageA> createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  DisposeInlineNotifier? disposer;

  @override
  void initState() {
    super.initState();

    // REGISTER A NOTIFIER.
    disposer = InlineNotifier.registerNotifier("MY_CUSTOM_KEY_NAME", (p0) => sampleSnackbar());
  }

  // CALLABLE.
  void sampleSnackbar() {
    final snackBar = SnackBar(content: const Text('Yay! A Notifier update SnackBar work!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    // DISPOSE IT.
    // It importent to avoid call error.
    disposer?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("UPDATE NOTIFIER (A)"),
            SizedBox(height: 9),

            // GOTO PAGE B.
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PageB()));
              },
              child: Text("Open page (B)"),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------- PAGE B --------------------------------------------
class PageB extends StatefulWidget {
  const PageB({super.key});

  @override
  State<PageB> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UPDATE NOTIFIER (B)")),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Notify page A to raise the snackbar."),
            SizedBox(height: 9),

            // NOTIFY.
            ElevatedButton(
              onPressed: () {
                // NOTIFY A NOTIFIER ON PAGE (A).
                InlineNotifier.notify("MY_CUSTOM_KEY_NAME");
              },
              child: Text("Notify (A)"),
            ),
          ],
        ),
      ),
    );
  }
}
