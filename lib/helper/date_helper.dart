import 'package:intl/intl.dart';

import 'app_string.dart';

class DateHelper {
  static String misDateFormat = 'dd/MM/yyyy';
  static String dateFormat = 'dd-MM-yyyy';
  static String misDateTimeFormat = 'dd MMM hh:mm a';
  static String misServiceDateTimeFormat = 'dd/MM/yyyy HH:mm:ss';

  static String convertDateTimeToString({
    required DateTime dateTime,
    String? outputFormat,
  }) {
    try {
      outputFormat ??= misDateFormat;
      DateFormat outputFormatter = DateFormat(outputFormat);
      return outputFormatter.format(dateTime);
    } catch (e) {
      throw Exception('$dateFormattingErrorMsg: $e');
    }
  }

  static String formatToShortMonthDateYear(DateTime? dateTime) {
    try {
      if (dateTime == null || dateTime.year <= 0) {
        return "-- --- ----";
      }

      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (_) {
      return "-- --- ----";
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  static String convertDateString({
    required String dateString,
    String? inputFormat,
    String? outputFormat,
  }) {
    try {
      inputFormat ??= misDateFormat;
      outputFormat ??= misDateFormat;
      DateFormat inputFormatter = DateFormat(inputFormat);
      DateFormat outputFormatter = DateFormat(outputFormat);
      DateTime dateTime = inputFormatter.parse(dateString);
      return outputFormatter.format(dateTime);
    } catch (e) {
      throw Exception('$dateParsingErrorMsg: $e');
    }
  }

  static DateTime convertStringToDateTime({
    required String dateString,
    String? inputFormat,
  }) {
    try {
      inputFormat ??= misDateFormat;
      DateFormat inputFormatter = DateFormat(inputFormat);
      DateTime dateTime = inputFormatter.parse(dateString);
      return dateTime;
    } catch (e) {
      throw Exception('$dateParsingErrorMsg: $e');
    }
  }

  static DateTime convertStringToDateTimeWithSpecificFormat({
    required String dateString,
    required String inputFormat,
    required String outputFormat,
  }) {
    try {
      // Parsing the date string to DateTime using the input format
      DateFormat inputFormatter = DateFormat(inputFormat);
      DateTime dateTime = inputFormatter.parse(dateString);

      // Ensuring the DateTime corresponds to the output format
      DateFormat outputFormatter = DateFormat(outputFormat);
      String formattedDate = outputFormatter.format(dateTime);
      DateTime finalDateTime = outputFormatter.parse(formattedDate);

      return finalDateTime;
    } catch (e) {
      throw Exception('$dateParsingErrorMsg: $e');
    }
  }

  static String formatDateWithSuperscript(DateTime date) {
    String day = date.day.toString();
    String suffix = getDaySuffix(date.day);
    String month = getMonthAbbreviation(date.month);

    return "$day$suffix $month";
  }

  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return "th";
    }
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  static String getMonthAbbreviation(int month) {
    List<String> months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ];
    return months[month - 1];
  }

  String formatForApi(DateTime date) {
    String y = date.year.toString();
    String m = date.month.toString().padLeft(2, '0');
    String d = date.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  String formatForUi(String date) {
    try {
      // Handle invalid zero date explicitly
      if (date == "0000-00-00" || date.trim().isEmpty) {
        return "----/--/--";
      }

      final parsedDate = DateTime.parse(date);

      return "${parsedDate.year.toString().padLeft(4, '0')}/"
          "${parsedDate.month.toString().padLeft(2, '0')}/"
          "${parsedDate.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return "----/--/--";
    }
  }

  DateTime? formatApiToDateTime(String? date) {
    if (date == null || date.trim().isEmpty) return null;

    try {
      return DateTime.parse(date); // expects yyyy-MM-dd
    } catch (_) {
      return null;
    }
  }

  String formatTimeForUi(String value) {
    if (value.isEmpty) return "00:00";

    final parts = value.split('.');

    final hours = parts.isNotEmpty ? parts[0].padLeft(2, '0') : "00";
    final minutes =
        parts.length > 1 ? parts[1].padRight(2, '0').substring(0, 2) : "00";

    return "$hours:$minutes";
  }
}
