import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/screen_titles.dart';

import 'core/services/firebase_service.dart';
import 'core/theme/app_themes.dart';

import 'ui/index_page.dart';

import 'core/helper/dependency_injection.dart';
import 'core/models/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  setupInjections();
  await setUpFirebase();
  await initializeHive();

  runApp(const MyApp());
}

Future<void> setUpFirebase() async {
  await serviceLocator<FirebaseService>().initialise();

  Function? originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    if (originalOnError != null) originalOnError(errorDetails);
  };
}

Future initializeHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(BookAdapter());
  await Hive.openBox<Book>('books');
}

class BooksAdapter {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: () => MaterialApp(
        title: appTitle,
        theme: AppThemes.defaultTheme,
        home: const IndexPage(),
      ),
    );
  }
}
