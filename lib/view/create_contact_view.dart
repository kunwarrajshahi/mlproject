import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:dmi/controller/api_controller.dart';
import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:dmi/view/dashboard_view.dart';
import 'package:dmi/widgets/drop_down_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'login_view.dart';

class CreateContactView extends StatefulWidget {
  final bool update;

  const CreateContactView({Key? key, required this.update}) : super(key: key);

  @override
  State<CreateContactView> createState() => _CreateContactViewState();
}

class _CreateContactViewState extends State<CreateContactView> {
  //personal details controller
  late String strProfileImagePath = "", strProfileBase64Image = "";
  final TextEditingController _controllerSurName = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerWhatsAppNumber =
      TextEditingController();
  final TextEditingController _controllerMobileNumber = TextEditingController();

  //origination details
  final TextEditingController _controllerTitleDesignation =
      TextEditingController();
  final TextEditingController _controllerCompanyName = TextEditingController();
  final TextEditingController _controllerLandLineNoDirect =
      TextEditingController();
  final TextEditingController _controllerLandLineNoBoard =
      TextEditingController();
  final TextEditingController _controllerOrganisationWebsite =
      TextEditingController();
  final TextEditingController _controllerPinCode = TextEditingController();
  final TextEditingController _controllerAddressLine1 = TextEditingController();
  late String sltCountryId = "", sltStateId = "", sltCityId = "";
  String strVisitingCardImagePath = "", strVisitingCardBase64Image = "";
  List countryData = [];
  List stateData = [];
  List cityData = [];

  //social media details
  final TextEditingController _controllerLinkedId = TextEditingController();
  final TextEditingController _controllerTwitterId = TextEditingController();
  final TextEditingController _controllerFacebookId = TextEditingController();
  final TextEditingController _controllerInstId = TextEditingController();
  final TextEditingController _controllerThreadsId = TextEditingController();
  final TextEditingController _controllerSnapChatId = TextEditingController();
  final TextEditingController _controllerTelegramId = TextEditingController();
  final TextEditingController _controllerYouTubeId = TextEditingController();
  final TextEditingController _controllerWebsiteDomain = TextEditingController();
  final TextEditingController _controllerFreeField1 = TextEditingController();
  final TextEditingController _controllerFreeField2 = TextEditingController();
  final TextEditingController _controllerFreeField3 = TextEditingController();

  int activeStep = 0; // Initial step set to 5.
  int upperBound = 2; // upperBound MUST BE total number of icons minus 1.
  late String apiToken;
  bool _load = false;
  String visitData = "F", profilePic = "", physicalVisitingCardPic = "";
  bool blShowSaved = false;
  late DateTime _chosenDateTime;
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    AppCookies.instance.getStringValue("apiToken").then((value) => setState(() {
          apiToken = value;
          if(apiToken.isEmpty){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginView()));
          }else{
            _getCountryData(value);
            //debugPrint("apiToken===> $apiToken");
          }
        }));
    if (!widget.update) {
      AppCookies.instance
          .getStringValue("whatsAppNumber")
          .then((value) => setState(() {
                _controllerWhatsAppNumber.text = value;
                _controllerMobileNumber.text = value;
              }));
    } else {
      AppCookies.instance
          .getStringValue("apiToken")
          .then((value) => setState(() {
                apiToken = value;
                //_getCountryData(value);
                _getUserProfileData();
               // debugPrint("apiToken===> $apiToken");
              }));
      AppCookies.instance
          .getStringValue("whatsAppNumber")
          .then((value) => setState(() {
                _controllerWhatsAppNumber.text = value;
                //_controllerMobileNumber.text = value;
              }));
    }
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
          //whatsAppNo=result['personalData']['whatsAppNo']??"";
          _controllerMobileNumber.text =
              result['personalData']['mobileNo'] ?? "";
          _controllerSurName.text = result['personalData']['surName'] ?? "";
          _controllerName.text = result['personalData']['name'] ?? "";
          AppCookies.instance
              .setStringValue("name", result['personalData']['name']);
          _controllerDob.text=result['personalData']['dob'] ?? "";
          //String date = result['personalData']['dob'] ?? "";
          //_controllerDateDay.text=AppStyle.getDay(date);
          //_controllerDateMonth.text=AppStyle.getMonth(date);
          //String yearCheck=AppStyle.getYear(date);
          //_controllerDateYear.text=yearCheck=="0" || yearCheck=="0000"?"":yearCheck;
          _controllerEmail.text = result['personalData']['emailId'] ?? "";
          profilePic = result['personalData']['profilePic'] ?? "";
          physicalVisitingCardPic =
              result['personalData']['physicalVisitingCardPic'] ?? "";
          //origination details
          _controllerTitleDesignation.text =
              result['organizationData']['titleDesignation'] ?? "";
          _controllerCompanyName.text =
              result['organizationData']['companyName'] ?? "";
          _controllerLandLineNoDirect.text =
              result['organizationData']['landLineNoDirect'] ?? "";
          _controllerLandLineNoBoard.text =
              result['organizationData']['landLineNoBoard'] ?? "";
          sltCountryId = result['organizationData']['country_id'] ?? "";
          sltStateId = result['organizationData']['state_id'] ?? "";
          sltCityId = result['organizationData']['city_id'] ?? "";

          _controllerPinCode.text =
              result['organizationData']['pincode'] ?? "";
          _controllerAddressLine1.text =
              result['organizationData']['addressLine1'] ?? "";

         // _controllerAddressLine2.text = result['organizationData']['addressLine2'] ?? "";

         // _controllerAddressLine3.text = result['organizationData']['addressLine3'] ?? "";

          _controllerOrganisationWebsite.text =
              result['organizationData']['organisationWebsite'] ?? "";

          //social media details
          _controllerLinkedId.text =
              result['socialMediaData']['linkedinId'] ?? "";
          _controllerTwitterId.text =
              result['socialMediaData']['twitterId'] ?? "";
          _controllerFacebookId.text =
              result['socialMediaData']['facebookId'] ?? "";
          _controllerInstId.text =
              result['socialMediaData']['instagramId'] ?? "";
          _controllerThreadsId.text =
              result['socialMediaData']['threadsId'] ?? "";
          _controllerYouTubeId.text =
              result['socialMediaData']['youtubeId'] ?? "";
          _controllerTelegramId.text =
              result['socialMediaData']['telegram'] ?? "";
          _controllerSnapChatId.text =
              result['socialMediaData']['snapchat'] ?? "";
          _controllerFreeField1.text =
              result['socialMediaData']['freeField1'] ?? "";
          _controllerFreeField2.text =
              result['socialMediaData']['freeField12'] ?? "";
          _controllerFreeField3.text =
              result['socialMediaData']['freeField13'] ?? "";
          _controllerWebsiteDomain.text =
              result['socialMediaData']['personalWebSite'] ?? "";
          _getCityData(sltStateId);
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

  _getCountryData(apiToken) async {
    setState(() {
      _load = true;
    });

    try {
      final result =
          await ApiController().post("profile/v1/country_list", {}, apiToken);
      if (!mounted) return;
      setState(() {
        _load = false;
       // debugPrint("Country data===> $countryData");

        if (result['success']) {
          countryData = result['data'];
          _getStateData();
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

  _getStateData() async {
    setState(() {
      _load = true;
    });

    try {
      final result =
          await ApiController().post("profile/v1/state_list", {}, apiToken);
      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          stateData = result['data'];
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

  _getCityData(String id) async {
    setState(() {
      _load = true;
    });
    Map data = {
      "state_id": id,
    };

    try {
      final result =
          await ApiController().post("profile/v1/district_list", data, apiToken);
      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          cityData = result['data'];
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

  _savePersonalData() async {
    setState(() {
      _load = true;
    });
    Map data = {
      "formType": "personal",
      "whatsAppNo": _controllerWhatsAppNumber.text,
      "mobileNo": _controllerMobileNumber.text,
      "surName": _controllerSurName.text,
      "name": _controllerName.text,
      "dob": _controllerDob.text,//"${_controllerDateDay.text}/${_controllerDateMonth.text}/${_controllerDateYear.text.isEmpty?"0000":_controllerDateYear.text}",
      "emailId": _controllerEmail.text,
      "profilePic": AppStyle.getVal(strProfileBase64Image),
      "physicalVisitingCardPic": AppStyle.getVal(strVisitingCardBase64Image)
    };

    //debugPrint("data-->$data");

    try {
      final result = await ApiController()
          .post("profile/v1/${getAPI(widget.update)}", data, apiToken);

      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          AppCookies.instance
              .setStringValue("name", _controllerName.text);

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

  _saveOrganizationData() async {
    setState(() {
      _load = true;
    });

    Map data = {
      "formType": "organization",
      "titleDesignation": _controllerTitleDesignation.text,
      "mobileNo": _controllerMobileNumber.text,
      "companyName": _controllerCompanyName.text,
      "landLineNoDirect": _controllerLandLineNoDirect.text,
      "landLineNoBoard": _controllerLandLineNoBoard.text,
      "country_id": sltCountryId,
      "state_id": sltStateId,
      "city_id": sltCityId,
      "pincode": _controllerPinCode.text,
      "addressLine1": _controllerAddressLine1.text,
      //"addressLine2": _controllerAddressLine2.text,
      //"addressLine3": _controllerAddressLine3.text,
      "organisationWebsite": _controllerOrganisationWebsite.text
    };

    try {
      final result = await ApiController()
          .post("profile/v1/${getAPI(widget.update)}", data, apiToken);

      if (!mounted) return;
      setState(() {
        _load = false;

        try {
          if (result['success']) {
            //cityData=result['data'];
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
        } on Exception catch (e) {
          final snackBar = SnackBar(
            content: Text(
              'Sorry! Something went wrong',
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

  _saveSocialData() async {
    setState(() {
      _load = true;
    });
    Map data = {
      "formType": "socialMedia",
      "linkedinId": _controllerLinkedId.text,
      "twitterId": _controllerTwitterId.text,
      "facebookId": _controllerFacebookId.text,
      "instagramId": _controllerInstId.text,
      "threadsId": _controllerThreadsId.text,
      "youtubeId": _controllerYouTubeId.text,
      "telegram": _controllerTelegramId.text,
      "snapchat": _controllerSnapChatId.text,
      "personalWebSite": _controllerWebsiteDomain.text,
      "freeField1": _controllerFreeField1.text,
      "freeField12": _controllerFreeField2.text,
      "freeField13": _controllerFreeField3.text
    };

    try {
      final result = await ApiController()
          .post("profile/v1/${getAPI(widget.update)}", data, apiToken);

      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          //cityData=result['data'];
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
          AppCookies.instance.setStringValue("visitData", "T");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DashboardView()));
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
    return Form(
      key: _formKey1,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppStyle.appShade,
          body: Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: MediaQuery.of(context).size.height / 14,
                  child: Container(
                    decoration: const BoxDecoration(
                      //border: Border.all(width: 0.1),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                    ),
                    child: Column(
                      children: [
                        IconStepper(
                          stepRadius: 16,
                          activeStepColor: AppStyle.appColor,
                          activeStepBorderColor: AppStyle.appColor,
                          icons: [
                            Icon(
                              FontAwesomeIcons.userTie,
                              color: Colors.white,
                              size: AppStyle.mediumIconSize,
                            ),
                            Icon(
                              FontAwesomeIcons.building,
                              color: Colors.white,
                              size: AppStyle.mediumIconSize,
                            ),
                            Icon(
                              FontAwesomeIcons.link,
                              color: Colors.white,
                              size: AppStyle.mediumIconSize,
                            ),
                          ],
                          // activeStep property set to activeStep variable defined above.
                          activeStep: activeStep,
                          // This ensures step-tapping updates the activeStep.
                          onStepReached: (index) {
                            setState(() {
                              activeStep = index;
                            });
                          },
                        ),
                        header(),
                        Padding(
                          padding: AppStyle.commonPadding,
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.handPointRight,
                                color: Colors.grey,
                                size: AppStyle.mediumIconSize,
                              ),
                              Padding(
                                padding: AppStyle.commonPadding,
                                child: Text(
                                    "Please make sure all * mark are mandatory.",
                                    style: AppStyle.appSmallTextGrey
                                        .copyWith(color: Colors.red.shade300)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: _load ? AppStyle.loading : bodyWidget())
                      ],
                    ),
                  )),
              Positioned(
                left: 0,
                right: 0,
                top: 10,
                child: Padding(
                  padding: const EdgeInsets.only(left: 04.0,top: 0,right: 4),
                  child: !widget.update?Text('Visiting Card Details',
                      style: AppStyle.appBarTextBlack,textAlign: TextAlign.center,):Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            size: AppStyle.mediumIconSize,
                            color: AppStyle.appColor,
                          ),
                        ),
                      ),
                      Text('Visiting Card Details',
                          style: AppStyle.appBarTextBlack),

                      AppStyle.wSpace,AppStyle.wSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                      child: ElevatedButton(
                        child: Text(
                          activeStep == 0
                              ? "Save & Next"
                              : activeStep == 1
                                  ? "Save & Next"
                                  : "Submit",
                          style: AppStyle.appBtnTxtStyleWhite,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey1.currentState!.validate()) {
                              if (activeStep == 0) {
                                  activeStep = 1;
                                  _savePersonalData();
                              } else if (activeStep == 1) {
                                activeStep = 2;
                                _saveOrganizationData();
                              } else if (activeStep == 2) {
                                _saveSocialData();
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget personalDetailsEdit() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        AppStyle.hSmallSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                //_chooseGallery();
                _showImagePickOption(context, "profile");
              },
              child: profilePic.isNotEmpty
                  ?
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: profilePic.isEmpty ? const Icon(FontAwesomeIcons.user)
                          : Image.network(
                        "$profilePic",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  : strProfileImagePath.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                            height: 120,
                            width: 120,
                            margin: AppStyle.commonPadding,
                            decoration: BoxDecoration(
                              color: AppStyle.appShade.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25)),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              image: DecorationImage(
                                image: strProfileImagePath.isEmpty
                                    ? const AssetImage(
                                        "assets/icon/add_user_pic.png",
                                      ) as ImageProvider
                                    : FileImage(
                                        File(strProfileImagePath.toString())),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppStyle.appShade,
                                  radius: 15,
                                  child: Icon(
                                    FontAwesomeIcons.edit,
                                    size: AppStyle.mediumIconSize,
                                    color: AppStyle.appColor,
                                  ),
                                ),
                              ],
                            )),
                      )
                      : CircleAvatar(
                          backgroundColor: AppStyle.appShade.withOpacity(0.5),
                          radius: 60,
                          child: Image.asset(
                            "assets/icon/add_user_pic.png",
                            scale: 5,
                            color: Colors.grey,
                          ),
                        ),
            ),
          ],
        ),
        AppStyle.hSmallSpace,
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerEmail,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email Id';
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.envelope,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: '*\tEnter Your Email',
              hintText: "Email",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerName,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter you first name';
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.user,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: '*\tEnter Your First Name',
              hintText: "First Name",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerSurName,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            //maxLength: 10,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.user,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Surname',
              hintText: "Surname",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerMobileNumber,
            style: AppStyle.appSmallTextBlack,
            /*keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,*/
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            //maxLength: 10,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your mobile number';
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.phone,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: '*\tEnter your mobile number',
              hintText: "Mobile Number",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerWhatsAppNumber,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            enabled: false,
            //maxLength: 10,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.whatsapp,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter your mobile number',
              hintText: "Mobile Number",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerDob,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.next,
            //maxLength: 10,
            readOnly: true,
            onTap: (){
              _showDatePicker(context);
            },
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              prefixIcon: Icon(
                FontAwesomeIcons.calendar,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              // enabled: false,
              contentPadding: const EdgeInsets.all(05),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(05.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'DD/MM/YYYY',
              hintText: "Birthday",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        /*Row(
          children: [
            Flexible(
              child: Padding(
                padding: AppStyle.commonPadding,
                child: TextFormField(
                  controller: _controllerDateDay,
                  style: AppStyle.appSmallTextBlack,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
                  //maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter day';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: AppStyle.appShade.withOpacity(0.5),
                    filled: true,
                    // enabled: false,
                    contentPadding: const EdgeInsets.all(05),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                      borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: '*\tDD',
                    hintText: "Birthday Day",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: AppStyle.commonPadding,
                child: TextFormField(
                  controller: _controllerDateMonth,
                  style: AppStyle.appSmallTextBlack,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
                  //maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter month';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: AppStyle.appShade.withOpacity(0.5),
                    filled: true,
                    contentPadding: const EdgeInsets.all(05),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                      borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: '*\tMM',
                    hintText: "Birthday Month",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: AppStyle.commonPadding,
                child: TextFormField(
                  controller: _controllerDateYear,
                  style: AppStyle.appSmallTextBlack,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
                  //maxLength: 10,
                  decoration: InputDecoration(
                    fillColor: AppStyle.appShade.withOpacity(0.5),
                    filled: true,
                    contentPadding: const EdgeInsets.all(05),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                      borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: 'YYYY(Optional)',
                    hintText: "Birthday Year",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),
            ),
          ],
        ),*/

        Padding(
            padding: AppStyle.commonPadding,
            child: Text("Current Visiting Card",
                style: AppStyle.appSmallTextBlack)),
        InkWell(
          onTap: () {
            //_chooseGallery();
            _showImagePickOption(context, "card");
          },
          child: physicalVisitingCardPic.isNotEmpty
              ? Container(
                  height: 180,
                  margin: AppStyle.commonPadding,
                  decoration: BoxDecoration(
                    color: AppStyle.appShade.withOpacity(0.5),
                    image: DecorationImage(
                        image: NetworkImage("$physicalVisitingCardPic"),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                  /*child: CachedNetworkImage(
                    imageUrl: "$physicalVisitingCardPic",
                    placeholder: (context, url) => const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()),
                      ],
                    ),
                    errorWidget: (context, url, error) =>  Icon(FontAwesomeIcons.idCard,
                      size: 50,color: Colors.grey.shade500,),
                  ),*/
                )
              : strVisitingCardImagePath.isNotEmpty
                  ? Container(
                      height: 180,
                      margin: AppStyle.commonPadding,
                      decoration: BoxDecoration(
                        color: AppStyle.appShade.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        image: DecorationImage(
                          image: FileImage(
                              File(strVisitingCardImagePath.toString())),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppStyle.appShade,
                            radius: 15,
                            child: Icon(
                              FontAwesomeIcons.edit,
                              size: AppStyle.mediumIconSize,
                              color: AppStyle.appColor,
                            ),
                          ),
                        ],
                      ))
                  : Container(
                      height: 180,
                      margin: AppStyle.commonPadding,
                      decoration: BoxDecoration(
                          color: AppStyle.appShade.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          )),
                      child: Image.asset(
                        "assets/icon/add_visi_card.png",
                        scale: 3,
                        color: Colors.grey,
                      ),
                    ),
        ),
        AppStyle.hSpace,
        /*blShowSaved
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Update",
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Save",
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {
                      */ /*if (validate(_controllerName,"Name",false) &&
                          validate(_controllerEmail,"Email",false)) {
                        //AppCookies.instance.setStringValue("visitData", "T");
                        */ /**/ /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const DashboardView()));*/ /**/ /*
                        setState(() {
                          activeStep=1;
                        });
                      }*/ /*
                      setState(() {
                        if (_formKey1.currentState!.validate()) {
                          activeStep=1;
                        }
                      });
                    },
                  ),
                ),
              )*/
      ],
    );
  }

  Widget organizationDetailsEdit() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerTitleDesignation,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title designation';
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.userTie,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: '*\tEnter Title Designation',
              hintText: "Title Designation",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerCompanyName,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter company name';
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.building,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: '*\tEnter Company Name',
              hintText: "Company Name",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerLandLineNoDirect,
            style: AppStyle.appSmallTextBlack,
            /*keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,*/
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.blenderPhone,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Land Line No. Direct',
              hintText: "Land Line No Direct",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerLandLineNoBoard,
            style: AppStyle.appSmallTextBlack,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.blenderPhone,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Land Line No. Board',
              hintText: "Land Line No Board",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerOrganisationWebsite,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.globe,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appShade, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Organisation Website',
              hintText: "Organisation Website",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: Row(
            children: [
              Flexible(
                child: SizedBox(
                  height: 50,
                  child: DropDownFormField(
                    //contentPadding:const EdgeInsets.only(8),
                    titleText: 'Country Name',
                    hintText: 'Select Country',
                    value: sltCountryId,
                    /*onSaved: (value) {
                      setState(() {
                        debugPrint("test value $value");
                        sltCountryId = value.toString();
                        // _getCompletedBatchesQuestionDetail(batchIdValue);
                      });
                    },*/
                    onChanged: (value) {
                      setState(() {
                        //debugPrint("test value $value");
                        sltCountryId = value;
                        // _getCompletedBatchesQuestionDetail(batchIdValue);
                      });
                    },
                    dataSource: countryData,
                    textField: 'name',
                    valueField: 'id',
                  ),
                ),
              ),
              AppStyle.wSpace,
              Flexible(
                child: SizedBox(
                  height: 50,
                  child: DropDownFormField(
                    //contentPadding:const EdgeInsets.only(8),
                    titleText: 'State Name',
                    hintText: 'Select State',
                    value: sltStateId,
                    /* onSaved: (value) {
                      setState(() {
                        sltStateId = value;
                        // _getCompletedBatchesQuestionDetail(batchIdValue);
                      });
                    },*/
                    onChanged: (value) {
                      setState(() {
                        sltStateId = value;
                        sltCityId="";
                        _getCityData(sltStateId);
                        // _getCompletedBatchesQuestionDetail(batchIdValue);
                      });
                    },
                    dataSource: stateData,
                    textField: 'name',
                    valueField: 'id',
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: Row(
            children: [
              Flexible(
                child: SizedBox(
                  height: 50,
                  child: DropDownFormField(
                    //contentPadding:const EdgeInsets.only(8),
                    titleText: 'City Name',
                    hintText: 'Select City',
                    value: sltCityId,
                    /*onSaved: (value) {
                      setState(() {
                        sltCityId = value;
                        // _getCompletedBatchesQuestionDetail(batchIdValue);
                      });
                    },*/
                    onChanged: (value) {
                      setState(() {
                        sltCityId = value;
                        // _getCompletedBatchesQuestionDetail(batchIdValue);
                      });
                    },
                    dataSource: cityData,
                    textField: 'name',
                    valueField: 'id',
                  ),
                ),
              ),
              AppStyle.wSpace,
              Flexible(
                child: TextFormField(
                  controller: _controllerPinCode,
                  style: AppStyle.appSmallTextBlack,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  decoration: InputDecoration(
                    fillColor: AppStyle.appShade.withOpacity(0.5),
                    filled: true,
                    contentPadding: const EdgeInsets.all(05),
                    prefixIcon: Icon(
                      FontAwesomeIcons.mapSigns,
                      color: AppStyle.appColor,
                      size: AppStyle.smallIconSize,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: AppStyle.appColor, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: 'Enter Pin Code',
                    hintText: "Pin Code",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerAddressLine1,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            //maxLength: 150,
            maxLines: 5,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.locationDot,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Address',
              hintText: "Address",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _controllerAddressLine2,
            style: AppStyle.appSmallBoldTextBlack,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            // maxLength: 150,
            maxLines: 5,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.mapMarkerAlt,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Address Line 2',
              hintText: "Address Line 2",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerAddressLine3,
            style: AppStyle.appSmallBoldTextBlack,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.done,
            //maxLength: 150,
            maxLines: 5,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.mapMarkerAlt,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Address Line 3',
              hintText: "Address Line 3",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),*/
        AppStyle.hSpace,
        /*blShowSaved
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Update",
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Save",
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {
                      */ /*if (validate(_controllerTitleDesignation,"Title Designation",false) &&
                          validate(_controllerCompanyName,"Company Name",false)) {
                        //AppCookies.instance.setStringValue("visitData", "T");
                        setState(() {
                          activeStep=2;
                        });
                      }*/ /*
                      setState(() {
                        if (_formKey1.currentState!.validate()) {
                          activeStep=2;
                        }
                      });
                    },
                  ),
                ),
              )*/
      ],
    );
  }

  Widget socialDetailsEdit() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerLinkedId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.linkedinIn,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Linkedin Id',
              hintText: "Linkedin Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerTwitterId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Image.asset(
                "assets/icon/twitter.png",
                color: AppStyle.appColor,
                scale: 4,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Twitter Id',
              hintText: "Twitter Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerFacebookId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.facebookF,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Facebook Id',
              hintText: "Facebook Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerInstId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.instagram,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide:
                BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Instagram Id',
              hintText: "Instagram Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerThreadsId,
            style: AppStyle.appSmallTextBlack,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Image.asset("assets/icon/threads.png",
                  color: AppStyle.appColor,
                  scale: 15
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide:
                BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Threads Id',
              hintText: "Enter Threads Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerSnapChatId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.snapchat,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Snapchat Id',
              hintText: "Snapchat Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerTelegramId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.telegram,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Telegram Id',
              hintText: "Telegram Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerYouTubeId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.youtube,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Youtube Id',
              hintText: "Youtube Id",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerWebsiteDomain,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.globe,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Your Personal Website Name',
              hintText: "Personal Website Name",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerFreeField1,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.link,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Any Other Field 1',
              hintText: "Any Other Field 1",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerFreeField2,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.link,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Any Other Field 2',
              hintText: "Any Other Field 2",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerFreeField3,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.link,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppStyle.appColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Enter Any Other Field 3',
              hintText: "Any Other Field 3",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        AppStyle.hSpace,
        /*blShowSaved
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Update",
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Save",
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {
                      //AppCookies.instance.setStringValue("visitData", "T");
                      if (_formKey1.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const DashboardView()));
                      }

                    },
                  ),
                ),
              )*/
      ],
    );
  }

  Widget manageTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 2,
        ),
        Text(
          "Manage Data",
          style: AppStyle.appTittleTextBlack,
        ),
        const SizedBox(
          height: 1.5,
        ),
        Text(
          "This information will be used for manage your visiting card details.",
          style: AppStyle.appSmallTextGrey,
        ),
      ],
    );
  }

  bool validate(TextEditingController _controllerName, String fieldName, bool length) {
    bool verify = false;
    if (_controllerName.text.isEmpty) {
      _controllerName.text;
      final snackBar = SnackBar(
        content: Text(
          '$fieldName Required!',
          style: AppStyle.appSmallTextAppWhite,
        ),
        backgroundColor: (Colors.black87),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      verify = false;
    } else if (length && _controllerName.text.length != 10) {
      final snackBar = SnackBar(
        content: const Text('Phone Number Should be 10 digit!'),
        backgroundColor: (Colors.black87),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      verify = false;
    } else {
      verify = true;
    }
    return verify;
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: const BoxDecoration(
        //color: AppStyle.appShade,
        //borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: AppStyle.commonPadding,
            child: Text(headerText(), style: AppStyle.appTittleTextBlack),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 0:
        return 'Personal Details';
      case 1:
        return 'Organization Details';
      case 2:
        return 'Social Media Details';
      default:
        return 'Personal Details';
    }
  }

  Widget bodyWidget() {
    switch (activeStep) {
      case 0:
        return personalDetailsEdit();
      case 1:
        return organizationDetailsEdit();
      case 2:
        return socialDetailsEdit();
      default:
        return personalDetailsEdit();
    }
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  )),
              child: Column(
                children: [
                  Flexible(
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        maximumYear: DateTime.now().year,
                        onDateTimeChanged: (DateTime val) {
                          setState(() {
                            _chosenDateTime = val;
                          });
                        }),
                  ),
                  // Close the modal
                  Padding(
                    padding: AppStyle.commonPadding,
                    child: Row(
                      children: [

                        Flexible(
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppStyle.appShade,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              child: Text(
                                'Close',
                                style: AppStyle.appBtnTxtStyleBlack,
                              ),
                              onPressed: () {
                                //_logout();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        AppStyle.wSpace,
                        Flexible(
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppStyle.appColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              child: Text(
                                'Yes',
                                style: AppStyle.appBtnTxtStyleWhite,
                              ),
                              onPressed: () {
                                _controllerDob.text =
                                    _chosenDateTime.day.toString() +
                                        "/" +
                                        _chosenDateTime.month.toString() +
                                        "/" +
                                        _chosenDateTime.year.toString();
                                Navigator.of(ctx).pop();

                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ));
  }


  void _showImagePickOption(ctx, type) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height / 3,
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextButton(
                          child: Text(
                            'Take Photo',
                            style: AppStyle.appTittleTextAppColor,
                          ),
                          onPressed: () {
                            _chooseCamera(type);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: 40,
                        child: TextButton(
                          child: Text(
                            'Choose Photo',
                            style: AppStyle.appTittleTextAppColor,
                          ),
                          onPressed: () {
                            _chooseGallery(type);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ),
                      widget.update?profilePic.isNotEmpty?const Divider():const SizedBox():const SizedBox(),
                      widget.update?profilePic.isNotEmpty?
                      SizedBox(
                        height: 40,
                        child: TextButton(
                          child: Text(
                            'Remove Photo',
                            style: AppStyle.appTittleTextAppColor,
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            if(type=="profile"){
                              _removeProfile();
                            }else{
                              _removeProfileCard();
                            }
                          },
                        ),
                      ):const SizedBox():const SizedBox(height: 5,)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    child: Text(
                      'Cancel',
                      style: AppStyle.appBtnTxtStyleAppColor,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )));
  }

  void _chooseGallery(String type) async {
    XFile? file;
    file = (await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 570,
        maxWidth: 1036,
        imageQuality: 100))!;
    if (file != null) {
      _cropImage(file.path, type);
      /*setState(() {
        if (type == "profile") {
          String fileName = file!.path.split('/').last;
          strProfileImagePath = file.path;
          final bytes = File(file.path).readAsBytesSync();
          strProfileBase64Image = base64Encode(bytes);
          debugPrint("Image base64-->$strProfileBase64Image");
        } else {
          String fileName = file!.path.split('/').last;
          strVisitingCardImagePath = file.path;
          final bytes = File(file.path).readAsBytesSync();
          strVisitingCardBase64Image = base64Encode(bytes);
          debugPrint("Image base64-->$strVisitingCardBase64Image");
        }
      });*/
    }
  }

  void _chooseCamera(String type) async {
    XFile? file;
    file = (await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 570,
        maxWidth: 1036,
        imageQuality: 100))!;
    if (file != null) {
      /*setState(() {
        if (type == "profile") {
          String fileName = file!.path.split('/').last;
          strProfileImagePath = file.path;
          final bytes = File(file.path).readAsBytesSync();
          strProfileBase64Image = base64Encode(bytes);
          //debugPrint("Image base64-->$strProfileBase64Image");
        } else {
          String fileName = file!.path.split('/').last;
          strVisitingCardImagePath = file.path;
          final bytes = File(file.path).readAsBytesSync();
          strVisitingCardBase64Image = base64Encode(bytes);
          debugPrint("Image base64-->$strVisitingCardBase64Image");
        }
      });*/
      _cropImage(file.path, type);
    }
  }

  Future<void> _cropImage(imagePath, type) async {
    if (imagePath != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper Your File',
              toolbarColor: Colors.teal,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper Your File',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          if (type == "profile") {
            profilePic="";
            strProfileImagePath = croppedFile.path;
            final bytes = File(strProfileImagePath).readAsBytesSync();
            strProfileBase64Image = base64Encode(bytes);
           // debugPrint("CropFile-->$strProfileBase64Image");
          } else {
            physicalVisitingCardPic="";
            strVisitingCardImagePath = croppedFile.path;
            final bytes = File(strVisitingCardImagePath).readAsBytesSync();
            strVisitingCardBase64Image = base64Encode(bytes);
           // debugPrint("Image base64-->$strVisitingCardBase64Image");
          }
        });
      }
    }
  }

  String getAPI(bool check) {
    if (check) {
      return "profileupdate";
    } else {
      return "profilestore";
    }
  }

  _removeProfile() async {
    setState(() {
      _load = true;
    });

    try {
      final result =
      await ApiController().post("profile/v1/profilePic/remove", {}, apiToken);
      if (!mounted) return;
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
          _getUserProfileData();
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
  _removeProfileCard() async {
    setState(() {
      _load = true;
    });

    try {
      final result =
      await ApiController().post("profile/v1/profileCard/remove", {}, apiToken);
      if (!mounted) return;
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
          _getUserProfileData();
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
}
