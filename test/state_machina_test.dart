import 'package:test/test.dart';
import 'package:state_machina/state_machina.dart';

// FIXME: Easy way to run all tests for both enum and class States and Events
// A simple for-loop didn't work

// class States {
//   static final String editingEmail = 'editingEmail';
//   static final String sendingEmail = 'sendingEmail';
//   static final String success = 'success';
// }

enum States { editingEmail, sendingEmail, success, error }
enum Events { editEmail, sendEmail, sentEmail, failedToSendEmail }

var stateMap = {
  States.editingEmail: {Events.sendEmail: States.sendingEmail},
  States.sendingEmail: {
    Events.sentEmail: States.success,
    Events.failedToSendEmail: States.error,
  },
  States.success: {},
  States.error: {Events.editEmail: States.editingEmail}
};

void main() {
  group('Initializing a new StateMachine', () {
    test(
        'Returns a StateMachine with initial state defaulted to first stateMap entry when initialState is not passed',
        () {
      var state = StateMachine(stateMap);

      expect(state is StateMachine, equals(true));
      expect(state.current, equals(States.editingEmail));
    });

    test(
        'Returns a StateMachine with initial state set to the initialState when initialState is passed',
        () {
      var state = StateMachine(stateMap, States.sendingEmail);

      expect(state is StateMachine, equals(true));
      expect(state.current, equals(States.sendingEmail));
    });

    // Exceptions
    test('Throws an error when an initialState that does not exist is passed',
        () {
      try {
        expect(() => StateMachine(stateMap, 'this does not exist'),
            throwsArgumentError);
      } finally {}
    });

    test(
        'Throws an error when stateMap contains any key (aside from first key) not used as a next state for any other state.',
        () {
      expect(
          () => StateMachine({
                States.editingEmail: {Events.sendEmail: States.sendingEmail},
                States.sendingEmail: {
                  Events.sentEmail: States.success,
                  Events.failedToSendEmail: States.error,
                },
                States.success: {},
                'this state cannot be reached': {
                  Events.editEmail: States.editingEmail
                }
              }),
          throwsArgumentError);
    });

    test(
        'Throws an error when stateMap contains any next state not present as a key in stateMap.',
        () {
      expect(
          () => StateMachine({
                States.editingEmail: {
                  Events.sendEmail: 'this state does not exist'
                },
                States.sendingEmail: {
                  Events.sentEmail: States.success,
                  Events.failedToSendEmail: States.error,
                },
                States.success: {},
                States.error: {Events.editEmail: States.editingEmail}
              }),
          throwsArgumentError);
    });
  });

  group('Changing state', () {
    test('Changes to a valid next state', () {
      var state = StateMachine(stateMap);

      state.send(Events.sendEmail);

      expect(state.current, equals(States.sendingEmail));
    });

    test('Throws an error when an unknown event is sent', () {
      var state = StateMachine(stateMap);

      expect(() => state.send('this does not exist'), throwsArgumentError);
    });
  });
}
