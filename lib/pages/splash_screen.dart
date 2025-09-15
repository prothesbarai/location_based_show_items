import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_based_show_items/constant/app_color.dart';
import 'package:provider/provider.dart';
import '../provider/location_provider.dart';
import '../service/location_service/location_dont_allow_control_pages/denied_forever_page.dart';
import '../service/location_service/location_dont_allow_control_pages/permission_check_intro_page.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkDeliveryArea();
  }


  Future<void> _checkDeliveryArea() async {

    final provider = Provider.of<LocationProvider>(context, listen: false);
    final isFirstTime = provider.isFirstTime;
    final permissionFlag = provider.permissionFlag;

    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      if (isFirstTime && permissionFlag == "denied") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PermissionCheckIntroPage()),);
      } else if (isFirstTime && permissionFlag == "denied_forever") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeniedForeverPage()),);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColor.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: Image.asset("assets/icon/icon.png",fit: BoxFit.cover,)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
