import 'package:get/get.dart';
import 'package:pmms/binding/change_password_binding.dart';
import 'package:pmms/binding/create_story_binding.dart';
import 'package:pmms/binding/create_token_binding.dart';
import 'package:pmms/binding/notification_binding.dart';
import 'package:pmms/binding/settings_binding.dart';
import 'package:pmms/binding/tasks_binding.dart';
import 'package:pmms/view/changePassword/change_password_screen.dart';
import 'package:pmms/view/createStory/create_story_screen.dart';
import 'package:pmms/view/createToken/create_token_screen.dart';
import 'package:pmms/view/login/creat_password_screen.dart';
import 'package:pmms/view/notifications/notification_screen.dart';
import 'package:pmms/view/settings/settings_screen.dart';
import 'package:pmms/view/splash/splash_screen.dart' show SplashScreen;
import 'package:pmms/view/tasks/task_details_screen.dart';
import 'package:pmms/view/tasks/tasks_screen.dart';

import '../binding/home_binding.dart';
import '../binding/login_binding.dart';
import '../binding/splash_binding.dart';
import '../view/home/home_screen.dart';
import '../view/login/login_screen.dart';

const loginPageRoute = '/login';
const createPasswordPageRoute = '/createPassword';
const updatePasswordPageRoute = '/update';
const splashPageRoute = '/splash';
const landingPageRoute = '/landing';
const homePageRoute = '/home';

const tasksPageRoute = '/mytasks';
const taskDetailsPageRoute = '/tasksDetails';
const createTokenPageRoute = '/createToken';
const createStoryPageRoute = '/createStory';
const settingsPageRoute = '/settings';
const changePasswordPageRoute = '/changePassword';

const notificationsPageRoute = '/notifications';

final routes = [
  GetPage(
      name: splashPageRoute,
      page: () => const SplashScreen(),
      binding: const SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350)),
  // GetPage(
  //     name: landingPageRoute,
  //     page: () => const LandingScreen(),
  //     binding: const LandingBinding(),
  //     transition: Transition.fadeIn,5
  //     transitionDuration: const Duration(milliseconds: 250)),

  GetPage(
      name: loginPageRoute,
      page: () => LoginScreen(),
      binding: const LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 450)),
  GetPage(
      name: createPasswordPageRoute,
      page: () => CreatePasswordScreen(),
      binding: const ChangePasswordBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350)),

  GetPage(
      name: homePageRoute,
      page: () => const HomeScreen(),
      binding: const HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250)),

  GetPage(
      name: tasksPageRoute,
      page: () => const TasksScreen(),
      binding: const TasksBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: taskDetailsPageRoute,
      page: () => const TaskDetailsScreen(),
      // binding: const TasksBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: createTokenPageRoute,
      page: () => const CreateTokenScreen(),
      binding: const CreateTokenBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: createStoryPageRoute,
      page: () => const CreateStoryScreen(),
      binding: const CreateStoryBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350)),
  GetPage(
      name: settingsPageRoute,
      page: () => const SettingsScreen(),
      binding: const SettingsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: changePasswordPageRoute,
      page: () => const ChangePasswordScreen(),
      binding: const ChangePasswordBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: notificationsPageRoute,
      page: () => const NotificationScreen(),
      binding: const NotificationBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
];
