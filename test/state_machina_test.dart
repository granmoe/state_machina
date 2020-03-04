import 'package:test/test.dart';
import 'package:state_machina/state_machina.dart';

class States {
  static final String enteringEmail = 'enteringEmail';
  static final String sendingEmail = 'sendingEmail';
  static final String success = 'success';
}

void main() {
  group('Initializing a new StateMachine', () {
    test(
        'Returns a StateMachine with initial state defaulted to first stateMap entry when initialState is not passed',
        () {
      var state = StateMachine({
        States.enteringEmail: [States.sendingEmail],
        States.sendingEmail: [States.success],
        States.success: [],
      });

      expect(state is StateMachine, equals(true));
      expect(state.current, equals(States.enteringEmail));
    });

    test(
        'Returns a StateMachine with initial state set to the initialState when initialState is passed',
        () {
      var state = StateMachine({
        States.enteringEmail: [States.sendingEmail],
        States.sendingEmail: [States.success],
        States.success: [],
      }, States.sendingEmail);

      expect(state is StateMachine, equals(true));
      expect(state.current, equals(States.sendingEmail));
    });

    // Exceptions
    test('Throws an error when an initialState that does not exist is passed',
        () {
      try {
        expect(
            () => StateMachine({
                  States.enteringEmail: [States.sendingEmail],
                  States.sendingEmail: [States.success],
                  States.success: [],
                }, 'this does not exist'),
            throwsArgumentError);
      } finally {}
    });

    test(
        'Throws an error when stateMap contains any key (aside from first key) not used as a next state for any other state.',
        () {
      expect(
          () => StateMachine({
                States.enteringEmail: [States.sendingEmail],
                States.sendingEmail: [States.success],
                'this state cannot be reached': [],
              }),
          throwsArgumentError);
    });

    test(
        'Throws an error when stateMap contains any next state not present as a key in stateMap.',
        () {
      expect(
          () => StateMachine({
                States.enteringEmail: ['this does not exist'],
                States.sendingEmail: [States.success],
                States.success: []
              }),
          throwsArgumentError);
    });
  });

  group('Changing state', () {
    test('Changes to a valid next state', () {
      var state = StateMachine({
        States.enteringEmail: [States.sendingEmail],
        States.sendingEmail: [States.success],
        States.success: [],
      });

      state.changeTo(States.sendingEmail);

      expect(state.current, equals(States.sendingEmail));
    });

    test('Throws an error when changing to a state that does not exist', () {
      var state = StateMachine({
        States.enteringEmail: [States.sendingEmail],
        States.sendingEmail: [States.success],
        States.success: [],
      });

      expect(() => state.changeTo('this does not exist'), throwsArgumentError);
    });

    test(
        'Throws an error when changing to a state that is not a valid next state for the current state',
        () {
      var state = StateMachine({
        States.enteringEmail: [States.sendingEmail],
        States.sendingEmail: [States.success],
        States.success: [],
      });

      expect(() => state.changeTo(States.success), throwsArgumentError);
    });
  });
}
