import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pallinet/constants.dart';

import 'models/patient_model.dart';

timestampToDate(time) {
  Timestamp t = time as Timestamp;
  return t.toDate();
}

emailValidation(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);
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
  if (value.runtimeType == Gender ||
      value.runtimeType == PatientID ||
      value.runtimeType == ServiceType) {
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

timeValidationStart(value, date, totalTimes, TextEditingController controller) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  } else {
    try {
      DateFormat format = DateFormat("h:mm aa");
      DateTime time1 = format.parseStrict(value);
      DateTime time2 = format.parseStrict(controller.text);
      DateTime startTime = combinedDateTime(date, time1);
      DateTime endTime = combinedDateTime(date, time2);

      if (startTime.isBefore(DateTime.now())) {
        return "Invalid time";
      }

      if (startTime.isAfter(endTime)) {
        return "Invalid time";
      }

      if (endTime.isBefore(startTime)) {
        return "Invalid time";
      }

      List totalStart = totalTimes.map((e) => e["timeStart"]).toList();
      List totalEnd = totalTimes.map((e) => e["timeEnd"]).toList();

      for (int i = 0; i < totalTimes.length; i++) {
        // if start is inside an existing appointment block
        if (startTime.isAfter(totalStart[i]) &&
            startTime.isBefore(totalEnd[i])) {
          return "Overlapping appt time";
        }
        // if start and end overlap an existing appointment block
        if (startTime.isBefore(totalStart[i]) && endTime.isAfter(totalEnd[i])) {
          return "Overlapping appt times";
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return "Invalid time";
    }
  }
}

timeValidationEnd(value, date, totalTimes, TextEditingController controller) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  } else {
    try {
      DateFormat format = DateFormat("h:mm aa");
      DateTime time1 = format.parseStrict(value);
      DateTime time2 = format.parseStrict(controller.text);
      DateTime endTime = combinedDateTime(date, time1);
      DateTime startTime = combinedDateTime(date, time2);

      if (endTime.isBefore(DateTime.now())) {
        return "Invalid time";
      }

      if (startTime.isAfter(endTime)) {
        return "Invalid time";
      }

      if (endTime.isBefore(startTime)) {
        return "Invalid time";
      }

      List totalStart = totalTimes.map((e) => e["timeStart"]).toList();
      List totalEnd = totalTimes.map((e) => e["timeEnd"]).toList();

      for (int i = 0; i < totalTimes.length; i++) {
        // if end is inside an existing appointment block
        if (endTime.isAfter(totalStart[i]) && endTime.isBefore(totalEnd[i])) {
          return "Overlapping appt time";
        }
        // if the current appointment completely overlaps an existing appointment block
        if (startTime.isBefore(totalStart[i]) && endTime.isAfter(totalEnd[i])) {
          return "Overlapping appt times";
        }
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
  return DateTime(
      date.year, date.month, date.day, time.hour, time.minute, time.second);
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

refresh(setState) {
  setState(() {});
}
