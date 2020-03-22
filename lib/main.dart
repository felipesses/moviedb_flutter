import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviedb_flutter/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/app_module.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(ModularApp(
    module: AppModule(),
  ));
}
