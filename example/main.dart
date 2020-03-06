import 'package:state_machina/state_machina.dart';

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
  var state = StateMachine(stateMap);

  print('state.current: ${state.current}\n'); // States.editingEmail

  var stateWithCustomInitialState = StateMachine(stateMap, States.sendingEmail);

  print(
      'stateWithCustomInitialState.current: ${stateWithCustomInitialState.current}\n'); // States.sendingEmail

// Back to our first state machine...
  print('Sending event ${Events.sendEmail} to "state"\n');
  state.send(Events.sendEmail);

  print('state.current: ${state.current}'); // States.sendingEmail
}
