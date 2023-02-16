import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pallinet/constants.dart';

import 'models/patient_model.dart';

emailValidation(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
  if (!emailValid) {
    return 'Please enter a valid email';
  }
  return null;
}

passwordValidation(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

passwordVerification(value, first) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  if (value != first) {
    return "Password does not match";
  }
  return null;
}

requiredValue(value) {
  if (value.runtimeType == Gender || value.runtimeType == PatientID || value.runtimeType == ServiceType) {
    return null;
  } else if (value == null || value.isEmpty) {
    return 'Required field';
  }
  return null;
}

birthdateValidation(value) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  } else {
    try {
      DateFormat format = DateFormat("MM/dd/yyyy");
      DateTime time = format.parseStrict(value);
      if (time.isAfter(DateTime.now())) {
        return "Invalid date";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "Invalid date";
    }
  }

  return null;
}

dateValidation(value) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  } else {
    try {
      DateFormat format = DateFormat("MM/dd/yyyy");
      DateTime time = format.parseStrict(value);

      DateTime now = DateTime.now();
      DateTime comparison = DateTime(now.year, now.month, now.day);
      if (time.isBefore(comparison)) {
        return "Invalid date";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "Invalid date";
    }
  }

  return null;
}

timeValidation(value, date) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  } else {
    try {
      DateFormat format = DateFormat("h:mm aa");
      DateTime time = format.parseStrict(value);

      DateTime combined = combinedDateTime(date, time);
      debugPrint(combined.toString());

      if (combined.isBefore(DateTime.now())) {
        return "Invalid time";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "Invalid time";
    }
  }
}

DateTime combinedDateTime(
  DateTime date,
  DateTime time,
) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second);
}

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String separator = '/';
    var text = _format(
      newValue.text,
      oldValue.text,
      separator,
    );

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(
        oldValue,
        text,
      ),
    );
  }

  String _format(
    String value,
    String oldValue,
    String separator,
  ) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;

    if (!isErasing && isComplete) {
      return oldValue;
    }

    value = value.replaceAll(separator, '');
    final result = <String>[];

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      result.add(value[i]);
      if ((i == 1 || i == 3) && i != value.length - 1) {
        result.add(separator);
      }
    }

    return result.join();
  }

  TextSelection updateCursorPosition(
    TextEditingValue oldValue,
    String text,
  ) {
    var endOffset = max(
      oldValue.text.length - oldValue.selection.end,
      0,
    );

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  static const _maxChars = 10;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String separator = '-';
    var text = _format(
      newValue.text,
      oldValue.text,
      separator,
    );

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(
        oldValue,
        text,
      ),
    );
  }

  String _format(
    String value,
    String oldValue,
    String separator,
  ) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;

    if (!isErasing && isComplete) {
      return oldValue;
    }

    value = value.replaceAll(separator, '');
    final result = <String>[];

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      result.add(value[i]);
      if ((i == 2 || i == 5) && i != value.length - 1) {
        result.add(separator);
      }
    }

    return result.join();
  }

  TextSelection updateCursorPosition(
    TextEditingValue oldValue,
    String text,
  ) {
    var endOffset = max(
      oldValue.text.length - oldValue.selection.end,
      0,
    );

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}
