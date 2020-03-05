class StateMachine {
  dynamic current;

  Map<dynamic, _State> _statesMap = Map();
  Set<dynamic> _stateKeys = Set();
  Set<dynamic> _stateValues = Set();
  _State _currentState;
  Set<dynamic> _nextStates = Set();

  StateMachine(Map<dynamic, List<dynamic>> stateMap, [dynamic initialState]) {
    for (MapEntry<dynamic, List<dynamic>> state in stateMap.entries) {
      _statesMap[state.key] = _State(state.key, state.value);
      _stateKeys.add(state.key);
      _stateValues.addAll(state.value);
    }

    dynamic initialStateName = initialState ?? _statesMap.keys.first;
    var stateForInitialStateName = _statesMap[initialStateName];

    if (stateForInitialStateName == null) {
      throw ArgumentError(
          "No state exists for the initial state '$initialStateName'. Please check the initialState field of your StateMachineDefinition and try again.");
    }

    _currentState = stateForInitialStateName;
    _nextStates = _currentState.nextStates;
    current = _currentState.name;

    for (var stateName in _stateKeys.skip(1)) {
      if (!_stateValues.contains(stateName)) {
        throw ArgumentError(
            'State $stateName cannot be entered since it is not the first entry in the state map, and it does not occur as a next state for any other state.');
      }
    }

    for (dynamic stateName in _stateValues) {
      if (!_stateKeys.contains(stateName)) {
        throw ArgumentError(
            'State $stateName is used as a next state in stateMap but does not exist as a key in stateMap.');
      }
    }
  }

  changeTo(dynamic stateName) {
    _State _nextState = _statesMap[stateName];

    if (_nextState == null) {
      throw ArgumentError(
          'Cannot change to state $stateName because it is not a key in the stateMap.');
    }

    if (!_nextStates.contains(stateName)) {
      throw ArgumentError(
          'State $stateName is not a valid next state for current state $current.');
    }

    current = stateName;
    _currentState = _nextState;
    _nextStates = _currentState.nextStates;
  }
}

class _State {
  dynamic name;
  Set<dynamic> nextStates = Set();

  _State(dynamic stateName, List<dynamic> nextStatesList) {
    name = stateName;
    if (nextStatesList != null) {
      nextStates.addAll(nextStatesList);
    }
  }
}

bool isStringOrInt(dynamic value) {
  return value is String || value is int;
}
