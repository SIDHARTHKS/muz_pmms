import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/home_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import '../widget/common_widget.dart';

class NotificationScreen extends AppBaseView<HomeController> {
  const NotificationScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
            () => controller.fetchInitData(), (context, snapshot) => _body(),
            loaderWidget: fullScreenloader()),
      );
  Scaffold _body() {
    return appScaffold(
      appBar: customAppBar(
        notification.tr,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 15),
              child: appText(clearAll.tr,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColorHelper().primaryColor.withValues(alpha: 0.9)),
            ),
          )
        ],
      ),
      body: appContainer(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColorHelper().cardColor,
                  borderRadius: BorderRadius.circular(5),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade200,
                  //     blurRadius: 6,
                  //     spreadRadius: 1,
                  //   ),
                  // ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left icon
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: item.isApproved
                          ? Image.asset(
                              Assets.icons.completed.path,
                              scale: 4,
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.purple.shade50,
                              child: Text(
                                'm',
                                style: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
                    width(12),
                    // Main content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${item.title} : ${item.token}, ',
                                  style: textStyle(
                                      13,
                                      AppColorHelper().primaryTextColor,
                                      FontWeight.w500,
                                      height: 1.6),
                                ),
                                TextSpan(
                                  text: item.message,
                                  style: textStyle(
                                      13,
                                      AppColorHelper()
                                          .primaryTextColor
                                          .withValues(alpha: 0.7),
                                      FontWeight.w400,
                                      height: 1.6),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          height(2),
                          if (item.status.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: appText(
                                item.status,
                                fontSize: 10,
                                color: AppColorHelper().primaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          height(10),
                          Row(
                            children: [
                              // appText(
                              //   item.date,
                              //   fontSize: 11,
                              //   fontWeight: FontWeight.w400,
                              //   color: AppColorHelper()
                              //       .primaryTextColor
                              //       .withValues(alpha: 0.6),
                              // ),
                              buildSuperscriptDate(
                                  item.date,
                                  AppColorHelper()
                                      .primaryTextColor
                                      .withValues(alpha: 0.6)),
                              if (item.category.isNotEmpty) ...[
                                width(8),
                                Icon(Icons.circle,
                                    size: 8,
                                    color: AppColorHelper().primaryColor),
                                width(4),
                                appText(item.category,
                                    fontSize: 11,
                                    color: AppColorHelper()
                                        .primaryTextColor
                                        .withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w400),
                              ],
                              const Spacer(),
                              if (item.priority.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(item.priority)
                                        .withValues(alpha: 0.30),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: appText(
                                    item.priority,
                                    fontSize: 12,
                                    color: _getPriorityTextColor(item.priority),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        //  _emptyNotificationsScreen()
      ),
    );
  }

  Stack _emptyNotificationsScreen() {
    return Stack(
      children: [
        Positioned(
            top: Get.height * 0.31,
            left: 0,
            right: 0,
            child: Center(
                child: Column(
              children: [
                Image.asset(
                  Assets.icons.noNotification.path,
                  scale: 4,
                ),
                height(20),
                appText(noNotification.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                height(8),
                SizedBox(
                  width: 250,
                  child: appText(noNotificationDialogue.tr,
                      textAlign: TextAlign.center,
                      color: AppColorHelper().primaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                )
              ],
            )))
      ],
    );
  }

  Widget buildSuperscriptDate(String dateString, Color color) {
    // Split the input string into day, month, and year parts
    final parts = dateString.split(' ');
    if (parts.length < 3) return Text(dateString); // fallback

    final dayPart = parts[0];
    final month = parts[1];
    final year = parts[2];

    // Separate numeric day and suffix (e.g., 4th → 4 + th)
    final day = dayPart.replaceAll(RegExp(r'[^0-9]'), '');
    final suffix = dayPart.replaceAll(RegExp(r'[0-9]'), '');

    return RichText(
      text: TextSpan(
        style: textStyle(
          11,
          color,
          FontWeight.w400,
        ),
        children: [
          TextSpan(text: day),
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Transform.translate(
              offset: const Offset(1, -2), // 👈 pushes suffix upward
              child: Text(
                suffix,
                textScaleFactor: 0.7, // 👈 smaller text
                style: textStyle(
                  10,
                  color,
                  FontWeight.w400,
                ),
              ),
            ),
          ),
          TextSpan(text: ' $month $year'),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return AppColorHelper().statusHighColor;
      case "medium":
        return AppColorHelper().statusMediumColor;
      case "low":
        return AppColorHelper().statusLowColor;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return AppColorHelper().statusHighTextColor;
      case "medium":
        return AppColorHelper().statusMediumTextColor;
      case "low":
        return AppColorHelper().statusLowTextColor;
      default:
        return Colors.grey;
    }
  }
}
