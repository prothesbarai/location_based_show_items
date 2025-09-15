import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/app_color.dart';
import '../location_permission_service.dart';

class PermissionCheckIntroPage extends StatefulWidget {
  const PermissionCheckIntroPage({super.key});

  @override
  State<PermissionCheckIntroPage> createState() => _PermissionCheckIntroPageState();
}
class _PermissionCheckIntroPageState extends State<PermissionCheckIntroPage> {

  bool _isProcessing = false;


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
                    backgroundColor: AppColor.primaryColor,
                    child: Icon(Icons.location_on_outlined,size: 100.sp,color: Colors.white,),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 30.h,),
                      Text("Asking your location access for :",style: TextStyle(color:AppColor.primaryColor,fontSize: 25.sp, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      SizedBox(height: 30.h,),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(border: Border.all(color: AppColor.primaryColor), borderRadius: BorderRadius.circular(50.r)),
                                padding: EdgeInsets.all(6.0.w),
                                child: Icon(Icons.star,color: AppColor.primaryColor,size: 18.sp,)
                            ),
                            SizedBox(width: 15.w),
                            Expanded(child: Text("Show Store",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),softWrap: true,),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(border: Border.all(color: AppColor.primaryColor), borderRadius: BorderRadius.circular(50.r)),
                                padding: EdgeInsets.all(6.0.w),
                                child: Icon(Icons.star,color: AppColor.primaryColor,size: 18.sp,)
                            ),
                            SizedBox(width: 15.w),
                            Expanded(child: Text("Finding the nearby shop from you",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),softWrap: true,),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(border: Border.all(color: AppColor.primaryColor), borderRadius: BorderRadius.circular(50.r)),
                                padding: EdgeInsets.all(6.0.w),
                                child: Icon(Icons.star,color: AppColor.primaryColor,size: 18.sp,)
                            ),
                            SizedBox(width: 15.w),
                            Expanded(child: Text("Faster delivery",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),softWrap: true,),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h,),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _isProcessing ? null : () async{
                      setState(() { _isProcessing = true; });
                      await LocationPermissionService.fetchPermission(context);
                      setState(() { _isProcessing = false; });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 15.h)),
                    child: Text("Continue",style: TextStyle(color: Colors.white),)
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}