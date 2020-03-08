import 'dart:mirrors';

/// A simple state machine class that allows easily creating a FSM based on a state map and optional initial state, validating the correctness of both, and handles events, updating the current state per the state map.
class StateMachine {
  /// The current state
  dynamic current;

  Map<dynamic, Map<dynamic, dynamic>> _stateMap = Map();
  Set<dynamic> _stateKeys = Set();
  Set<dynamic> _stateValues = Set();
  Set<dynamic> _eventIds = Set();

  List<Function> _listeners = [];

  /// Returns a finite state machine based on [stateMap] and optional [initialState].
  ///
  /// Throws [ArgumentError] if the [stateMap] is not valid (unreachable or non-existent states).
  /// Throws [ArgumentError] if [initialState] is not found in [stateMap].
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

    for (dynamic stateName in _stateKeys) {
      if (!_isStringOrEnum(stateName)) {
        print(stateName);
        throw ArgumentError(
            'All key and value primitives in your state map must be either String or int');
      }
    }

    for (dynamic stateValue in _stateValues) {
      if (!_isStringOrEnum(stateValue)) {
        print(stateValue);
        throw ArgumentError(
            'All key and value primitives in your state map must be either String or int');
      }
    }

    for (dynamic eventName in _eventIds) {
      if (!_isStringOrEnum(eventName)) {
        print(eventName);
        throw ArgumentError(
            'All key and value primitives in your state map must be either String or int');
      }
    }
  }

  /// Sends [eventId] into the state machine and optionally transitions to the next state based on the state map.
  ///
  /// Throws [ArgumentError] if [eventId] is not found in [stateMap].
  void send(dynamic eventId) {
    if (!_eventIds.contains(eventId)) {
      throw ArgumentError(
          'Received an unknown event: $eventId. Only events present in the state map may be sent.');
    }

    dynamic previous = current;

    if (_stateMap[current].isNotEmpty) {
      current = _stateMap[current][eventId];
    }

    for (var func in _listeners) {
      func(current, previous, eventId);
    }
  }

  /// Register a listener to be called after each send is resolved
  /// Listener is called with listener(current, previous, event)
  void addListener(
      Function(dynamic current, dynamic previous, dynamic event) listener) {
    _listeners.add(listener);
  }

  /// Remove a previously registered closure from the list of listeners
  void removeListener(
      Function(dynamic current, dynamic previous, dynamic event) listener) {
    _listeners.remove(listener);
  }
}

bool _isStringOrEnum(dynamic value) {
  InstanceMirror instanceMirror = reflect(value);
  return value is String || instanceMirror.type.isEnum;
}
