# State Machina 🤖

A super simple state machine for Flutter and other Dart apps.

## Usage

```dart
import 'package:state_machina/state_machina.dart';

// Define your states in a handy class for easy reference:
class States {
  static final String enteringEmail = 'enteringEmail';
  static final String sendingEmail = 'sendingEmail';
  static final String success = 'success';
}

// Create a state machine like so:
var state = StateMachine({
  States.enteringEmail: [States.sendingEmail],
  States.sendingEmail: [States.success],
  States.success: [],
});
```

Now you can read the current state:

```dart
// in some Flutter widget
if (state.current == States.success) return SuccessMessage()
```

And change the state:

```dart
// somewhere in your Flutter app...
RaisedButton(
  onPressed: () async {
    try {
      setState(() {
        state.changeTo(States.sendingEmail);
      });

      await _sendEmail();

      setState(() {
        state.changeTo(States.success);
      });
    } catch (e) {
      ...
    }
  },
  child: const Text('Submit')
)
```

## Additional Details

- You may pass an optional initialState string as the second argument (positional). If not, the initial state defaults to the key of the first entry in the state map.
- Runtime exceptions will be thrown if you pass in an invalid state map (unreachable states, next states that don't exist) or an invalid initial state, or if you attempt to change to a state that doesn't exist or isn't a valid next state for the current state.

## API

StateMachine Function(Map<String, List<String>> stateMap, [String initialState])

## Installation

### Add the dependency

Add the package as a dependency in pubspec.yaml file:

```yaml
dependencies:
  state_machina: 1.0.1
```

### Install

You can install on the command line via pub:

```sh
$ pub get
```

or via flutter:

```sh
$ flutter pub get
```

Your editor may automatically fetch pubspec.yaml dependencies when the file is updated. This is the case if you've installed Flutter support for VS Code. Consult your editor's documentation for details.

### Import

import 'package:state_machina/state_machina.dart';
