import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/text/app_text.dart';

class TlTokenView extends AppBaseView<TasksController> {
  const TlTokenView({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() => _body();

  GestureDetector _body() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: SizedBox(
        child: Column(
          children: [
            _listView(),
          ],
        ),
      ),
    );
  }

  Expanded _listView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            height(10),
            Obx(() {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.rxTokens.length,
                  itemBuilder: (context, index) {
                    final task = controller.rxTokens[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColorHelper().cardColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  capitalizeFirstOnly(task.requestType ?? "--"),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColorHelper().primaryTextColor),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(
                                          task.currentStatus ?? "--"),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: appText(
                                      capitalizeFirstOnly(
                                          task.currentStatus ?? "--"),
                                      color: AppColorHelper().textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  width(10),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: "5",
                                        style: textStyle(
                                            16,
                                            AppColorHelper().primaryTextColor,
                                            FontWeight.w600)),
                                    TextSpan(
                                        text: "/",
                                        style: textStyle(
                                            16,
                                            AppColorHelper()
                                                .primaryTextColor
                                                .withValues(alpha: 0.7),
                                            FontWeight.w600)),
                                    TextSpan(
                                        text: "12",
                                        style: textStyle(
                                            16,
                                            AppColorHelper()
                                                .primaryTextColor
                                                .withValues(alpha: 0.7),
                                            FontWeight.w600))
                                  ])),
                                ],
                              ),
                            ],
                          ),
                          height(18),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColorHelper().backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: AppColorHelper()
                                            .primaryTextColor
                                            .withValues(alpha: 0.5),
                                        fontSize: 13),
                                    children: [
                                      TextSpan(text: tokenId.tr),
                                      TextSpan(
                                        text: "TKN-${task.tokenId}",
                                        style: textStyle(
                                          14,
                                          AppColorHelper()
                                              .primaryTextColor
                                              .withValues(alpha: 0.9),
                                          FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getPriorityColor(
                                            task.priority ?? "Medium")
                                        .withValues(alpha: 0.30),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: appText(
                                    task.priority ?? "Medium",
                                    color: getPriorityTextColor(
                                        task.priority ?? "Medium"),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height(16),
                          appText(task.description ?? "--",
                              fontSize: 14,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                              color: AppColorHelper().primaryTextColor),
                          _divider(),
                          Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: controller
                                      .getHorizontalScrollController(index),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _infoColums(
                                          project.tr,
                                          capitalizeFirstOnly(
                                              task.projectName ?? "--")),
                                      width(40),
                                      _infoColums(
                                          module.tr,
                                          capitalizeFirstOnly(
                                              task.module ?? "--")),
                                      width(40),
                                      _infoColums(
                                          option.tr,
                                          capitalizeFirstOnly(
                                              task.optionName ?? "--")),
                                      width(40),
                                      _infoColums(
                                          assignee.tr,
                                          capitalizeFirstOnly(
                                              task.assignee ?? "--")),
                                      // width(40),
                                      // _infoColums(createdBy.tr, task),
                                      width(40),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(() {
                                return controller.hasOverflow(index).value
                                    ? Image.asset(
                                        Assets.icons.overflowRight.path,
                                        scale: 4,
                                      )
                                    : const SizedBox();
                              }),
                            ],
                          ),
                          height(18),
                          Row(
                            children: [
                              Expanded(
                                child: buttonContainer(
                                  height: 42,
                                  color: AppColorHelper()
                                      .primaryColorLight
                                      .withValues(alpha: 0.9),
                                  borderColor: AppColorHelper()
                                      .primaryColor
                                      .withValues(alpha: 0.8),
                                  width: 0.1,
                                  onPressed: () {
                                    controller.setTask(task);
                                    navigateTo(tlTaskDetailsPageRoute);
                                  },
                                  appText(viewToken.tr,
                                      color:
                                          AppColorHelper().secondaryTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            })
          ],
        ),
      ),
    );
  }

  Column _infoColums(String type, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(type,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColorHelper().primaryTextColor.withValues(alpha: 0.5)),
        SizedBox(
          width: 85,
          child: appText(name,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColorHelper().primaryTextColor,
              overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }

  Padding _divider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child:
          divider(color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
    );
  }
}
