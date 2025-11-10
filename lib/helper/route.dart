import 'package:get/get.dart';
import 'package:pmms/binding/create_token_binding.dart';
import 'package:pmms/binding/tasks_binding.dart';
import 'package:pmms/view/create/create_token_screen.dart';
import 'package:pmms/view/login/creat_password_screen.dart';
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
      transitionDuration: const Duration(milliseconds: 1050)),
  GetPage(
      name: createPasswordPageRoute,
      page: () => CreatePasswordScreen(),
      binding: const LoginBinding(),
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
];
