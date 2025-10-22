import 'package:flutter/material.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/PmmsApp.dart';
import 'helper/core/environment/env.dart';
import 'helper/enum.dart';
import 'helper/init/app_init.dart';

void main() async {
  AppEnvironment.setEnv(Environment.UAT);
  AppEnvironment.setClient(AppClient.muziris);
  await AppInit().mainInit();
  runApp(const PmmsApp());
}
