# State Machina [steyt *mah*-kuh-nuh] 🤖

A super simple, zero dependency, tiny state machine for Flutter and other Dart apps.

## Basic Usage

```dart
import 'package:state_machina/state_machina.dart';

// Define your states and events in a couple of handy enums for easy reference:
enum States { enteringEmail, sendingEmail, success }
enum Events { editEmail, sendEmail, sentEmail, failedToSendEmail }

// Create a state machine like so:
var state = StateMachine({
  States.editingEmail: {Events.sendEmail: States.sendingEmail},
  States.sendingEmail: {
    Events.sentEmail: States.success,
    Events.failedToSendEmail: States.error,
  },
  States.success: {}, // This is a terminal state--no other states can be entered once we get here ☠️
  States.error: {Events.editEmail: States.editingEmail}
});
```

Now you can read the current state:

```dart
// in some Flutter widget
if (state.current == States.success) return SuccessMessage()
```

And send events:

```dart
// somewhere in your Flutter app...
RaisedButton(
  onPressed: () async {
    try {
      setState(() {
        state.send(Events.sendEmail);
      });

      await _sendEmail();

      setState(() {
        state.send(Events.sentEmail);
      });
    } catch (e) {
      state.send(Events.failedToSendEmail);
    }
  },
  child: const Text('Submit')
)
```

- You may pass an optional initialState as the second argument. If not, the initial state defaults to the key of the first entry in the state map.
- Runtime exceptions will be thrown if you pass in an invalid state map (unreachable states, next states that don't exist) or an invalid initial state, or if you send an event that doesn't exist in the state map.
- The type of individual states can be anything: String, int, object. You simply have to ensure that your state map is valid (you'll get helpful error messages if it isn't).
- You could also store your states and events in classes, if desired:

```dart
class States {
  static final String enteringEmail = 'enteringEmail';
  static final String sendingEmail = 'sendingEmail';
  static final String success = 'success';
}
```

And for that matter, nothing is stopping you from passing in literal values:

```dart
var state = StateMachine({
  'editingEmail': {'sendEmail': 'sendingEmail'},
  'sendingEmail': {
    'sentEmail': 'success',
    'failedToSendEmail': 'error',
  },
  'success': {},
  'error': {'editEmail': 'editingEmail'}
});
```

Typically, strings or enums are the most useful types for the primitive keys and values in your state map.

## Listeners

Listeners can be registered and will be called every time `send` is called, after `send` resolves the event and updates the current state. Listeners receive the current state, previous state, and event that triggered the listener:

```dart
  state.addListener((current, previous, event) {
    // Do some cool stuff here
  })
```
