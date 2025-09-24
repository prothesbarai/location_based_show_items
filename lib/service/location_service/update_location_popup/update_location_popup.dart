import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../pages/home_page.dart';
import '../../../provider/location_provider.dart';
import '../fetch_location_area_and_compare_polygon.dart';
import '../location_dont_allow_control_pages/denied_forever_page.dart';
import '../overlay_loading_and_update_hive.dart';

Widget buildPopupItem(BuildContext context) {
  bool isLoading = false;
  final provider = Provider.of<LocationProvider>(context, listen: false);
  final permissionFlag = provider.permissionFlag;
  //final cartProvider = Provider.of<CartProvider>(context);
  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r),),
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15.h,),
                    Text("Your current location", style: TextStyle(color: AppColor.primaryColor,fontSize: 21.7.sp), textAlign: TextAlign.center,),
                    SizedBox(height: 5.h,),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined, color: AppColor.primaryColor,size: 40.sp,),
                      /*title: Consumer<DeliveryAreaProvider>(
                        builder: (context, provider, _) {
                          return Text(provider.selectedAreaName ?? "Detecting...", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),);
                        },
                      ),*/
                      subtitle: Text("Saved Location"),
                    ),
                    SizedBox(height: 20.h,),

                    permissionFlag == "granted"?
                    ElevatedButton(
                      onPressed: ()=>showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r),),
                          contentPadding: EdgeInsets.zero,
                          content: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Are you sure ?",style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryColor,fontSize: 20.sp),),
                                    SizedBox(height: 15.h,),
                                    Text("If you change location, your cart will be removed.",style: TextStyle(color: Colors.black,fontSize: 16.sp),textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),


                              closeButton(context),
                            ],
                          ),
                          actions: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: ()=>Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                                        child: Text("No",style: TextStyle(color: Colors.white),)
                                    ),
                                    SizedBox(width: 15.w,),
                                    ElevatedButton(
                                        onPressed: isLoading ? null : () async {
                                          setState(() {isLoading = true; });
                                          if(isLoading){if(context.mounted){OverlayLoadingAndUpdateHive.show(context, "Loading...",Colors.transparent, Colors.grey,Colors.grey);}}
                                          if(context.mounted){await FetchLocationAreaAndComparePolygon.fetchLocation(context);}
                                          //cartProvider.clearCart();
                                          setState(() {isLoading = false; });
                                          if(!isLoading){if(context.mounted){OverlayLoadingAndUpdateHive.hide(context);}}
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                                        child: Text("Yes",style: TextStyle(color: Colors.white),)
                                    )
                                  ],
                                ),
                                SizedBox(height: 15.h,),
                              ],
                            )
                          ],
                        ),
                      ),

                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.gps_fixed, color: Colors.white),
                          SizedBox(width: 10.w,),
                          Text("Update location using GPS", style: TextStyle(color: Colors.white,fontSize: 14.sp),)
                        ],
                      ),
                    ):
                    ElevatedButton(
                      onPressed: ()=> showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r),),
                          contentPadding: EdgeInsets.zero,
                          content: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Firstly Need Your Location Permission",style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryColor,fontSize: 20.sp),),
                                  ],
                                ),
                              ),


                              closeButton(context),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeniedForeverPage(),));
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                                child: Text("OK",style: TextStyle(color: Colors.white),)
                            ),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.gps_fixed, color: Colors.white),
                          SizedBox(width: 10.w,),
                          Text("Need permission for GPS", style: TextStyle(color: Colors.white,fontSize: 14.sp),)
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h,),


                    ElevatedButton(
                      onPressed: ()=>showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r),),
                          contentPadding: EdgeInsets.zero,
                          content: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Are you sure ?",style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryColor,fontSize: 20.sp),),
                                    SizedBox(height: 15.h,),
                                    Text("If you change location, your cart will be removed.",style: TextStyle(color: Colors.black,fontSize: 16.sp),textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),


                              closeButton(context),
                            ],
                          ),
                          actions: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: ()=>Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                                        child: Text("No",style: TextStyle(color: Colors.white),)
                                    ),
                                    SizedBox(width: 15.w,),
                                    ElevatedButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryAreaPointSelectPage(showHeaderFooter: true,showCurrentDeliveryPoint: true,),));
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                                        child: Text("Yes",style: TextStyle(color: Colors.white),)
                                    )
                                  ],
                                ),
                                SizedBox(height: 15.h,),
                              ],
                            )
                          ],
                        ),
                      ),

                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.yellowAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r),), padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_outlined, color: AppColor.primaryColor),
                          SizedBox(width: 10.w,),
                          Text("Update your location manually", style: TextStyle(color: AppColor.primaryColor,fontSize: 14.sp),)
                        ],
                      ),
                    )

                  ],
                ),
              ),


              closeButton(context),
            ],
          )
      );
    },
  );
}



Widget closeButton(BuildContext context) {
  return Positioned(
    right: 5,
    top: 5,
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,border: Border.all(color: Colors.red,width: 1.w)),
        padding: EdgeInsets.all(3.w),
        child: Icon(Icons.close, color: Colors.red, size: 20.sp),
      ),
    ),
  );
}




