// normal double parser
double doubleParser(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is num) {
    return value.toDouble();
  } else {
    throw Exception('Invalid double value');
  }
}

/// simple caster used to cast dynamic to any needed type safely
T asType<T, F>(F object, [T Function(dynamic)? possibleConverter]) {
  if (object is T) {
    return object;
  }
  if (possibleConverter != null) {
    try {
      return possibleConverter(object);
    } catch (e) {
      throw Exception(
        'Given converter is not working on this object of type : ${object.runtimeType}',
      );
    }
  } else {
    throw Exception(
      'Object\'s value is not of type $T try passing a converter for ${object.runtimeType}',
    );
  }
}
