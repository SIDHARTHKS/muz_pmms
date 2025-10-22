import 'package:get/get.dart';
import 'package:pmms/binding/tasks_binding.dart';
import 'package:pmms/view/splash/splash_screen.dart' show SplashScreen;
import 'package:pmms/view/tasks/task_details_screen.dart';
import 'package:pmms/view/tasks/tasks_screen.dart';

import '../binding/home_binding.dart';
import '../binding/splash_binding.dart';
import '../view/home/home_screen.dart';

const loginPageRoute = '/login';
const updatePasswordPageRoute = '/update';
const splashPageRoute = '/splash';
const landingPageRoute = '/landing';
const homePageRoute = '/home';

const tasksPageRoute = '/mytasks';
const taskDetailsPageRoute = '/tasksDetails';

final routes = [
  GetPage(
      name: splashPageRoute,
      page: () => const SplashScreen(),
      binding: const SplashBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  // GetPage(
  //     name: landingPageRoute,
  //     page: () => const LandingScreen(),
  //     binding: const LandingBinding(),
  //     transition: Transition.fadeIn,
  //     transitionDuration: const Duration(milliseconds: 250)),
  // GetPage(
  //     name: loginPageRoute,
  //     page: () => const LoginScreen(),
  //     binding: const LoginBinding(),
  //     transition: Transition.fadeIn,
  //     transitionDuration: const Duration(milliseconds: 250)),

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
];
