import 'package:contacts_service/contacts_service.dart';
//import 'package:cunning_document_scanner/cunning_document_scanner.dart';
//import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:dmi/controller/api_controller.dart';
import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:dmi/view/saved_business_card_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'login_view.dart';

class ScanCardView extends StatefulWidget {
  final  String id,view,fullName,companyName,jobTittle,address,officeContact,email,phone,profilePic,dob;

  const ScanCardView({super.key, required this.view, required this.fullName, required this.companyName, required this.jobTittle, required this.address, required this.officeContact, required this.email, required this.phone, required this.profilePic, required this.id, required this.dob});


  @override
  State<ScanCardView> createState() => _ScanCardViewState();
}

class _ScanCardViewState extends State<ScanCardView> {
  late String apiToken,qrData="QR_DATA";

  bool _load=true;
  //business card
  String strVisitingCardImagePath = "", strVisitingCardBase64Image = "",physicalVisitingCardPic="";
  //scan card data
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerCompanyName = TextEditingController();
  final TextEditingController _controllerJobTittle = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerOfficeContact = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();
  late String profilePic;
  String _pictures = "";
 // List<String> _pictures = [];
  late DateTime _chosenDateTime;
  @override
  void initState() {
    AppCookies.instance
        .getStringValue("apiToken")
        .then((value) => setState(() {
      apiToken = value;
      if(apiToken.isEmpty){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView()));
      }else{
        if(widget.view=="F"){
          //_chooseCamera();
          captureDoc();
        }else{
          _load=false;
          _controllerFullName.text = widget.fullName;
          _controllerCompanyName.text = widget.companyName;
          _controllerJobTittle.text = widget.jobTittle;
          _controllerAddress.text = widget.address;
          _controllerOfficeContact.text = widget.officeContact;
          _controllerPhoneNumber.text = widget.phone;
          _controllerEmail.text = widget.email;
          profilePic=widget.profilePic;
          _controllerDob.text=widget.dob;
        }
      }

    }));

    super.initState();
  }

  void captureDoc() async {
    /*List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _load=false;
        _pictures = pictures;
        final bytes = File(_pictures.first).readAsBytesSync();
        strVisitingCardBase64Image = base64Encode(bytes);
        _sendBusinessCardImage(strVisitingCardBase64Image);
      });
    } catch (exception) {
      // Handle exception here
      //debugPrint("error--> ${exception.toString()}");
      Navigator.of(context).pop();
    }*/
    try {

      // Copy OCR language file
     // var languageFolder = await copyLanguageFile();

      // Initialize with your licence key
      await FlutterGeniusScan.setLicenceKey('533c50065d510206095c025439525a0e4a0a4601575e504c06524d485355596f53025d550a0307035d0b');

      // Start scan flow
      var scanConfiguration = {
        'source': 'camera',
        'multiPage': false,
        'jpegQuality':80,
        'defaultFilter':'photo'
      };
      var scanResult = await FlutterGeniusScan.scanWithConfiguration(scanConfiguration);

      //debugPrint("scanResult--> ${scanResult['scans']}");
      //debugPrint("enhancedUrl scanResult--> ${scanResult['scans'][0]['enhancedUrl']}");
      //debugPrint("scanResult--> ${scanResult['originalUrl']}");
      //debugPrint("scanResult--> ${scanResult['multiPageDocumentUrl']}");
      //debugPrint("scanResult--> ${scanResult['pdfUrl']}");


      // Here is how you can display the resulting document:
      String documentUrl = scanResult['scans'][0]['enhancedUrl'];
     // await OpenFile.open(documentUrl.replaceAll("file://", ''));
      if (!mounted) return;
      setState(() {
        _load=false;
        _pictures = documentUrl.replaceAll("file://", '');
        final bytes = File(_pictures).readAsBytesSync();
        strVisitingCardBase64Image = base64Encode(bytes);
        _sendBusinessCardImage(strVisitingCardBase64Image);
      });

    } on PlatformException catch (error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          title: Text("Card Details",style: AppStyle.appBarTextBlack,),
        ),
        body: _load?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: AppStyle.loading),
        ):Container(
            //height: MediaQuery.of(context).size.height/1.2,
            width: MediaQuery.of(context).size.width,
            //margin: AppStyle.commonPadding,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*for (var picture in _pictures)*/
                widget.view=="F"?Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  //margin: AppStyle.commonPadding,
                  decoration: BoxDecoration(
                      color: AppStyle.appShade.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      image:DecorationImage(
                        image: FileImage(
                            File(_pictures)),
                        fit: BoxFit.fill,
                      )
                  ),):Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  //margin: AppStyle.commonPadding,
                  decoration: BoxDecoration(
                      color: AppStyle.appShade.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      image:DecorationImage(
                        image: NetworkImage(
                            widget.profilePic),
                        fit: BoxFit.fill,
                      )
                  ),),
                    const Divider(height: 10,),
                    widget.view=="F"?Padding(
                      padding: AppStyle.commonPadding,
                      child: Text("Edit Card Details",style: AppStyle.appSmallTextAppColor,),
                    ):const SizedBox(),
                Flexible(
                  child: ListView(
                    children: [
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
                            labelText: 'Birthday(Optional)',
                            //hintText: "Birthday Day(Optional)",
                            hintStyle: AppStyle.appSmallTextAppColor,
                            labelStyle: AppStyle.appSmallTextGrey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _controllerFullName,
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
                              labelText: 'Full Name',
                              //hintText: "Full Name",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _controllerEmail,
                            style: AppStyle.appSmallTextBlack,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            //maxLength: 10,
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
                              labelText: 'Email Id',
                              //hintText: "Email",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _controllerPhoneNumber,
                            style: AppStyle.appSmallTextBlack,
                            textInputAction: TextInputAction.done,
                            keyboardType: const TextInputType.numberWithOptions(signed: true),
                            //maxLength: 10,
                            decoration: InputDecoration(
                              fillColor: AppStyle.appShade.withOpacity(0.5),
                              filled: true,
                              contentPadding: const EdgeInsets.all(05),
                              prefixIcon: Icon(
                                FontAwesomeIcons.squarePhone,
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
                              labelText: 'Phone Number',
                              //hintText: "Phone Number",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _controllerJobTittle,
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
                              labelText: 'Designation',
                              //hintText: "Designation",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _controllerCompanyName,
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
                              labelText: 'Company',
                              //hintText: "Company",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _controllerOfficeContact,
                            style: AppStyle.appSmallTextBlack,
                            //keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            keyboardType: const TextInputType.numberWithOptions(signed: true),
                            //maxLength: 10,
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
                              labelText: 'Office Contact Number',
                              //hintText: "Number",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child:TextFormField(
                          controller: _controllerAddress,
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
                            labelText: 'Address',
                            //hintText: "Address",
                            hintStyle: AppStyle.appSmallTextAppColor,
                            labelStyle: AppStyle.appSmallTextGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1.5,
                      ),


                    ],
                  ),
                ) ,
              ],
            )),
        bottomNavigationBar: _load?const SizedBox():widget.view=="F"?Container(
          padding: AppStyle.commonPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 35,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      'Save in App',
                      style: AppStyle.appSmallTextAppWhite,
                    ),
                    onPressed: () async {
                      //_showDOB(context);
                      _saveBusinessCard();
                    },
                  ),
                ),
              ),
              AppStyle.wSpace,
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 35,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      'Save in Contact & App',
                      style: AppStyle.appSmallTextAppWhite,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      //Navigator.of(context).pop();
                      //_saveBusinessCard();
                      saveContactInPhone(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ):Container(
          padding: AppStyle.commonPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 35,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      'Save in App',
                      style: AppStyle.appSmallTextAppWhite,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {

                      _updateBusinessCard();

                    },
                  ),
                ),
              ),
              AppStyle.wSpace,
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: AppStyle.commonPadding,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      'Save in Contact & App',
                      style: AppStyle.appSmallTextAppWhite,
                    ),
                    onPressed: () async {

                      saveContactInPhone(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  _sendBusinessCardImage(String strVisitingCardBase64Image) async{

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

          String? contactNames=result['analyzeData']['ContactNames']??"";
          String? mobilePhones=result['analyzeData']['MobilePhones']??"";
          String? email=result['analyzeData']['Emails']??"";
          String? workPhones=result['analyzeData']['WorkPhones']??"";
          String? jobTitles=result['analyzeData']['JobTitles']??"";
          String? companyNames=result['analyzeData']['CompanyNames']??"";
          String? addresses=result['analyzeData']['Addresses']??"";

          _controllerFullName.text=contactNames!;
          _controllerPhoneNumber.text=mobilePhones!;
          _controllerEmail.text=email!;
          _controllerOfficeContact.text=workPhones!;
          _controllerJobTittle.text=jobTitles!;
          _controllerCompanyName.text=companyNames!;
          _controllerAddress.text=addresses!;

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

  _saveBusinessCard() async{

    setState(() {
      _load=true;
    });

    Map data={
      "dob": _controllerDob.text,
      "contactName":_controllerFullName.text,
      "companyName":_controllerCompanyName.text,
      "email":_controllerEmail.text,
      "jobTitle":_controllerJobTittle.text,
      "mobileNo":_controllerPhoneNumber.text,
      "workPhoneno":_controllerOfficeContact.text,
      "address":_controllerAddress.text,
      "scannedcard": strVisitingCardBase64Image,
      //getDOB(_controllerDateYear.text,_controllerDateMonth.text,_controllerDateDay.text)
    };
   // debugPrint("send card data -->$data");
    try {
      final  result=await ApiController().post("profile/v1/store/scan/card",data,apiToken);
     // debugPrint("response from API -->$result");
      setState(() {
        _load = false;

        if (result['success']) {
          //Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SavedBusinessCardDetails()));
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        } else {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } on Exception catch (e) {
      setState(() {

        //debugPrint("response from API -->${e.toString()}");
        _load = false;
        Navigator.of(context).pop();
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

  /*String getDOB(String yyyy,String mm,String dd){
    String date="";
    if(dd.isNotEmpty && mm.isNotEmpty && yyyy.isNotEmpty){
      date="$yyyy-$mm-$dd";
    }else{
      date="";
    }
    return date;
  }*/

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
                            'Ok',
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

  void _showDOB(context) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled:true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height/1.8,
            width: MediaQuery.of(context).size.width,
            //margin: AppStyle.commonPadding,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Date of Birth (Optional)",style: AppStyle.appTittleTextAppColor,),
                ),
                const Divider(),
                const SizedBox(
                  height: 1.5,
                ),
                Flexible(
                  child: ListView(
                    children: [
                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Date of birth(Optional)",style: AppStyle.appSmallTextAppColor,),
                      ),*/
                      SizedBox(
                        height:MediaQuery.of(context).size.height/4,
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
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          decoration: BoxDecoration(
                            //color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            child: Text(
                              'Continue',
                              style: AppStyle.appBtnTxtStyleWhite,
                            ),
                            onPressed: () {
                              _controllerDob.text =
                                  _chosenDateTime.day.toString() +
                                      "/" +
                                      _chosenDateTime.month.toString() +
                                      "/" +
                                      _chosenDateTime.year.toString();
                              Navigator.of(context).pop();
                              _saveBusinessCard();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ) ,

              ],
            )));
  }

  Future<void> saveContactInPhone(context) async {
    try {

      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;
        if (permission == PermissionStatus.granted) {
          Contact newContact = new Contact();
          newContact.givenName = _controllerFullName.text;
          newContact.emails = [
            Item(label: "email", value: _controllerEmail.text)
          ];
          newContact.company = _controllerCompanyName.text;
          newContact.jobTitle=_controllerJobTittle.text;
          newContact.phones = [
            Item(label: "mobile", value: _controllerPhoneNumber.text),
            Item(label: "mobile", value: _controllerOfficeContact.text)
          ];
          newContact.postalAddresses = [
            PostalAddress(region: _controllerAddress.text)
          ];
          await ContactsService.addContact(newContact).then((value){
            //Navigator.of(context).pop();
            final snackBar = SnackBar(
              content: Text(
                'Contact Details Save Successfully',
                style: AppStyle.appSmallTextAppWhite,
              ),
              backgroundColor: (Colors.black87),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {},
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //_showDOB(context);
            if(widget.view=="F"){
              _saveBusinessCard();
            }else{
              _updateBusinessCard();
            }

          });
          //debugPrint("already permission granted");
        }
        else {
          //_handleInvalidPermissions(context);
          //debugPrint("permission not granted");
          await Permission.contacts.request();
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text(
              'Contact Permission Required!',
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
      }
      else {
        Contact newContact = new Contact();
        newContact.givenName = _controllerFullName.text;
        newContact.emails = [
          Item(label: "email", value: _controllerEmail.text)
        ];
        newContact.company = _controllerCompanyName.text;
        newContact.jobTitle=_controllerJobTittle.text;
        newContact.phones = [
          Item(label: "mobile", value: _controllerPhoneNumber.text),
          Item(label: "mobile", value: _controllerOfficeContact.text)
        ];
        newContact.postalAddresses = [
          PostalAddress(region: _controllerAddress.text)
        ];
        await ContactsService.addContact(newContact).then((value){
          //Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text(
              'Contact Details Save Successfully',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          if(widget.view=="F"){
            _saveBusinessCard();
          }else{
            _updateBusinessCard();
          }
        });
        //debugPrint("already permission granted");

      }

    } catch (e) {
      //debugPrint("exception catch -->${e.toString()}");
      Navigator.of(context).pop();
      final snackBar = SnackBar(
        content: Text(
          'Sorry Something went wrong!',
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
  }

  _updateBusinessCard() async{

    setState(() {
      _load=true;
    });

    Map data={
      "cardId":widget.id,
      "contactName":_controllerFullName.text,
      "companyName":_controllerCompanyName.text,
      "email":_controllerEmail.text,
      "jobTitle":_controllerJobTittle.text,
      "mobileNo":_controllerPhoneNumber.text,
      "workPhoneno":_controllerOfficeContact.text,
      "address":_controllerAddress.text,
      "scannedcard": strVisitingCardBase64Image,
      "dob": _controllerDob.text
    };
    // debugPrint("send card data -->$data");
    try {
      final  result=await ApiController().post("profile/v1/scaned/card/edit",data,apiToken);
      //debugPrint("response from API -->$result");
      setState(() {
        _load = false;

        if (result['success']) {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        } else {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } on Exception catch (e) {
      setState(() {
        _load = false;
        Navigator.of(context).pop();
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
