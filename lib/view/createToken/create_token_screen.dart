import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/createToken/bottomsheet/generate_token_bottomsheet.dart';
import 'package:pmms/view/dialogues/token_generate_dialogue.dart';
import '../../controller/create_token_controller.dart';
import '../widget/common_widget.dart';

class CreateTokenScreen extends AppBaseView<CreateTokenController> {
  const CreateTokenScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
            () => controller.fetchInitData(), (context, snapshot) => _body(),
            loaderWidget: fullScreenloader()),
      );
  GestureDetector _body() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        appBar: customAppBar(createtoken.tr),
        body: appContainer(
          enableSafeArea: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Obx(() {
              final progress = (controller.rxCurrentPageIndex.value + 1) / 3;

              return Column(
                children: [
                  height(5),
                  _progressBar(progress),
                  height(10),
                  Expanded(
                      child: controller
                          .pageList[controller.rxCurrentPageIndex.value]),
                  _navButtons(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Padding _navButtons() {
    bool showBack = controller.rxCurrentPageIndex.value > 0;
    bool isLast =
        controller.rxCurrentPageIndex.value == controller.pageList.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showBack
                ? buttonContainer(
                    borderColor:
                        AppColorHelper().borderColor.withValues(alpha: 0.4),
                    color: AppColorHelper().cardColor.withValues(alpha: 0.9),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.asset(
                        Assets.icons.back.path,
                        scale: 3.5,
                      ),
                    ), onPressed: () {
                    controller.nextPage(false);
                  })
                : width(0),
            Row(
              children: [
                isLast
                    ? buttonContainer(
                        width: 195,
                        color: AppColorHelper().primaryColor,
                        appText(generateToken.tr,
                            color: AppColorHelper().textColor,
                            fontWeight: FontWeight.w500), onPressed: () async {
                        if (controller.checkIsFilled()) {
                          await showDialog(
                            context: Get.context!,
                            barrierDismissible: true,
                            builder: (_) => const TokenGenerateDialogue(
                              id: "TKN -782",
                            ),
                          );
                        }
                        controller.rxCurrentPageIndex(0);
                        navigateToAndRemove(homePageRoute);
                      })
                    : Row(
                        children: [
                          buttonContainer(
                              borderColor: AppColorHelper().primaryColor,
                              color: AppColorHelper()
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              appText(generate.tr,
                                  color: AppColorHelper().secondaryTextColor,
                                  fontWeight: FontWeight.w500),
                              onPressed: () async {
                            if (controller.checkIsFilled()) {
                              await showModalBottomSheet(
                                  context: Get.context!,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      GenerateTokenBottomsheet());
                            }
                          }),
                          width(15),
                          buttonContainer(
                              width: 90,
                              color: AppColorHelper().primaryColor,
                              appText(next.tr,
                                  color: AppColorHelper().textColor,
                                  fontWeight: FontWeight.w500),
                              onPressed: () async {
                            if (controller.rxCurrentPageIndex.value == 1) {
                              await controller.fetchRequestedByDropdown(
                                  controller.rxSelectedProject.value?.mccId ??
                                      '',
                                  controller.rxSelectedModule.value?.id ?? '',
                                  controller.rxSelectedTeam.value?.id ?? '',
                                  true);
                              controller.nextPage(true);
                            } else {
                              if (controller.checkIsFilled()) {
                                controller.nextPage(true);
                              }
                            }
                          }),
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _progressBar(double progress) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: AppColorHelper().borderColor,
                ),
              ),

              // Animated progress bar
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                widthFactor: progress, // 0.33, 0.66, or 1.0
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColorHelper().primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        width(5),
        appText("${controller.rxCurrentPageIndex.value + 1}/3",
            color: AppColorHelper().primaryTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w600)
      ],
    );
  }
}
