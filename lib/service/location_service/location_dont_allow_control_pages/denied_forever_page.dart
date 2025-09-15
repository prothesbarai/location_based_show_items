import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../../constant/app_color.dart';
import '../location_permission_service.dart';


class DeniedForeverPage extends StatefulWidget {
  const DeniedForeverPage({super.key});

  @override
  State<DeniedForeverPage> createState() => _DeniedForeverPageState();
}

class _DeniedForeverPageState extends State<DeniedForeverPage>{

  bool isChecked = false;


  Future<void> _openAppSettings() async {
    final opened = await Geolocator.openAppSettings();
    setState(() {isChecked = opened;});
  }


  Future<void> _callPermision() async {
    if (mounted){await LocationPermissionService.fetchPermission(context);}
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0.h,left: 20.0.w,right: 20.0.w,bottom: 55.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 80.h,),
                  CircleAvatar(
                    radius: 80.r,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.location_on_outlined,size: 100.sp,color: Colors.white,),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 30,),
                      Text("Without your location, we are unable to show products",style: TextStyle(color: Colors.black,fontSize: 27.sp, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      SizedBox(height: 30.h,),
                      Text(
                        "Please turn on location service in settings or enter your location manually to see our products",
                        style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18.sp,color: Colors.green),softWrap: true,textAlign: TextAlign.center,),
                      SizedBox(height: 20.h,)
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: isChecked ? _callPermision :_openAppSettings,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 15.h)),
                        child: Text("Go to Settings",style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: (){
                          /// >>> Menually Set The Location Page
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xfffef7ff), padding: EdgeInsets.symmetric(vertical: 15.h),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r), side: BorderSide(color: AppColor.primaryColor, width: 2.w),),),
                        child: Text("Enter location manually",style: TextStyle(color: Colors.black),)
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )

    );
  }
}