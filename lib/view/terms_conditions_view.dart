import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:dmi/view/login_view.dart';
import 'package:dmi/widgets/check_box_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:permission_handler/permission_handler.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  bool boolTCPV = false, boolShowMessage = true;

  @override
  void initState() {
    //requestPermission();
    super.initState();
  }

  void _permissionDialog() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            margin: AppStyle.commonPadding,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "",
                      style: AppStyle.appSmallTextAppColor,
                    )),
                SizedBox(
                  height: 1.5,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          child: Text(
                            'Denied',
                            style: AppStyle.appBtnTxtStyleAppColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          child: Text(
                            'Accept',
                            style: AppStyle.appBtnTxtStyleAppColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.contacts
      //add more permission to request here.
    ].request();

    if (statuses[Permission.camera]!.isDenied) {
      //check each permission status after.
      //debugPrint("Location permission is denied.");
    }

    if (statuses[Permission.storage]!.isDenied) {
      //check each permission status after.
      //debugPrint("Storage permission is denied.");
    }
    if (statuses[Permission.contacts]!.isDenied) {
      //check each permission status after.
      //debugPrint("Contact permission is denied.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                // padding: AppStyle.commonPadding,
                decoration: BoxDecoration(
                  color: AppStyle.appShade,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/image/dmi_png.png",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ), /*Image.asset("assets/image/dmi_png.png",height: 12.h,)*/
                ),
              ),
            ),
            AppStyle.hSmallSpace,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Thanks',
                style: AppStyle.appSmallTextBlack,
                children: <TextSpan>[
                  TextSpan(
                    text: '\tfor',
                    style: AppStyle.appSmallTextBlack,
                  ),
                  TextSpan(
                    text: '\tbeing',
                    style: AppStyle.appSmallTextBlack,
                  ),
                  TextSpan(
                    text: '\tpart',
                    style: AppStyle.appSmallTextBlack,
                  ),
                  TextSpan(
                    text: '\tof\n',
                    style: AppStyle.appSmallTextBlack,
                  ),
                  TextSpan(
                    text: '#',
                    style:
                        AppStyle.appSmallTextBlack.copyWith(color: Colors.blue),
                  ),
                  TextSpan(
                    text: 'save',
                    style: AppStyle.appSmallTextBlack.copyWith(color: Colors.red),
                  ),
                  TextSpan(
                    text: 'trees',
                    style: AppStyle.appSmallTextBlack
                        .copyWith(color: AppStyle.appColor),
                  ),
                  TextSpan(
                    text: '\tinitiative',
                    style: AppStyle.appSmallTextBlack,
                  ),
                ],
              ),
            ),
            AppStyle.hSpace,
            AppStyle.hSpace,
            Flexible(child: boolShowMessage ? showMessage() : showPVTC()),
            AppStyle.footer
          ],
        ),
      ),
    );
  }

  Widget showPVTC() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Please read the',
          style: AppStyle.appTittleTextBlack,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                AppStyle.launchInBrowser(
                    Uri.parse("https://savetreesvc.com/terms-of-service"));
              },
              child: Text(
                'Terms of use',
                style: AppStyle.appTittleTextBlack.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              ' and ',
              style: AppStyle.appTittleTextBlack,
            ),
            InkWell(
              onTap: () {
                AppStyle.launchInBrowser(
                    Uri.parse("https://savetreesvc.com/privacy-policy"));
              },
              child: Text(
                'Privacy Policy',
                style: AppStyle.appTittleTextBlack.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        Text(
          'carefully before using the app.',
          style: AppStyle.appTittleTextBlack,
        ),
        AppStyle.hSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GFCheckbox(
                type: GFCheckboxType.basic,
                activeBgColor: AppStyle.appColor,
                size: AppStyle.tooBigIconSize,
                onChanged: (bool? value) {
                  setState(() {
                    boolTCPV = value!;
                  });
                },
                value: boolTCPV),
            AppStyle.wSpace,
            Text(
              "I have read and agree to the\nterms of use and privacy policy.",
              style: AppStyle.appTittleTextBlack,
            ),
          ],
        ),
        AppStyle.hSpace,
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: ElevatedButton(
              child: Text(
                "Continue",
                style: AppStyle.appBtnTxtStyleWhite,
              ),
              onPressed: () {
                if (!boolTCPV) {
                  final snackBar = SnackBar(
                    content: Text(
                      'Please accept terms of use & privacy policy!',
                      style: AppStyle.appSmallTextAppColor
                          .copyWith(color: Colors.white),
                    ),
                    backgroundColor: (Colors.black87),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  AppCookies.instance.setStringValue("tcpc", "T");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginView()));
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget showMessage() {
    return ListView(
      //mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22.0,
          ),
          child: Text(
            "Save Tree Initiative\n",
            textAlign: TextAlign.justify,
            style: AppStyle.appTittleTextBlack.copyWith(
              decoration: TextDecoration.underline,
              color: Colors.transparent,
              decorationStyle: TextDecorationStyle.solid,
              decorationColor: AppStyle.appColor,
              decorationThickness: 1,
              shadows: [
                const Shadow(color: Colors.black, offset: Offset(0, -5))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22.0,
          ),
          child: Text(
            intro,
            textAlign: TextAlign.justify,
            style: AppStyle.appTittleTextBlack,
          ),
        ),
        const SizedBox(height: 20),
        AppStyle.hSpace,
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: ElevatedButton(
              child: Text(
                "Next",
                style: AppStyle.appBtnTxtStyleWhite,
              ),
              onPressed: () {
                setState(() {
                  boolShowMessage = false;
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
