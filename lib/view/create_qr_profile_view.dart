import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
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

class CreateQRProfileView extends StatefulWidget {
  final bool update;

  const CreateQRProfileView({super.key, required this.update});

  @override
  State<CreateQRProfileView> createState() => _CreateQRProfileViewState();
}

class _CreateQRProfileViewState extends State<CreateQRProfileView> {
//personal details controller
  late String strProfileImagePath = "", strProfileBase64Image = "";
  final TextEditingController _controllerSurName = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerWhatsAppNumber = TextEditingController();
  //final TextEditingController _controllerMobileNumber = TextEditingController();
  final TextEditingController _controllerMobileNumber2 = TextEditingController();
  final TextEditingController _controllerBloodGroup = TextEditingController();

  //origination details
  final TextEditingController _controllerTitleDesignation =
  TextEditingController();
  final TextEditingController _controllerCompanyName = TextEditingController();
  final TextEditingController _controllerLandLineNoDirect =
  TextEditingController();
  final TextEditingController _controllerLandLineNoBoard =
  TextEditingController();
  final TextEditingController _controllerLandLineNoBoardExtension =
  TextEditingController();
  final TextEditingController _controllerOrganisationWebsite =
  TextEditingController();
  final TextEditingController _controllerPinCode = TextEditingController();
  final TextEditingController _controllerAddressLine1 = TextEditingController();
  late String sltCountryId = "", sltStateId = "", sltCityId = "",sltBloodGroupId = "";
  String strVisitingCardImagePath = "", strVisitingCardBase64ImageFront = "",strVisitingCardBase64ImageBack="";
  List countryData = [];
  List stateData = [];
  List cityData = [];
  List bloodGroup = [
    {
      "name":"Select Blood Group",
      "id":"Select Blood Group"
    },
    {
      "name":"A+",
      "id":"A+"
    },
    {
      "name":"A-",
      "id":"A-"
    },
    {
      "name":"B+",
      "id":"B+"
    },
    {
      "name":"B-",
      "id":"B-"
    },
    {
      "name":"O+",
      "id":"O+"
    },{
      "name":"O-",
      "id":"O-"
    },
    {
      "name":"AB+",
      "id":"AB+"
    },{
      "name":"AB-",
      "id":"AB-"
    }

  ];

  int activeStep = 0; // Initial step set to 5.
  int upperBound = 2; // upperBound MUST BE total number of icons minus 1.
  late String apiToken;
  bool _load = false;
  String  profilePic = "",physicalCardFront="",physicalCardBack="",
      physicalCardFrontNetwork="",physicalCardBackNetwork="";
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

      }));
    } else {
      AppCookies.instance
          .getStringValue("whatsAppNumber")
          .then((value) => setState(() {
        _controllerWhatsAppNumber.text = value;
      }));
      AppCookies.instance
          .getStringValue("apiToken")
          .then((value) => setState(() {
        apiToken = value;
        //_getCountryData(value);
        _getUserProfileData();
        // debugPrint("apiToken===> $apiToken");
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
          _controllerWhatsAppNumber.text=result['personalData']['whatsAppNo']??"";

          _controllerMobileNumber2.text =
              result['personalData']['mobileNo2'] ?? "";
          _controllerSurName.text = result['personalData']['surName'] ?? "";
          _controllerName.text = result['personalData']['name'] ?? "";
          AppCookies.instance
              .setStringValue("name", result['personalData']['name']);
          _controllerDob.text=result['personalData']['dob'] ?? "";
          _controllerEmail.text = result['personalData']['emailId'] ?? "";
          profilePic = result['personalData']['profilePic'] ?? "";
          physicalCardFrontNetwork =
              result['personalData']['physicalVisitingCardPic'] ?? "";
          physicalCardBackNetwork =
              result['personalData']['physicalVisitingCardPicBack'] ?? "";
          sltBloodGroupId =
              result['personalData']['bloodGroup'] ?? "";
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

           _controllerLandLineNoBoardExtension.text = result['organizationData']['ext_no'] ?? "";

          // _controllerAddressLine3.text = result['organizationData']['addressLine3'] ?? "";

          _controllerOrganisationWebsite.text =
              result['organizationData']['organisationWebsite'] ?? "";

          _getStateData(sltCountryId);
          //_getCityData(sltStateId);

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
          _getStateData(sltCountryId);
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

  _getStateData(String id) async {
    setState(() {
      _load = true;
    });

    Map data = {
      "country_id": id,
    };

    //debugPrint("data--> $data");
    try {
      final result =
      await ApiController().post("profile/v1/state_list", data, apiToken);
      //debugPrint("response data--> $result");
      if (!mounted) return;
      setState(() {
        _load = false;

        if (result['success']) {
          stateData = result['data'];
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
      "whatsAppNo":_controllerWhatsAppNumber.text,
      "bloodGroup":sltBloodGroupId,
      "surName": _controllerSurName.text,
      "name": _controllerName.text,
      "dob": _controllerDob.text,
      "emailId": _controllerEmail.text,
      "profilePic": AppStyle.getVal(strProfileBase64Image),
      "physicalVisitingCardPic": AppStyle.getVal(strVisitingCardBase64ImageFront),
      "physicalVisitingCardPicBack": AppStyle.getVal(strVisitingCardBase64ImageBack),
      "titleDesignation": _controllerTitleDesignation.text,
      "mobileNo": _controllerMobileNumber2.text,
      "mobileNo2": _controllerMobileNumber2.text,
      "companyName": _controllerCompanyName.text,
      "landLineNoDirect": _controllerLandLineNoDirect.text,
      "landLineNoBoard": _controllerLandLineNoBoard.text,
      "ext_no":_controllerLandLineNoBoardExtension.text,
      "country_id": sltCountryId,
      "state_id": sltStateId,
      "city_id": sltCityId,
      "pincode": _controllerPinCode.text,
      "addressLine1": _controllerAddressLine1.text,
      "organisationWebsite": _controllerOrganisationWebsite.text,
    };

   // debugPrint("data-->$data");

    try {
      final result = await ApiController()
          .post("profile/${getAPIs(widget.update)}", data, apiToken);

      //debugPrint(" profile/${getAPIs(widget.update)} result-->$result");

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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SocialMediaQRDataView(update: widget.update))).then((value) => _getUserProfileData());
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

  void captureDoc(String cardType) async {

    try {
       setState(() {
         _load=true;
       });

      // Initialize with your licence key
      await FlutterGeniusScan.setLicenceKey('533c50065d5f0809095d035539525a0e4a0a4601575e504c06524d485355596f53025d5b010504035006');

      // Start scan flow
      var scanConfiguration = {
        'source': 'camera',
        'multiPage': false,
        'jpegQuality':80,
        'defaultFilter':'none'
      };
      var scanResult = await FlutterGeniusScan.scanWithConfiguration(scanConfiguration);

      // Here is how you can display the resulting document:
      String documentUrl = scanResult['scans'][0]['enhancedUrl'];
      // await OpenFile.open(documentUrl.replaceAll("file://", ''));
      if (!mounted) return;
      setState(() {
        _load=false;
        if(cardType=="F"){
          physicalCardFront = documentUrl.replaceAll("file://", '');
          final bytes = File(physicalCardFront).readAsBytesSync();
          strVisitingCardBase64ImageFront = base64Encode(bytes);
          _sendBusinessCardImage(strVisitingCardBase64ImageFront,cardType);
        }else{
          physicalCardBack = documentUrl.replaceAll("file://", '');
          final bytes = File(physicalCardBack).readAsBytesSync();
          strVisitingCardBase64ImageBack = base64Encode(bytes);
          _sendBusinessCardImage(strVisitingCardBase64ImageBack,cardType);
        }
      });

    } on PlatformException catch (error) {
      //Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message!)));
    }
  }

  _sendBusinessCardImage(String strVisitingCardBase64Image,String cardType) async{

    setState(() {
      _load=true;
    });

    Map data={
      "scannedcard": strVisitingCardBase64Image
    };
    // debugPrint("send base64 data -->$data");
    try {
      final  result=await ApiController().post("profile/v1/scan/card",data,apiToken);
      // debugPrint("response from API -->$result");
      setState(() {
        _load = false;

        if (result['success']) {

          if(cardType=="F"){
            String? contactNames=result['analyzeData']['FirstName']??result['analyzeData']['ContactNames'];
            String? contactSureName=result['analyzeData']['LastName']??"";

            String? mobilePhones=result['analyzeData']['MobilePhones']??"";
            String? email=result['analyzeData']['Emails']??"";
            String? workPhones=result['analyzeData']['WorkPhones']??"";
            String? workPhones1=result['analyzeData']['WorkPhones1']??"";
            String? jobTitles=result['analyzeData']['JobTitles']??"";
            String? companyNames=result['analyzeData']['CompanyNames']??"";
            String? addresses=result['analyzeData']['Addresses']??"";

            _controllerName.text=contactNames!;
            _controllerSurName.text=contactSureName!;
            _controllerMobileNumber2.text=mobilePhones!;
            _controllerEmail.text=email!;
            _controllerLandLineNoDirect.text=workPhones!;
            _controllerLandLineNoBoard.text=workPhones1!;
            _controllerTitleDesignation.text=jobTitles!;
            _controllerCompanyName.text=companyNames!;
            _controllerAddressLine1.text=addresses!;
          }else{
            String? contactNames=result['analyzeData']['FirstName']??result['analyzeData']['ContactNames'];
            String? contactSureName=result['analyzeData']['LastName']??"";

            String? mobilePhones=result['analyzeData']['MobilePhones']??"";
            String? email=result['analyzeData']['Emails']??"";
            String? workPhones=result['analyzeData']['WorkPhones']??"";
            String? workPhones1=result['analyzeData']['WorkPhones1']??"";
            String? jobTitles=result['analyzeData']['JobTitles']??"";
            String? companyNames=result['analyzeData']['CompanyNames']??"";
            String? addresses=result['analyzeData']['Addresses']??"";

            if(_controllerName.text.isEmpty){
              _controllerName.text=contactNames!;
            }
            if(_controllerSurName.text.isEmpty){
              _controllerSurName.text=contactSureName!;
            }
            if(_controllerMobileNumber2.text.isEmpty){
              _controllerMobileNumber2.text=mobilePhones!;
            }
            if(_controllerEmail.text.isEmpty){
              _controllerEmail.text=email!;
            }
            if(_controllerLandLineNoDirect.text.isEmpty){
              _controllerLandLineNoDirect.text=workPhones!;
            }
            if(_controllerLandLineNoBoard.text.isEmpty){
              _controllerLandLineNoBoard.text=workPhones1!;
            }
            if(_controllerTitleDesignation.text.isEmpty){
              _controllerTitleDesignation.text=jobTitles!;
            }
            if(_controllerCompanyName.text.isEmpty){
              _controllerCompanyName.text=companyNames!;
            }
            if(_controllerAddressLine1.text.isEmpty){
              _controllerAddressLine1.text=addresses!;
            }

          }

        }
        else {
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //Navigator.of(context).pop();
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
        //Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey1,
      child: SafeArea(
        child: Scaffold(
          //backgroundColor: AppStyle.appShade,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppStyle.appShade,
            leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                FontAwesomeIcons.arrowLeft,
                size: AppStyle.mediumIconSize,
                color: AppStyle.appColor,
              ),
            ),
            elevation: 0,
            title: Text("Data for QR Code",style: AppStyle.appBarTextBlack,),
          ),
          body: _load ? Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppStyle.loading,
          )) : personalDetailsEdit(),
          bottomNavigationBar: _load ? AppStyle.hSmallSpace :Container(
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: ElevatedButton(
                  child: Text(
                    "Save & Next",
                    style: AppStyle.appBtnTxtStyleWhite,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_formKey1.currentState!.validate()) {
                        _savePersonalData();
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
        /*Padding(
          padding: AppStyle.commonPadding,
          child: Text("Personal Details", style: AppStyle.appTittleTextBlack),
        ),*/
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        captureDoc("F");
                      },
                      child: Container(
                        height: 40,
                        //width: MediaQuery.of(context).size.width / 1.4,
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
                            "Scan Front Card(optional)",
                            style: AppStyle.appSmallTextBlack
                                .copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                      ),
                    ),
                    AppStyle.hSmallSpace,
                    physicalCardFront.isNotEmpty?Container(
                        height: 100,
                        width: 180,
                        //margin: AppStyle.commonPadding,
                        decoration: BoxDecoration(
                          color: AppStyle.appShade.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                            image: FileImage(
                                File(physicalCardFront.toString())),
                            fit: BoxFit.fill,
                          ),
                        ),):physicalCardFrontNetwork.isEmpty?const SizedBox():
                    InkWell(
                      onTap: () {
                        if(widget.update){
                          _showCardDialog(physicalCardFrontNetwork,"F");
                        }
                      },
                      child: Container(
                        height: 100,
                        //width: 180,
                        //margin: AppStyle.commonPadding,
                        decoration: BoxDecoration(
                          color: AppStyle.appShade.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                                 physicalCardFrontNetwork.toString()),
                            fit: BoxFit.fill,
                          ),
                        ),),
                    ),
                  ],
                ),
              ),
              AppStyle.wSpace,
              Flexible(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        captureDoc("B");
                      },
                      child: Container(
                        height: 40,
                        //width: MediaQuery.of(context).size.width / 1.4,
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
                            "Scan Back Card(optional)",
                            style: AppStyle.appSmallTextBlack
                                .copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                      ),
                    ),
                    AppStyle.hSmallSpace,
                    physicalCardBack.isNotEmpty?Container(
                        height: 100,
                        //width: 180,
                        //margin: AppStyle.commonPadding,
                        decoration: BoxDecoration(
                          color: AppStyle.appShade.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                            image: FileImage(
                                File(physicalCardBack.toString())),
                            fit: BoxFit.fill,
                          ),
                        ),):physicalCardBackNetwork.isEmpty?const SizedBox():
                    InkWell(
                      onTap: () {
                        if(widget.update){
                          _showCardDialog(physicalCardBackNetwork,"B");
                        }
                      },
                      child: Container(
                        height: 100,
                        //width: 180,
                        //margin: AppStyle.commonPadding,
                        decoration: BoxDecoration(
                          color: AppStyle.appShade.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                                physicalCardBackNetwork.toString()),
                            fit: BoxFit.fill,
                          ),
                        ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerName,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
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
              //hintText: '* Enter First Name',
              labelText: "*\tFirst Name",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),// first name
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
              //hintText: 'Enter Surname',
              labelText: "Surname",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),//sure name
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerTitleDesignation,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
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
              //hintText: 'Enter Designation',
              labelText: "Title Designation",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),//Designation
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerCompanyName,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
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
              //hintText: 'Enter Company Name',
              labelText: "Company Name",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),//Company Name
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
                        sltStateId="";
                        sltCityId="";
                        _getStateData(sltCountryId);
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
                  textInputAction: TextInputAction.done,
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
                    //hintText: 'Enter Pin Code',
                    labelText: "Pin Code",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),
            ],
          ),
        ),//city and pin
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
              //hintText: 'Enter Address',
              labelText: "Address",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),//address full
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerEmail,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
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
              //hintText: 'Enter Email',
              labelText: "Email",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),//email
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
              //hintText: 'Enter whatsApp number',
              labelText: "WhatsApp Number",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerMobileNumber2,
            style: AppStyle.appSmallTextBlack,
            /*keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,*/
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            //maxLength: 10,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.mobilePhone,
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
              //hintText: 'Enter mobile number 2',
              labelText: "Mobile Number 2",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),//mobile2
        /*Padding(
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
        ),*///

        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerLandLineNoDirect,
            style: AppStyle.appSmallTextBlack,
            /*keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,*/
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              /*prefixIcon: Icon(
                FontAwesomeIcons.blenderPhone,
                color: AppStyle.appColor,
                size: AppStyle.smallIconSize,
              ),*/
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
              //hintText: 'Enter Land Line No. Direct',
              labelText: "Land Line No Direct",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),//direct landline
        Padding(
          padding: AppStyle.commonPadding,
          child: Row(
            children: [

              Flexible(
                flex: 2,
                child: TextFormField(
                  controller: _controllerLandLineNoBoard,
                  style: AppStyle.appSmallTextBlack,
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  decoration: InputDecoration(
                    fillColor: AppStyle.appShade.withOpacity(0.5),
                    filled: true,
                    contentPadding: const EdgeInsets.all(05),
                    /*prefixIcon: Icon(
                      FontAwesomeIcons.blenderPhone,
                      color: AppStyle.appColor,
                      size: AppStyle.smallIconSize,
                    ),*/
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
                    //hintText: 'Enter Land Line No. Board',
                    labelText: "Land Line No Board",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),
              AppStyle.wSpace,
              Flexible(
                child: TextFormField(
                  controller: _controllerLandLineNoBoardExtension,
                  style: AppStyle.appSmallTextBlack,
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  decoration: InputDecoration(
                    fillColor: AppStyle.appShade.withOpacity(0.5),
                    filled: true,
                    contentPadding: const EdgeInsets.all(05),
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
                   // hintText: 'Enter Extension',
                    labelText: "Extension",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),

            ],
          ),
        ),//board landline
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerOrganisationWebsite,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.url,
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
              //hintText: 'Enter Organisation Website',
              labelText: "Organisation Website",
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
                    titleText: 'Blood Group',
                    hintText: 'Select',
                    value: sltBloodGroupId,
                    onChanged: (value) {
                      setState(() {
                        sltBloodGroupId = value;
                        //debugPrint("selected blood-->$sltBloodGroupId");
                      });
                    },
                    dataSource: bloodGroup,
                    textField: 'name',
                    valueField: 'id',
                  ),
                ),
              ),
              AppStyle.wSpace,
              Flexible(
                child: TextFormField(
                  controller: _controllerDob,
                  style: AppStyle.appSmallTextBlack,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
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
                    /*suffixIcon: InkWell(
                      onTap: (){
                        setState(() {
                          _controllerDob.text="";
                        });
                      },
                      child: Icon(
                        FontAwesomeIcons.xmark,
                        color: AppStyle.appColor,
                        size: AppStyle.smallIconSize,
                      ),
                    ),*/
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
                    hintText: 'Select Birthday',
                    labelText: "Birthday",
                    hintStyle: AppStyle.appSmallTextAppColor,
                    labelStyle: AppStyle.appSmallTextGrey,
                  ),
                ),
              ),
            ],
          ),
        ),//dob
        /*Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerBloodGroup,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              prefixIcon: Icon(
                FontAwesomeIcons.kitMedical,
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
              labelText: 'Blood Group',
              hintText: "Enter Blood Group",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding: AppStyle.commonPadding,
          child: SizedBox(
            height: 50,
            child: DropDownFormField(
              //contentPadding:const EdgeInsets.only(8),
              titleText: 'Blood Group',
              hintText: 'Select Blood Group',
              value: sltBloodGroupId,
              onChanged: (value) {
                setState(() {
                  sltBloodGroupId = value;

                });
              },
              dataSource: bloodGroup,
              textField: 'name',
              valueField: 'id',
            ),
          ),
        ),*/
        AppStyle.hSpace,
      ],
    );
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height / 2,
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
              _controllerDob.text.isNotEmpty?Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppStyle.appColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    child: Text(
                      'Click here to Delete Birthday',
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _controllerDob.text ="";
                    },
                  ),
                ),
              ):const SizedBox(),
              Padding(
                padding: AppStyle.commonPadding,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppStyle.appColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    child: Text(
                      'Set Birthday',
                      style: AppStyle.appBtnTxtStyleWhite,
                    ),
                    onPressed: () {
                      _controllerDob.text =
                      "${_chosenDateTime.day}/${_chosenDateTime.month}/${_chosenDateTime.year}";
                      Navigator.of(ctx).pop();

                    },
                  ),
                ),
              ),
              Padding(
                padding: AppStyle.commonPadding,
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
          }
        });
      }
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
  _removeProfileCardBack() async {
    setState(() {
      _load = true;
    });

    try {
      final result =
      await ApiController().post("profile/v1/profileCardBack/remove", {}, apiToken);
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

  _showCardDialog(String pic,String type) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            margin: AppStyle.commonPadding,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      image: DecorationImage(
                        image:NetworkImage(pic),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: AppStyle.commonPadding,
                  child: Row(
                    children: [
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
                              'Remove Card',
                              style: AppStyle.appBtnTxtStyleWhite,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if(type=="F"){
                                _removeProfileCard();
                              }else{
                                _removeProfileCardBack();
                              }

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
                            color: AppStyle.appShade,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            child: Text(
                              'Cancel',
                              style: AppStyle.appBtnTxtStyleBlack,
                            ),
                            onPressed: () {
                              //_logout();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            )));
  }

  String getAPIs(bool check) {
    if (check) {
      return "v1/profileupdate";
    } else {
      return "v2/profilestore";
    }
  }

}


class SocialMediaQRDataView extends StatefulWidget {
  final bool update;

  const SocialMediaQRDataView({super.key, required this.update});

  @override
  State<SocialMediaQRDataView> createState() => _SocialMediaQRDataViewState();
}

class _SocialMediaQRDataViewState extends State<SocialMediaQRDataView> {

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
  late String whatsAppNo;
  String apiToken="";
  bool _load = false;
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {

    if (!widget.update) {
      AppCookies.instance.getStringValue("apiToken").then((value) => setState(() {
        apiToken = value;
        //debugPrint("api-->token $apiToken");
        if(apiToken.isEmpty){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginView()));
        }
      }));
      AppCookies.instance
          .getStringValue("whatsAppNumber")
          .then((value) => setState(() {
        //_controllerWhatsAppNumber.text = value;
        whatsAppNo = value;
      }));
    } else {
      AppCookies.instance
          .getStringValue("whatsAppNumber")
          .then((value) => setState(() {
        //_controllerWhatsAppNumber.text = value;
        whatsAppNo = value;
      }));
      AppCookies.instance.getStringValue("apiToken").then((value) => setState(() {
        apiToken = value;
        if(apiToken.isEmpty){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginView()));
        }else{
          _getUserProfileData();
        }
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
          whatsAppNo=result['personalData']['whatsAppNo']??"";
          AppCookies.instance
              .setStringValue("name", result['personalData']['name']);

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
          //backgroundColor: AppStyle.appShade,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppStyle.appShade,
            leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                FontAwesomeIcons.arrowLeft,
                size: AppStyle.mediumIconSize,
                color: AppStyle.appColor,
              ),
            ),
            elevation: 0,
            title: Text("Data for QR Code",style: AppStyle.appBarTextBlack,),
          ),
          body: _load ? Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppStyle.loading,
          )) : socialDetailsEdit(),
          bottomNavigationBar: _load ? AppStyle.hSmallSpace :Container(
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: ElevatedButton(
                  child: Text(
                    "Save & Exit",
                    style: AppStyle.appBtnTxtStyleWhite,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_formKey1.currentState!.validate()) {
                        _saveSocialData();
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

  Widget socialDetailsEdit() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        /*Padding(
          padding: AppStyle.commonPadding,
          child: Text("Social Media Details", style: AppStyle.appTittleTextBlack),
        ),*/
        AppStyle.hSmallSpace,
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerLinkedId,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
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
              labelText: 'Linkedin Id',
              //hintText: "Linkedin Id",
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
            textInputAction: TextInputAction.done,
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
              labelText: 'Twitter Id',
              //hintText: "Twitter Id",
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
            textInputAction: TextInputAction.done,
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
              labelText: 'Facebook Id',
              //hintText: "Facebook Id",
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
            textInputAction: TextInputAction.done,
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
              labelText: 'Instagram Id',
              //hintText: "Instagram Id",
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
            textInputAction: TextInputAction.done,
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
            textInputAction: TextInputAction.done,
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
              labelText: 'Snapchat Id',
              //hintText: "Snapchat Id",
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
            textInputAction: TextInputAction.done,
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
              labelText: 'Telegram Id',
             // hintText: "Telegram Id",
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
            textInputAction: TextInputAction.done,
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
              labelText: 'Youtube Id',
              //hintText: "Youtube Id",
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
              labelText: 'Personal Website Name',
              //hintText: "Personal Website Name",
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
              labelText: 'Any Other Field 1',
             // hintText: "Any Other Field 1",
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
              labelText: 'Any Other Field 2',
             // hintText: "Any Other Field 2",
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
              labelText: 'Any Other Field 3',
              //hintText: "Any Other Field 3",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        AppStyle.hSpace,

      ],
    );
  }
}


String getAPI(bool check) {
  if (check) {
    return "profileupdate";
  } else {
    return "profilestore";
  }
}