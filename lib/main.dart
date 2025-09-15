import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_based_show_items/pages/splash_screen.dart';
import 'package:location_based_show_items/provider/location_provider.dart';
import 'package:location_based_show_items/service/hive_service/hive_service.dart';
import 'package:provider/provider.dart';

import 'constant/app_color.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Edge-to-Edge Fix & status bar + nav bar transparent
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: Colors.transparent, systemNavigationBarDividerColor: Colors.transparent, statusBarIconBrightness: Brightness.light, systemNavigationBarIconBrightness: Brightness.light,),);
  await HiveService.initHive();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationProvider()),
        ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 869),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: AppColor.primaryColor,
            useMaterial3: false,
            appBarTheme: AppBarTheme(backgroundColor: Color(0xfff7f7f7),),
            elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: Colors.white,foregroundColor: Colors.black),),
            drawerTheme: DrawerThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(20),),),),
          ),
        home: SplashScreen()
      ),
    );
  }
}
