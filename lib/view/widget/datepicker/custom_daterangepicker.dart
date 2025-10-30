import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/sizer.dart';
import '../common_widget.dart';

/// Opens the custom date range picker in a bottom sheet and returns the selected range.
Future<DateTimeRange?> showCustomDateRangePicker(
  BuildContext context, {
  required Color primaryColor,
  required Color backgroundColor,
  required Color textColor,
  DateTimeRange? initialRange,
}) async {
  DateTimeRange? selectedRange;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.86,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: CustomDaterangepicker(
            primaryColor: primaryColor,
            backgroundColor: backgroundColor,
            textColor: textColor,
            initialRange: initialRange,
            onRangeSelected: (range) {
              selectedRange = range;
            },
          ),
        ),
      );
    },
  );

  return selectedRange;
}

class CustomDaterangepicker extends StatefulWidget {
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final ValueChanged<DateTimeRange> onRangeSelected;
  final DateTimeRange? initialRange;

  const CustomDaterangepicker({
    super.key,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.onRangeSelected,
    this.initialRange,
  });

  @override
  State<CustomDaterangepicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDaterangepicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    if (widget.initialRange != null) {
      _startDate = widget.initialRange!.start;
      _endDate = widget.initialRange!.end;
    }
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final daysBefore = first.weekday % 7;
    final daysAfter = 6 - last.weekday % 7;

    return [
      for (int i = -daysBefore; i < last.day + daysAfter; i++)
        DateTime(month.year, month.month, 1 + i)
    ];
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day) {
    if (_startDate == null || _endDate == null) return false;
    return day.isAfter(_startDate!) && day.isBefore(_endDate!);
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = day;
        _endDate = null;
      } else if (_startDate != null && _endDate == null) {
        if (day.isAfter(_startDate!)) {
          _endDate = day;
        } else {
          _startDate = day;
          _endDate = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = List.generate(
      12,
      (i) => DateTime(_currentMonth.year, _currentMonth.month + i),
    );

    return Column(
      children: [
        height(8),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                "Choose Date",
                fontSize: 17,
                color: AppColorHelper().primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColorHelper().primaryColor,
                ),
                child: iconWidget(
                  Icons.close,
                  color: AppColorHelper().textColor,
                  onPressed: goBack,
                ),
              ),
            ],
          ),
        ),

        // Calendar
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: months.map((month) {
                final days = _getDaysInMonth(month);

                // Split days into weeks (rows of 7)
                List<List<DateTime>> weeks = [];
                for (int i = 0; i < days.length; i += 7) {
                  weeks.add(days.sublist(i, (i + 7).clamp(0, days.length)));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(4),
                    appText(
                      DateFormat.yMMMM().format(month),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                    ),
                    height(15),

                    // Weekdays
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat'
                      ]
                          .map((e) => Expanded(
                                child: Center(
                                  child: appText(
                                    e,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        widget.textColor.withValues(alpha: 0.4),
                                    fontSize: 13,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    divider(
                        color: AppColorHelper()
                            .dividerColor
                            .withValues(alpha: 0.15)),
                    height(6),

                    // Weeks
                    Column(
                      children: weeks.map((week) {
                        return Stack(
                          children: [
                            // Background bar for in-range days with rounded edges for first and last in range
                            Row(
                              children: week.map((day) {
                                final isInRange = _isInRange(day);
                                final isStart = _startDate != null &&
                                    _isSameDay(day, _startDate!);
                                final isEnd = _endDate != null &&
                                    _isSameDay(day, _endDate!);

                                // Decide border radius for first and last in-range days of the week
                                BorderRadius radius = BorderRadius.zero;
                                if (isStart && isEnd) {
                                  radius = BorderRadius.circular(8);
                                } else if (isStart) {
                                  radius = const BorderRadius.horizontal(
                                      left: Radius.circular(100));
                                } else if (isEnd) {
                                  radius = const BorderRadius.horizontal(
                                      right: Radius.circular(100));
                                } else if (isInRange) {
                                  radius = BorderRadius.zero;
                                }

                                //top container

                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 5.0,
                                        left: isStart ? 8.0 : 0.0,
                                        right: isEnd ? 8.0 : 0.0),
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: ((isStart || isEnd || isInRange) &&
                                              _startDate != null &&
                                              _endDate != null)
                                          ? widget.primaryColor
                                              .withOpacity(0.25)
                                          : Colors.transparent,
                                      borderRadius: radius,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            // Day squares with start/end rounded corners
                            Row(
                              children: week.map((day) {
                                final isSameMonth =
                                    day.month == _currentMonth.month;
                                final isStart = _startDate != null &&
                                    _isSameDay(day, _startDate!);
                                final isEnd = _endDate != null &&
                                    _isSameDay(day, _endDate!);

                                return Expanded(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: isSameMonth
                                          ? () => _onDayTap(day)
                                          : null,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        height: 37,
                                        width: 37,
                                        decoration: BoxDecoration(
                                          color: isStart || isEnd
                                              ? widget.primaryColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.horizontal(
                                            left: isStart || isEnd
                                                ? const Radius.circular(4)
                                                : Radius.zero,
                                            right: isStart || isEnd
                                                ? const Radius.circular(4)
                                                : Radius.zero,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: appText(
                                          '${day.day}',
                                          fontSize: 13,
                                          fontWeight: isStart || isEnd
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: isSameMonth
                                              ? (isStart || isEnd
                                                  ? AppColorHelper().textColor
                                                  : widget.textColor)
                                              : widget.textColor
                                                  .withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    height(20),
                  ],
                );
              }).toList(),
            ),
          ),
        ),

        // Buttons
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
          child: Row(
            children: [
              Expanded(
                child: buttonContainer(
                  color: AppColorHelper().primaryColor,
                  onPressed: (_startDate != null && _endDate != null)
                      ? () {
                          final range =
                              DateTimeRange(start: _startDate!, end: _endDate!);
                          widget.onRangeSelected(range);
                          Navigator.pop(context);
                        }
                      : null,
                  appText(applyDate.tr, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
