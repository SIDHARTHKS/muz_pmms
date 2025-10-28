import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import 'package:table_calendar/table_calendar.dart'; // Add this package

class CustomDatePicker extends StatefulWidget {
  final String label;
  final bool isRequired;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final String? hintText;
  final double? widgetHeight;

  // Additional customization
  final ButtonStyle? okButtonStyle;
  final ButtonStyle? cancelButtonStyle;
  final TextStyle? dateTextStyle;
  final TextStyle? labelTextStyle;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.onDateChanged,
    this.selectedDate,
    this.isRequired = false,
    this.hintText,
    this.widgetHeight,
    this.okButtonStyle,
    this.cancelButtonStyle,
    this.dateTextStyle,
    this.labelTextStyle,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  bool _isOpen = false;
  late TextEditingController _controller;
  DateTime? _pickedDate;
  DateTime _focusedDay =
      DateTime.now(); // Add this in your _CustomDatePickerState

  @override
  void initState() {
    super.initState();
    _pickedDate = widget.selectedDate;
    _focusedDay = widget.selectedDate ?? DateTime.now(); // initialize
    _controller = TextEditingController(
      text: _pickedDate != null
          ? DateFormat('dd/MM/yyyy').format(_pickedDate!)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _pickedDate = widget.selectedDate;
      _controller.text = widget.selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(widget.selectedDate!)
          : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorHelper();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            width(2),
            appText(
              widget.label,
              fontSize: 13,
              color: colors.lightTextColor,
              fontWeight: FontWeight.w400,
            ),
            if (widget.isRequired)
              appText(
                " *",
                color: Colors.red,
                fontSize: 18,
              ),
          ],
        ),
        height(2),

        // Date Field Box
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: widget.widgetHeight ?? 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isOpen
                  ? colors.primaryColor.withOpacity(0.8)
                  : colors.borderColor.withOpacity(0.4),
              width: _isOpen ? 1.2 : 1,
            ),
            boxShadow: _isOpen
                ? [
                    BoxShadow(
                      color: colors.primaryColor.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: InkWell(
            onTap: () => _showCustomCalendar(context),
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date text or hint
                appText(
                  _controller.text.isNotEmpty
                      ? _controller.text
                      : (widget.hintText ?? "Select ${widget.label}"),
                  color: _controller.text.isNotEmpty
                      ? colors.primaryTextColor
                      : Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),

                // Calendar icon with animation
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    Assets.icons.calander.path,
                    scale: 4.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomCalendar(BuildContext context) async {
    setState(() => _isOpen = true);
    final colors = AppColorHelper();

    DateTime? tempPickedDate = _pickedDate;
    DateTime tempFocusedDay = _focusedDay;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TableCalendar(
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    focusedDay: tempFocusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(tempPickedDate, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setModalState(() {
                        tempPickedDate = selectedDay;
                        tempFocusedDay = focusedDay;
                      });
                    },
                    headerStyle: HeaderStyle(
                      headerMargin: const EdgeInsets.only(bottom: 25.0),
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: textStyle(
                        15,
                        colors.textColor,
                        FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: colors.cardColor),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: colors.cardColor),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: colors.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: colors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle:
                          TextStyle(color: colors.primaryTextColor),
                      weekendTextStyle:
                          TextStyle(color: colors.primaryTextColor),
                    ),
                  ),
                  height(16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Cancel Button
                        TextButton(
                          style: widget.cancelButtonStyle ??
                              TextButton.styleFrom(
                                foregroundColor: colors.primaryColor,
                                backgroundColor: AppColorHelper()
                                    .primaryColor
                                    .withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: AppColorHelper()
                                          .primaryColor
                                          .withValues(alpha: 0.9)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: appText("Cancel",
                                fontWeight: FontWeight.w500,
                                color: AppColorHelper().primaryColor),
                          ),
                        ),
                        width(8),
                        // OK Button
                        ElevatedButton(
                          style: widget.okButtonStyle ??
                              ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: colors.primaryColor,
                                foregroundColor: colors.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          onPressed: () {
                            if (tempPickedDate != null) {
                              setState(() {
                                _pickedDate = tempPickedDate;
                                _focusedDay = tempFocusedDay;
                                _controller.text = DateFormat('dd/MM/yyyy')
                                    .format(_pickedDate!);
                              });
                              widget.onDateChanged(_pickedDate);
                            }
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: appText("OK",
                                color: AppColorHelper().textColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    setState(() => _isOpen = false);
  }
}
