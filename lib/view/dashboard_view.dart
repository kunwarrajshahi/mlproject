import 'package:dmi/controller/api_controller.dart';
import 'package:dmi/view/acount_settings_view.dart';
import 'package:dmi/view/create_contact_view.dart';
import 'package:dmi/view/help_support_view.dart';
import 'package:dmi/view/login_view.dart';
import 'package:dmi/view/profile_visibility_update_view.dart';
import 'package:dmi/view/saved_business_card_details.dart';
import 'package:dmi/view/scan_card_front_back_holder_view.dart';
import 'package:dmi/view/scan_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_store/open_store.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'about_us_view.dart';
import 'create_qr_profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  GlobalKey globalKey = GlobalKey();
  late String apiToken, qrData = "QR_DATA";

  bool _load = false;

  String whatsAppNo = "",name = "";

  //business card
  String strVisitingCardImagePath = "",
      strVisitingCardBase64Image = "",
      totalProfile = "0";
  String totalSaveTrees = "0";

  double screenWidth = 0,screenHeight = 0;

  @override
  void initState() {
    AppCookies.instance
        .getStringValue("whatsAppNumber")
        .then((value) => setState(() {
              whatsAppNo = value;
            }));
    AppCookies.instance.getStringValue("name").then((value) => setState(() {
          name = value;
        }));
    AppCookies.instance.getStringValue("apiToken").then((value) => setState(() {
          apiToken = value;
          if (apiToken.isEmpty) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginView()));
          } else {
            _getUserProfileQRData();
            //_getUserProfileData();
            //debugPrint("apiToken===> $apiToken");
          }
        }));
    super.initState();
  }
  _getUserProfileData() async {
    setState(() {
      _load = true;
    });

    try {
      final result = await ApiController().get("profile/v1/details", apiToken);
      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          //personal details
          name = result['personalData']['name'] ?? "";
          AppCookies.instance
              .setStringValue("name", result['personalData']['name']);
          AppCookies.instance
              .setStringValue("id", result['personalData']['id']);
        } else {
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } on Exception catch (e) {
      setState(() {
        _load = false;
        final snackBar = SnackBar(
          content: Text(
            'Something went wrong try again',
            style: AppStyle.appSmallTextAppWhite,
          ),
          backgroundColor: (Colors.black87),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  _getUserProfileQRData() async {
    setState(() {
      _load = true;
    });

    try {
      final result = await ApiController()
          .get("profile/v1/get_user_qrcode_data", apiToken);
      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          qrData = result['qrData'];
          //_getUserProfileData();last changes
          _getUserCount();
          _getUSaveCount();
        } else {
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } on Exception catch (e) {
      setState(() {
        _load = false;
        final snackBar = SnackBar(
          content: Text(
            'Something went wrong try again',
            style: AppStyle.appSmallTextAppWhite,
          ),
          backgroundColor: (Colors.black87),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  _getUserCount() async {
    setState(() {
      _load = true;
    });

    try {
      final result = await ApiController().get("profile/count", apiToken);
      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          totalProfile = result['totalprofile'].toString();
        } else {
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } on Exception catch (e) {
      setState(() {
        _load = false;
        final snackBar = SnackBar(
          content: Text(
            'Something went wrong try again',
            style: AppStyle.appSmallTextAppWhite,
          ),
          backgroundColor: (Colors.black87),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  _getUSaveCount() async {
    setState(() {
      _load = true;
    });

    try {
      final result = await ApiController().get("savetree/meter", apiToken);
      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          totalSaveTrees = result['meter'].toString();
        } else {
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } on Exception catch (e) {
      setState(() {
        _load = false;
        final snackBar = SnackBar(
          content: Text(
            'Something went wrong try again',
            style: AppStyle.appSmallTextAppWhite,
          ),
          backgroundColor: (Colors.black87),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  _logout() async {
    setState(() {
      _load = true;
    });

    try {
      final result = await ApiController()
          .post("profile/v1/logout", {"action": ""}, apiToken);
      setState(() {
        _load = false;

        if (result['success']) {
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          AppCookies.instance.removeValue("Login");
          AppCookies.instance.removeValue("whatsAppNumber");
          AppCookies.instance.removeValue("apiToken");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginView()));
        } else {
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } on Exception catch (e) {
      setState(() {
        _load = false;
        final snackBar = SnackBar(
          content: Text(
            'Something went wrong try again',
            style: AppStyle.appSmallTextAppWhite,
          ),
          backgroundColor: (Colors.black87),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    //debugPrint("width--> $screenWidth\height--> $screenHeight");
    return SafeArea(
      child: UpgradeAlert(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  width: Size.infinite.width,
                  decoration: BoxDecoration(
                    color: AppStyle.appShade,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: screenHeight>736?40:35, left: 08, right: 02),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/dmi_png.png",
                          ),
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Thanks $name 😊,',
                                style: AppStyle.appSmallTextBlack,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "\nfor being part of ",
                                    style: AppStyle.appSmallTextBlack,
                                  ),
                                  TextSpan(
                                    text: '#',
                                    style: AppStyle.appSmallTextBlack
                                        .copyWith(color: Colors.blue),
                                  ),
                                  TextSpan(
                                    text: 'save',
                                    style: AppStyle.appSmallTextBlack
                                        .copyWith(color: Colors.red),
                                  ),
                                  TextSpan(
                                    text: 'trees',
                                    style: AppStyle.appSmallTextBlack
                                        .copyWith(color: AppStyle.appColor),
                                  ),
                                  TextSpan(
                                    text: '\tinitiative\n\n',
                                    style: AppStyle.appSmallTextBlack,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuButton(
                            elevation: 0,
                             // iconSize: 0,
                              padding: EdgeInsets.zero,
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyle.appShade,
                                  )
                              ),
                              onSelected: (value) {
                                setState(() {
                                  if(value==1){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const CreateQRProfileView(update: true,))).then((value) => _getUserProfileQRData());
                                  }else if(value==4){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const AboutUsView()));
                                  }else if(value==2){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const HelpSupportView()));
                                  }else if(value==5){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const AccountSettingsView()));
                                  }else if(value==6){

                                    OpenStore.instance.open(
                                      appStoreId: '6459364838', // AppStore id of your app for iOS
                                      // appStoreIdMacOS: '6459364838', // AppStore id of your app for MacOS (appStoreId used as default)
                                      androidAppBundleId: 'com.itechbuddy.dmi', // Android app bundle package name
                                      //windowsProductId: '9NZTWSQNTD0S' // Microsoft store id for Widnows apps
                                    );

                                  }else{
                                    _logout();
                                  }
                                });
                              },
                              icon: Icon(FontAwesomeIcons.bars,color: Colors.black,
                                size: AppStyle.mediumIconSize,),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Update Profile",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                      Icon(
                                        FontAwesomeIcons.userPen,
                                        color: AppStyle.appColor,
                                        size: AppStyle.smallIconSize,
                                      ),
                                      //AppStyle.wSpace,
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("About Us",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                      Icon(
                                        FontAwesomeIcons.circleInfo,
                                        color: AppStyle.appColor,
                                        size: AppStyle.smallIconSize,
                                      ),
                                      //AppStyle.wSpace,

                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Help & Support",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                      Icon(
                                        FontAwesomeIcons.handshakeAngle,
                                        color: AppStyle.appColor,
                                        size: AppStyle.smallIconSize,
                                      ),
                                      //AppStyle.wSpace,

                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Settings",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                      Icon(
                                        FontAwesomeIcons.userGear,
                                        color: AppStyle.appColor,
                                        size: AppStyle.smallIconSize,
                                      ),
                                      //AppStyle.wSpace,

                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 6,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Rate",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                      Icon(
                                        FontAwesomeIcons.solidStar,
                                        color: AppStyle.appColor,
                                        size: AppStyle.smallIconSize,
                                      ),
                                      //AppStyle.wSpace,

                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Logout",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                      Icon(
                                        FontAwesomeIcons.rightFromBracket,
                                        color: AppStyle.appColor,
                                        size: AppStyle.smallIconSize,
                                      ),
                                      //AppStyle.wSpace,
                                    ],
                                  ),
                                )
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _load
                  ? Center(child: AppStyle.loading)
                  : Flexible(
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                          ),
                          child: ListView(
                            children: [
                              AppStyle.hSmallSpace,
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 7,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppStyle.appShade,
                                    //border: Border.all(color: Colors.grey,width: 0.2),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          "Progress\nMeter",
                                          style: AppStyle.appSmallBoldTextBlack
                                              .copyWith(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      //AppStyle.wSpace,
                                      const SizedBox(
                                          height: 60,
                                          child: VerticalDivider(
                                            width: 0,
                                          )),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  /*Icon(
                                                    FontAwesomeIcons.users,
                                                    color: AppStyle.appColor,
                                                    size:
                                                        AppStyle.smallIconSize,
                                                  ),*/
                                                  //AppStyle.wSpace,
                                                  Text("Users:\t$totalProfile",
                                                      style: AppStyle
                                                          .appSmallTextBlack
                                                          .copyWith(
                                                              fontSize: 11),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.fade),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  /*Icon(
                                                    FontAwesomeIcons.tree,
                                                    color: AppStyle.appColor,
                                                    size:
                                                        AppStyle.smallIconSize,
                                                  ),*/
                                                  //AppStyle.wSpace,
                                                  Text("Trees Saved So Far:\t$totalSaveTrees",
                                                      style: AppStyle
                                                          .appSmallTextBlack
                                                          .copyWith(
                                                              fontSize: 11),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.fade),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 9,
                                ),
                                child: SizedBox(child: _qrImage()),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfileVisibilityUpdateView()));
                                    },
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppStyle.appShade,
                                        border: Border.all(
                                            color: Colors.grey, width: 0.6),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                      ),
                                      child: Text(
                                          "Select fields to be shared with QR code",
                                          style: AppStyle.appSmallTextBlack
                                              .copyWith(fontSize: 11),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.fade),
                                    ),
                                  ),
                                  AppStyle.hSmallSpace,
                                  InkWell(
                                    onTap: () async {
                                      //_downloadPdf();
                                      await Share.share(
                                          "Hello,\n\nThanks for connecting!\n\n"
                                          "I would like to share my business card using Save Trees VC App. Open the link below.\n\n$qrData"
                                          "\n\nRegards"
                                          "\n\n$name"
                                          "\n\nHave a nice day!");
                                    },
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppStyle.appShade,
                                        border: Border.all(
                                            color: Colors.grey, width: 0.6),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                      ),
                                      child: Text("Share your complete profile",
                                          style: AppStyle.appSmallTextBlack
                                              .copyWith(fontSize: 11),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.fade),
                                    ),
                                  ),
                                  AppStyle.hSmallSpace,
                                  InkWell(
                                    onTap: () async {
                                      //_downloadPdf();
                                      AppStyle.launchInBrowser(Uri.parse(
                                          "https://chat.whatsapp.com/I64Nz6qMZgOBUJeUxLYKi9"));
                                    },
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppStyle.appShade,
                                        border: Border.all(
                                            color: Colors.grey, width: 0.6),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                      ),
                                      child: MediaQuery.of(context).size.width >
                                              300
                                          ? Text(
                                              "To be a volunteer in our initiative,\njoin our WhatsApp group",
                                              style: AppStyle.appSmallTextBlack
                                                  .copyWith(fontSize: 11),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.fade,
                                            )
                                          : Text(
                                              "To be a volunteer in our initiative,join our WhatsApp group",
                                              style: AppStyle.appSmallTextBlack
                                                  .copyWith(fontSize: 11),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.fade,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            width: 135,
                                            child: ElevatedButton(
                                              child: Text(
                                                "Scan Card",
                                                style: AppStyle
                                                    .appSmallTextAppWhite
                                                    .copyWith(fontSize: 11,
                                                  fontWeight:FontWeight.bold,),
                                              ),
                                              onPressed: () {
                                                // _chooseCamera();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ScanCardFrontBackHolderView(
                                                              id: "",
                                                              view: "F",
                                                              fullName: "",
                                                              companyName: "",
                                                              jobTittle: "",
                                                              officeContact: "",
                                                              email: "",
                                                              address: '',
                                                              phone: "",
                                                              profilePic: "",
                                                              dob: '',
                                                              name: '',
                                                              surName: '',
                                                              profilePic2: '',
                                                              freeField: '',
                                                              email2: '',
                                                              mobileNo2: '',
                                                            )));
                                                /*Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const ScanDocumentView()));*/
                                              },
                                            ),
                                          ),
                                        ),
                                        AppStyle.wSpace,
                                        Flexible(
                                          child: SizedBox(
                                            width: 135,
                                            child: ElevatedButton(
                                              child: Text(
                                                "Card Holder",
                                                style: AppStyle
                                                    .appSmallTextAppWhite
                                                    .copyWith(fontSize: 11,fontWeight:FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SavedBusinessCardDetails()));
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))),
              AppStyle.footer
              // UpgradeAlert()
            ],
          ),
        ),
      ),
    );
  }

  Widget _qrImage() {
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(18),
      gapless: false,
    );
  }
}
