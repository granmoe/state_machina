class StateMachine {
  dynamic current;

  Map<dynamic, Map<dynamic, dynamic>> _stateMap = Map();
  Set<dynamic> _stateKeys = Set();
  Set<dynamic> _stateValues = Set();
  Set<dynamic> _eventIds = Set();

  StateMachine(Map<dynamic, Map<dynamic, dynamic>> stateMap,
      [dynamic initialState]) {
    for (MapEntry<dynamic, Map<dynamic, dynamic>> state in stateMap.entries) {
      _stateKeys.add(state.key);
      _stateValues.addAll(state.value.values);
      _eventIds.addAll(state.value.keys);
    }

    _stateMap = stateMap;

    if (initialState == null) {
      current = _stateMap.keys.first;
    } else {
      if (!_stateKeys.contains(initialState)) {
        throw ArgumentError("No state exists for initialState $initialState");
      }

      current = initialState;
    }

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

  send(dynamic eventId) {
    if (!_eventIds.contains(eventId)) {
      throw ArgumentError(
          'Received an unknown event: $eventId. Only events present in the state map may be sent.');
    }

    current = _stateMap[current][eventId];
  }
}

bool isStringOrInt(dynamic value) {
  return value is String || value is int;
}
