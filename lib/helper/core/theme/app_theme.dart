import 'package:flutter/material.dart';

import '../../enum.dart';

class AppTheme {
  final String name; // Client name or identifier
  final Color dashBoardContainerBgColor;
  final Color unreadNotification;
  final Color readNotification;
  final Color buttonContainerBgColor;
  final Color loaderColor;
  final Color loaderSecondaryColor;
  final Color toastMsgColor;
  final Color circleAvatarBgColor;
  final Color boxShadowColor;
  final Color pwdFormFieldBorderColor;
  final Color cardTextColor;
  final Color transparentColor;
  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorDark;
  final Color backgroundColor;
  final Color cardColor;
  final Color dialogBackgroundColor;
  final Color canvasColor;
  final Color buttonColor;
  final Color textColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color buttonTextColor;
  final Color disabledTextColor;
  final Color hintColor;
  final Color errorColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color disabledBorderColor;
  final Color errorBorderColor;
  final Color dividerColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;

  final Color switchActiveColor;
  final Color switchInactiveColor;

  final Color statusLowColor;
  final Color statusMediumColor;
  final Color statusHighColor;
  final Color statusPendingColor;

  final String fontFamily;
  final String imagePath; // Path to client-specific images

  AppTheme({
    required this.name,
    required this.dashBoardContainerBgColor,
    required this.unreadNotification,
    required this.readNotification,
    required this.buttonContainerBgColor,
    required this.loaderColor,
    required this.loaderSecondaryColor,
    required this.toastMsgColor,
    required this.circleAvatarBgColor,
    required this.boxShadowColor,
    required this.pwdFormFieldBorderColor,
    required this.cardTextColor,
    required this.transparentColor,
    required this.primaryColor,
    required this.primaryColorLight,
    required this.primaryColorDark,
    required this.backgroundColor,
    required this.cardColor,
    required this.dialogBackgroundColor,
    required this.canvasColor,
    required this.buttonColor,
    required this.textColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.disabledTextColor,
    required this.buttonTextColor,
    required this.hintColor,
    required this.errorColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.enabledBorderColor,
    required this.disabledBorderColor,
    required this.errorBorderColor,
    required this.dividerColor,
    required this.iconColor,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.fontFamily,
    required this.imagePath,
    required this.switchActiveColor,
    required this.switchInactiveColor,
    required this.statusLowColor,
    required this.statusMediumColor,
    required this.statusHighColor,
    required this.statusPendingColor,
  });
}

final Map<AppClient, Map<ThemeModeType, AppTheme>> appThemes = {
  AppClient.demo: {
    ThemeModeType.light: _demoLightTheme(),
    ThemeModeType.dark: _demoDarkTheme(),
  },
  AppClient.muziris: {
    ThemeModeType.light: _demoLightTheme(),
    ThemeModeType.dark: _demoDarkTheme(),
  },
};

AppTheme _demoDarkTheme() => AppTheme(
      name: 'Demo',

      cardTextColor: Colors.white,
      readNotification: const Color.fromARGB(255, 255, 254, 254),
      unreadNotification: const Color.fromRGBO(29, 180, 106, 1),
      dashBoardContainerBgColor: const Color(0xFFD9D9EB).withOpacity(.12),
      buttonContainerBgColor: const Color(0xFF464544),
      loaderColor: Colors.white.withOpacity(0.5),
      loaderSecondaryColor: Colors.white.withOpacity(0.5),
      circleAvatarBgColor: Colors.white,
      toastMsgColor: const Color(0xff323030),
      boxShadowColor: Colors.black.withOpacity(.1),
      pwdFormFieldBorderColor: Colors.black54,
      transparentColor: Colors.transparent,
      primaryColor: const Color.fromRGBO(100, 77, 221, 1)!,
      primaryColorLight: const Color.fromARGB(255, 230, 226, 251)!,
      primaryColorDark: const Color.fromARGB(255, 81, 46, 255)!,
      backgroundColor: Colors.black,
      cardColor: Colors.grey[850]!,
      dialogBackgroundColor: Colors.grey[800]!,
      canvasColor: Colors.grey[900]!,
      buttonColor: Colors.blueAccent,
      textColor: Colors.white,
      primaryTextColor: Colors.white,
      secondaryTextColor: const Color.fromRGBO(100, 77, 221, 1)!,
      disabledTextColor: Colors.grey[600]!,
      buttonTextColor: Colors.white,
      hintColor: Colors.grey[500]!,
      errorColor: Colors.redAccent,
      borderColor: Colors.grey[700]!,
      focusedBorderColor: Colors.lightBlueAccent,
      enabledBorderColor: Colors.grey[700]!,
      disabledBorderColor: Colors.grey[800]!,
      errorBorderColor: Colors.redAccent,
      dividerColor: Colors.grey[600]!,
      iconColor: Colors.white,
      selectedIconColor: Colors.lightBlue,
      unselectedIconColor: Colors.grey[600]!,

      //

      switchActiveColor: const Color.fromRGBO(180, 29, 141, 1),
      switchInactiveColor: const Color.fromARGB(255, 142, 131, 192),

      //
      statusLowColor: const Color.fromRGBO(64, 137, 161, 1),
      statusMediumColor: const Color.fromRGBO(162, 98, 35, 1),
      statusHighColor: const Color.fromRGBO(203, 70, 70, 1),
      statusPendingColor: const Color.fromRGBO(100, 77, 221, 1),

      fontFamily: 'Roboto',
      imagePath: 'assets/images/demo.png',
    );
AppTheme _demoLightTheme() => AppTheme(
      name: 'Demo',

      cardTextColor: Colors.black,

      dashBoardContainerBgColor: const Color(0xff767680).withOpacity(.12),
      readNotification: const Color.fromARGB(255, 255, 254, 254),
      unreadNotification: const Color.fromRGBO(29, 180, 106, 1),
      buttonContainerBgColor: const Color(0xffF3F1EE),
      loaderColor: const Color.fromARGB(255, 255, 255, 255),
      loaderSecondaryColor: const Color.fromARGB(255, 255, 255, 255),
      circleAvatarBgColor: const Color.fromARGB(255, 157, 141, 190),
      toastMsgColor: const Color(0xff323030),
      pwdFormFieldBorderColor: const Color.fromRGBO(67, 23, 159, 1),
      boxShadowColor: Colors.black.withOpacity(.1),
      transparentColor: Colors.transparent,
      primaryColor: const Color.fromRGBO(100, 77, 221, 1)!,
      primaryColorLight: const Color.fromARGB(255, 230, 226, 251)!,
      primaryColorDark: const Color.fromARGB(255, 81, 46, 255)!,
      backgroundColor: const Color.fromARGB(255, 250, 248, 254),
      cardColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      canvasColor: const Color.fromARGB(255, 245, 243, 248)!,
      buttonColor: Colors.blueAccent,
      textColor: const Color.fromRGBO(255, 255, 255, 1),
      primaryTextColor: const Color.fromARGB(255, 0, 0, 0),
      secondaryTextColor: const Color.fromRGBO(67, 23, 159, 1),
      disabledTextColor: Colors.grey[400]!,
      buttonTextColor: Colors.white,
      hintColor: const Color.fromARGB(255, 77, 76, 76)!,
      errorColor: const Color.fromRGBO(217, 75, 77, 1),
      borderColor: Colors.grey[400]!,
      focusedBorderColor: const Color.fromRGBO(67, 23, 159, 1),
      enabledBorderColor: const Color.fromRGBO(67, 23, 159, 1)!,
      disabledBorderColor: const Color.fromARGB(255, 237, 237, 237)!,
      errorBorderColor: const Color.fromRGBO(217, 75, 77, 1),
      dividerColor: Colors.grey,
      iconColor: const Color.fromRGBO(81, 55, 136, 1),
      selectedIconColor: const Color.fromRGBO(180, 29, 141, 1)!,
      unselectedIconColor: Colors.grey,

      //
      switchActiveColor: const Color.fromRGBO(180, 29, 141, 1),
      switchInactiveColor: const Color.fromARGB(255, 142, 131, 192),

      //
      statusLowColor: const Color.fromRGBO(64, 137, 161, 1),
      statusMediumColor: const Color.fromRGBO(162, 98, 35, 1),
      statusHighColor: const Color.fromRGBO(203, 70, 70, 1),
      statusPendingColor: const Color.fromRGBO(100, 77, 221, 1),

      fontFamily: 'Roboto',
      imagePath: 'assets/images/demo.png',
    );
AppTheme _seemattiDarkTheme() => AppTheme(
      name: 'Seematti',
      cardTextColor: Colors.white,
      dashBoardContainerBgColor: const Color(0xFFD9D9EB).withOpacity(.12),

      readNotification: Colors.grey,
      unreadNotification: Colors.red,
      buttonContainerBgColor: const Color(0xFF464544),
      loaderColor: Colors.white.withOpacity(0.5),
      loaderSecondaryColor: Colors.white.withOpacity(0.5),
      toastMsgColor: const Color(0xff323030),
      circleAvatarBgColor: const Color.fromRGBO(94, 43, 205, 1),
      boxShadowColor: Colors.black.withOpacity(.1),
      pwdFormFieldBorderColor: Colors.black54,
      transparentColor: Colors.transparent,
      primaryColor: const Color.fromRGBO(100, 77, 221, 1)!,
      primaryColorLight: const Color.fromARGB(255, 230, 226, 251)!,
      primaryColorDark: const Color.fromARGB(255, 81, 46, 255)!,
      backgroundColor: Colors.black,
      cardColor: Colors.grey[850]!,
      dialogBackgroundColor: Colors.grey[800]!,
      canvasColor: Colors.grey[900]!,
      buttonColor: Colors.blueAccent,
      textColor: Colors.white,
      primaryTextColor: Colors.white,
      secondaryTextColor: const Color.fromRGBO(100, 77, 221, 1)!,
      disabledTextColor: Colors.grey[600]!,
      buttonTextColor: Colors.white,
      hintColor: Colors.grey[500]!,
      errorColor: Colors.redAccent,
      borderColor: Colors.grey[700]!,
      focusedBorderColor: Colors.lightBlueAccent,
      enabledBorderColor: Colors.grey[700]!,
      disabledBorderColor: Colors.grey[800]!,
      errorBorderColor: Colors.redAccent,
      dividerColor: Colors.grey[600]!,
      iconColor: Colors.white,
      selectedIconColor: Colors.lightBlue,
      unselectedIconColor: Colors.grey[600]!,

      //
      switchActiveColor: const Color.fromRGBO(180, 29, 141, 1),
      switchInactiveColor: const Color.fromARGB(255, 142, 131, 192),

      //
      statusLowColor: const Color.fromRGBO(64, 137, 161, 1),
      statusMediumColor: const Color.fromRGBO(162, 98, 35, 1),
      statusHighColor: const Color.fromRGBO(203, 70, 70, 1),
      statusPendingColor: const Color.fromRGBO(100, 77, 221, 1),

      fontFamily: 'lato',
      imagePath: 'assets/images/demo.png',
    );
AppTheme _seemattiLightTheme() => AppTheme(
      name: 'Seematti',

      cardTextColor: Colors.white,
      dashBoardContainerBgColor: const Color(0xff767680).withOpacity(.12),
      readNotification: Colors.grey,
      unreadNotification: Colors.red,

      buttonContainerBgColor: const Color(0xffF3F1EE),
      loaderColor: const Color(0xff323030).withOpacity(.25),
      loaderSecondaryColor: Colors.white.withOpacity(0.5),
      circleAvatarBgColor: Colors.white,
      toastMsgColor: const Color(0xff323030),
      boxShadowColor: Colors.black.withOpacity(.1),
      pwdFormFieldBorderColor: Colors.black54,
      transparentColor: Colors.transparent,
      primaryColor: const Color.fromRGBO(100, 77, 221, 1)!,
      primaryColorLight: const Color.fromARGB(255, 230, 226, 251)!,
      primaryColorDark: const Color.fromARGB(255, 81, 46, 255)!,
      backgroundColor: const Color.fromARGB(255, 250, 248, 254),
      cardColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      canvasColor: Colors.grey[50]!,
      buttonColor: Colors.blueAccent,
      textColor: Colors.black,
      primaryTextColor: const Color.fromARGB(255, 0, 0, 0),
      secondaryTextColor: Colors.grey,
      disabledTextColor: Colors.grey[400]!,
      buttonTextColor: Colors.white,
      hintColor: Colors.grey[600]!,
      errorColor: Colors.red,
      borderColor: Colors.grey[400]!,
      focusedBorderColor: const Color(0xffCF3448).withOpacity(.85),
      enabledBorderColor: Colors.grey[400]!,
      disabledBorderColor: Colors.grey[200]!,
      errorBorderColor: Colors.red,
      dividerColor: Colors.grey,
      iconColor: Colors.grey,
      selectedIconColor: Colors.blueAccent,
      unselectedIconColor: Colors.grey,

      //
      switchActiveColor: const Color.fromRGBO(180, 29, 141, 1),
      switchInactiveColor: const Color.fromARGB(255, 142, 131, 192),

      //
      statusLowColor: const Color.fromRGBO(64, 137, 161, 1),
      statusMediumColor: const Color.fromRGBO(162, 98, 35, 1),
      statusHighColor: const Color.fromRGBO(203, 70, 70, 1),
      statusPendingColor: const Color.fromRGBO(100, 77, 221, 1),

      fontFamily: 'lato',
      imagePath: 'assets/images/demo.png',
    );
