import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../gen/assets.gen.dart';
import '../../helper/app_string.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/environment/env.dart';
import '../../helper/date_helper.dart';
import '../../helper/enum.dart';
import '../../helper/navigation.dart';
import '../../helper/sizer.dart';
import 'text/app_text.dart';

Scaffold appScaffold(
        {required Widget body,
        bool loaderEnabled = true,
        bool showLoader = false,
        AppBar? appBar,
        bool resizeToAvoidBottomInset = false,
        Widget? bottomNavigationBar,
        Widget? drawer,
        extendBodyBehindAppBar = true,
        extendBody = true,
        bool isTransparent = false,
        bool topSafe = true,
        VoidCallback? action,
        bool? canpop,
        Color? bgcolor}) =>
    Scaffold(
      extendBody: extendBody,
      drawerEnableOpenDragGesture: false,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: bgcolor ?? AppColorHelper().backgroundColor,
      body: SafeArea(
        top: topSafe, // Set to true if you want to avoid notch overlap too
        bottom: false, //
        child: PopScope(
          canPop: canpop ?? true,
          onPopInvokedWithResult: (didpop, result) {
            if (action != null) {
              action!(); // execute regardless of pop result
            }
          },
          child: loaderEnabled
              ? Stack(
                  children: [
                    body,
                    if (showLoader)
                      Positioned.fill(
                        child: Container(
                          color: AppColorHelper().loaderColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // logoImage(),
                              loader(),
                            ],
                          ),
                        ),
                      )
                  ],
                )
              : body,
        ),
      ),
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
    );
AppBar appBar({
  bool showbackArrow = true,
  Widget? leadingWidget,
  List<Widget>? actions,
  String? titleText,
  VoidCallback? leadingWidgetPressed,
  VoidCallback? refreshPressed,
}) {
  leadingWidget = SizedBox(
    width: 50,
    child: leadingWidget ??
        Icon(
          Icons.arrow_back_ios_new,
          size: 28,
          color: AppColorHelper().primaryTextColor,
        ),
  );

  // if (!AppEnvironment.isProdMode()) {
  //   actions ??= [];
  //   actions.add(
  //     Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: boldLabelText(
  //         AppEnvironment.isDevMode() ? 'DEV' : 'UAT',
  //         color: AppColorHelper().primaryTextColor.withOpacity(.1),
  //       ),
  //     ),
  //   );
  // }
  if (refreshPressed != null) {
    actions ??= [];
    actions.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: refreshPressed,
          child: iconWidget(
            Icons.refresh,
            color: AppColorHelper().textColor,
          ),
        ),
      ),
    );
  }

  return AppBar(
    backgroundColor: AppColorHelper().backgroundColor,
    leading: showbackArrow
        ? GestureDetector(
            onTap: () {
              if (leadingWidgetPressed != null) {
                leadingWidgetPressed();
              } else {
                goBack();
              }
            },
            child: leadingWidget,
          )
        : GestureDetector(
            onTap: () {
              // DrawerSection();
            },
          ),
    title: appText(titleText ?? '',
        fontSize: 22,
        color: AppColorHelper().primaryTextColor,
        fontWeight: FontWeight.w700),
    leadingWidth: 0,
    automaticallyImplyLeading: false,
    centerTitle: false,
    actions: actions,
  );
}

AppBar customAppBar(String title, {VoidCallback? onTap}) => AppBar(
      backgroundColor: AppColorHelper().backgroundColor,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      leadingWidth: 40, // 👈 give enough space for the back icon
      toolbarHeight: 45,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10, top: 15),
        child: GestureDetector(
          onTap: onTap ?? goBack,
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColorHelper().primaryTextColor,
          ),
        ),
      ),

      title: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: appText(
          title,
          fontSize: 22,
          color: AppColorHelper().primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

SizedBox appContainer({
  required Widget child,
  bool enableSafeArea = true,
  String? img,
}) {
  late BoxDecoration boxDecoration;
  boxDecoration = switch (AppEnvironment.appClient) {
    AppClient.demo => BoxDecoration(color: AppColorHelper().backgroundColor),
    AppClient.muziris => BoxDecoration(color: AppColorHelper().backgroundColor),
  };
  return SizedBox(
    height: Get.height,
    width: Get.width,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: boxDecoration,
            // child: Image.asset(
            //   img ?? '',
            //   fit: BoxFit.cover,
            //   color: img != null
            //       ? Colors.black.withValues(alpha: 0)
            //       : Colors.black.withValues(alpha: 0.05),
            //   colorBlendMode: BlendMode.colorBurn,
            // ),
          ),
        ),
        enableSafeArea ? SafeArea(child: child) : child,
      ],
    ),
  );
}

InkWell appIcon({
  required IconData icon,
  Color? color,
  double? size,
  VoidCallback? onPressed,
}) =>
    InkWell(
      onTap: onPressed,
      child: Icon(
        icon,
        color: color ?? Colors.grey,
        size: size ?? 24.0,
      ),
    );

Widget drawerListTile({
  required IconData icon,
  required String title,
  VoidCallback? onTap,
  Widget? trailing,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.purple),
    title: Text(
      title,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    ),
    trailing: trailing,
    onTap: onTap,
  );
}

double responsiveFontSize(double size) {
  // Adjust based on a 375px design width.
  return size * Get.width / 375.0;
}

Divider divider({
  Color? color,
  double indent = 0,
  double endIndent = 0,
}) {
  color ??= AppColorHelper().dividerColor.withOpacity(.5);
  return Divider(
    color: color,
    indent: indent,
    endIndent: endIndent,
  );
}

Divider drawerDivider() => const Divider(
      color: Colors.grey,
      thickness: 0.5,
      height: 16.0,
    );

Switch switchWidget(
  bool value, {
  Color? activeColor,
  Function(bool)? onChanged,
}) =>
    Switch(
        activeColor: activeColor ?? AppColorHelper().primaryColor,
        value: value,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged(value);
          }
        });

SizedBox clientLogo({
  double? width = 200,
  double height = 75,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        Assets.images.muziris.path,
      ),
    );
Container muzirisLogo({
  double? width = 32,
  double height = 32,
}) =>
    Container(
      color: AppColorHelper().transparentColor,
      width: width,
      height: height,
      child: Image.asset(Assets.images.muziriswhite.path),
    );

LoadingIndicator buttonLoader() => const LoadingIndicator(
      indicatorType: Indicator.ballClipRotatePulse,
      colors: [Colors.white],
    );

GestureDetector buttonContainer(
  Widget child, {
  double radius = 4,
  double? width,
  double? height = 42,
  // Color? color = const Color(0xffBB2828),
  Color? color,
  VoidCallback? onPressed,
  Color? borderColor = Colors.transparent,
  double paddingVertical = 8.0,
}) =>
    GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding:
            EdgeInsets.symmetric(horizontal: 12, vertical: paddingVertical),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              color: borderColor ??
                  AppColorHelper().primaryTextColor.withValues(alpha: 0.5)),
          color: color ?? AppColorHelper().primaryColorLight.withOpacity(0.9),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     spreadRadius: 2,
          //     blurRadius: 8,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: child,
      ),
    );

Row doubleArrowSfxText(String text) {
  Color color;
  color = switch (AppEnvironment.appClient) {
    AppClient.demo => AppColorHelper().textColor,
    AppClient.muziris => AppColorHelper().textColor,
  };
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // tx700(text,
      //     color: const Color(0xff444444),
      //     size: 25,
      //     textAlign: TextAlign.center),
      appBarText(
        text,
        color: color,
        size: 25,
      ),
      Container(
        width: 100,
        height: 30,
        margin: const EdgeInsets.only(top: 4),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: iconWidget(
                  Icons.arrow_forward_ios_sharp,
                  color: color,
                  size: 20,
                ),
              ),
            ),
            Positioned(
              left: 7,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: color.withOpacity(.2),
                  size: 20,
                ),
              ),
            )
          ],
        ),
      )
    ],
  );
}

SizedBox loader() => const SizedBox(
      width: 70,
      height: 40,
      child: LoopingProgressBar(),
    );

Image logoImage() {
  String imagePath = '';
  imagePath = switch (AppEnvironment.appClient) {
    AppClient.demo => Assets.images.muziriswhite.path,
    AppClient.muziris => Assets.images.muziriswhite.path,
  };
  return Image.asset(
    imagePath,
    width: 200,
    height: 70,
  );
}

Container fullScreenloader() {
  log("Full-screen loader is being called");
  return Container(
    width: Get.width,
    height: Get.height,
    decoration: BoxDecoration(
      // image: DecorationImage(
      //   image: AssetImage(Assets.images.splashBg.path),
      //   fit: BoxFit.cover,
      // ),
      color: AppColorHelper().textColor.withOpacity(0.15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.images.muziriswhite.path,
          width: 200,
          height: 70,
        ),
        height(50),
        loader(),
      ],
    ),
  );
}

Container miniLoader() {
  return Container(
    width: 250,
    height: 250,
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.7), // Semi-transparent background
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/muziriswhite.png', // Adjust asset path
          width: 80,
          height: 30,
        ),
        const SizedBox(height: 15),
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    ),
  );
}

FutureBuilder appFutureBuilder<T>(
  Future<T> Function() futureFunction,
  Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      successWidget, {
  Widget? loaderWidget,
}) {
  loaderWidget ??= fullScreenloader();
  return FutureBuilder<T>(
    future: futureFunction(),
    builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loaderWidget!;
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        return successWidget(context, snapshot);
      }
    },
  );
}

Padding muzBottomLogo() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 50.0),
    child: muzirisLogo(),
  );
}

SizedBox bgLoader() => appContainer(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.images.muziriswhite.path),
                height(10),
                loader(),
              ],
            ),
          ),
        ],
      ),
    );
TextButton textButtonWidget({
  required String text,
  required VoidCallback onPressed,
}) =>
    TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style:
              textStyle(15, AppColorHelper().primaryTextColor, FontWeight.bold),
        ));

bottomNavBarTextStyle({FontWeight fontWeight = FontWeight.w600}) =>
    TextStyle(fontFamily: primaryFontName, fontWeight: fontWeight);

Padding misScreenPadding({required Widget child, double padding = 24}) =>
    Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );

Container borderContainer(
        {required Widget child,
        double padding = 12,
        double circularRadius = 8.0,
        double? height}) =>
    Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: AppColorHelper().borderColor),
        borderRadius: BorderRadius.circular(circularRadius),
      ),
      child: child,
    );

InkWell iconWidget(IconData iconData,
        {double size = 24, Color? color, VoidCallback? onPressed}) =>
    InkWell(
      onTap: onPressed,
      child: Icon(iconData,
          size: size, color: color ?? AppColorHelper().iconColor),
    );

Checkbox checkbox({required bool value, required Function(bool) onChanged}) =>
    Checkbox(
      value: value,
      activeColor: AppColorHelper().primaryColor,
      onChanged: (value) => onChanged(value ?? false),
    );

// Image sortIcon() {
//   String imagePath;
//   imagePath = switch (AppEnvironment.appClient) {
//     AppClient.demo => Assets.icons.atoz.path,
//     AppClient.muziris => Assets.icons.atoz.path,
//     AppClient.seemati => Assets.icons.atozSeemaatti.path,
//     AppClient.kalyan => Assets.icons.atoz.path
//   };
//   return Image.asset(imagePath);
// }

Widget appText(
  String text, {
  double fontSize = 14.0,
  TextDecoration decoration = TextDecoration.none,
  FontWeight fontWeight = FontWeight.w300,
  Color color = Colors.white,
  TextAlign textAlign = TextAlign.start,
  TextOverflow? overflow,
  int? maxLines,
  double? height,
  FontStyle? style,
}) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: "Mona Sans", // Use your custom font family here
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        height: height,
        fontStyle: style ?? FontStyle.normal),
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    softWrap: true,
  );
}

RichText superscriptDateWidget({
  required DateTime date,
  Color? textColor,
  double? fontSize = 14,
  FontWeight? fontWeight,
  TextDecoration decoration = TextDecoration.none,
}) {
  String day = date.day.toString();
  String suffix = DateHelper.getDaySuffix(date.day);
  String month = DateHelper.getMonthAbbreviation(date.month);
  TextStyle textStyle = TextStyle(
      fontSize: fontSize ?? 14,
      color: textColor ?? AppColorHelper().textColor,
      fontWeight: fontWeight ?? FontWeight.bold,
      decoration: decoration);
  return RichText(
    text: TextSpan(
      style: textStyle,
      children: [
        TextSpan(
          text: day,
          style: textStyle,
        ),
        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(0.0, -5.0), // Superscript effect
            child: Text(
              suffix,
              style: TextStyle(
                fontSize: fontSize! - 3,
                fontWeight: fontWeight ?? FontWeight.bold,
                color: textColor ?? AppColorHelper().textColor,
              ),
            ),
          ),
        ),
        TextSpan(
          text: " $month",
          style: textStyle,
        ),
      ],
    ),
  );
}

String convertToWords(double amount) {
  List<String> units = [
    "",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
  ];
  List<String> teens = [
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen"
  ];
  List<String> tens = [
    "",
    "ten",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ];
  List<String> thousands = ["", "thousand", "lakh", "crore"];

  if (amount == 0) return "Zero rupees only";

  int num = amount.toInt(); // Convert to integer
  String words = "";
  int place = 0;

  while (num > 0) {
    int chunk;

    // Extract last two digits for first place, then process in three-digit chunks
    if (place == 1) {
      chunk = num % 100; // Take last 2 digits for thousand place
      num ~/= 100;
    } else {
      chunk = num % 1000; // Take last 3 digits for lakh, crore, etc.
      num ~/= 1000;
    }

    if (chunk > 0) {
      String chunkWords = "";

      int hundreds = chunk ~/ 100;
      int remainder = chunk % 100;

      if (hundreds > 0) {
        chunkWords += "${units[hundreds]} hundred ";
      }

      if (remainder > 0) {
        if (remainder < 10) {
          chunkWords += units[remainder];
        } else if (remainder < 20) {
          chunkWords += teens[remainder - 11];
        } else {
          chunkWords += tens[remainder ~/ 10];
          if (remainder % 10 > 0) {
            chunkWords += " ${units[remainder % 10]}";
          }
        }
      }

      words = "$chunkWords ${thousands[place]} $words".trim();
    }

    place++;
  }

  // Capitalize the first letter
  words = words.trim();
  words =
      words.isNotEmpty ? words[0].toUpperCase() + words.substring(1) : words;

  return "$words rupees only".replaceAll(RegExp(r'\s+'), ' ');
}

String formatCurrency(double amount) {
  final formatter = NumberFormat("#,##,##0.00", "en_IN"); // Indian format
  return formatter.format(amount);
}

bool stringToBool(String value) {
  switch (value.toLowerCase().trim()) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw FormatException('Invalid boolean string: $value');
  }
}

String formatNumber(String input) {
  double value = double.parse(input);
  return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
}

String monthYear(DateTime date) {
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return "$month/$year";
}

class LoopingProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final Color trackColor;
  final Color progressColor;
  final Duration duration;

  const LoopingProgressBar({
    super.key,
    this.width = 150,
    this.height = 8,
    this.trackColor = Colors.white30,
    this.progressColor = Colors.white,
    this.duration = const Duration(milliseconds: 1500), // Faster speed
  });

  @override
  _LoopingProgressBarState createState() => _LoopingProgressBarState();
}

class _LoopingProgressBarState extends State<LoopingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.width).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _startLoop();
  }

  void _startLoop() {
    _controller.forward().whenComplete(() {
      _controller.reset();
      _startLoop(); // Restart loop faster
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background Track
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.trackColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
          ),
          // Animated Progress Bar
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: _animation.value,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.progressColor,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
