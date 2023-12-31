import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/data/datasource/local/sharedpreferences/storage_service.dart';
import 'package:live_app/screens/dashboard/bottom_navigation.dart';
import 'package:live_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:live_app/utils/utils_assets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/model/response/app_version_config.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    configVersion();
  }

  configVersion() async {
    Future.delayed(const Duration(seconds: 1),() async {
      try {
        var headers = {
          'Authorization': 'Bearer 1|muZM8iV2IQxqSVMRABSpBp58YkoPBonozCCSTdya'
        };

        var response = await http.get(
          Uri.parse('http://3.111.31.215:4000/admin/appVersion/getall'),
          headers: headers,
        ).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          AppVersionConfigModel model = appVersionConfigModelFromJson(response.body);
          if(model.status == 1){
            if(model.data!.last.name == Constants.appVersion){
              Get.off(() {
                return StorageService().getString(Constants.id) == ''?const LogInScreen():const BottomNavigator();
              });
            }else{
              updateRequiredDialog();
            }
          }
        } else {
          print(response.reasonPhrase);
        }
      } catch (e) {
        noInternetDialog();
      }
    },);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double a = Get.width / baseWidth;
    double b = a * 0.97;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: (){
            noInternetDialog();
          },
          child: Container(
            padding: EdgeInsets.only(bottom: Get.height/9),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/splash.jpg',
                ),
              ),
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void updateRequiredDialog() {
    double baseWidth = 360;
    double a = Get.width / baseWidth;
    double b = a * 0.97;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
                width: 50 * a,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Available!',
                      style: SafeGoogleFont('Poppins',
                          fontSize: 16 * b,
                          fontWeight: FontWeight.w600,
                          height: 1.5 * b / a,
                          letterSpacing: 0.48 * a,
                          color: Colors.black),
                    ),
                    InkWell(
                      onTap: () async {
                        if (await canLaunchUrl(Uri.parse(Constants.updateUrl))) {
                        await launchUrl(Uri.parse(Constants.updateUrl), mode: LaunchMode.externalApplication);
                        } else {
                        throw 'Could not launch ${Constants.updateUrl}';
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 12 * a,
                            left: 0 * a,
                            right: 0 * a),
                        child: Container(
                            width: 136 * a,
                            height: 27 * a,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.only(
                                topLeft: Radius.circular(
                                    9 * a),
                                topRight: Radius.circular(
                                    9 * a),
                                bottomLeft:
                                Radius.circular(
                                    9 * a),
                                bottomRight:
                                Radius.circular(
                                    9 * a),
                              ),
                              color: const Color(0xFF9E26BC),
                            ),
                            child: Center(
                              child: Text(
                                'Update',
                                style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 13 * a,
                                    fontWeight:
                                    FontWeight.w500,
                                    height: 1.5 * b / a,
                                    letterSpacing:
                                    0.48 * a,
                                    color: const Color.fromARGB(
                                        255,
                                        250,
                                        249,
                                        249)),
                              ),
                            )),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  void noInternetDialog() {
    double baseWidth = 360;
    double a = Get.width / baseWidth;
    double b = a * 0.97;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
                width: 50 * a,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No Internet Connection',
                      style: SafeGoogleFont('Poppins',
                          fontSize: 16 * b,
                          fontWeight: FontWeight.w600,
                          height: 1.5 * b / a,
                          letterSpacing: 0.48 * a,
                          color: Colors.black),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        configVersion();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 12 * a,
                            left: 0 * a,
                            right: 0 * a),
                        child: Container(
                            width: 136 * a,
                            height: 27 * a,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.only(
                                topLeft: Radius.circular(
                                    9 * a),
                                topRight: Radius.circular(
                                    9 * a),
                                bottomLeft:
                                Radius.circular(
                                    9 * a),
                                bottomRight:
                                Radius.circular(
                                    9 * a),
                              ),
                              color: const Color(0xFF9E26BC),
                            ),
                            child: Center(
                              child: Text(
                                'Retry',
                                style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 13 * a,
                                    fontWeight:
                                    FontWeight.w500,
                                    height: 1.5 * b / a,
                                    letterSpacing:
                                    0.48 * a,
                                    color: const Color.fromARGB(
                                        255,
                                        250,
                                        249,
                                        249)),
                              ),
                            )),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

}
