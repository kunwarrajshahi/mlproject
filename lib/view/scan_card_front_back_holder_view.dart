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


class ScanCardFrontBackHolderView extends StatefulWidget {
  final  String id,view,fullName,companyName,jobTittle,address,officeContact,email,phone,profilePic,dob,
      surName,name,profilePic2,email2,mobileNo2,freeField;

  const ScanCardFrontBackHolderView({super.key, required this.view, required this.fullName, required this.companyName, required this.jobTittle, required this.address, required this.officeContact, required this.email, required this.phone, required this.profilePic, required this.id, required this.dob, required this.surName, required this.name, required this.profilePic2, required this.email2, required this.mobileNo2, required this.freeField});


  @override
  State<ScanCardFrontBackHolderView> createState() => _ScanCardFrontBackHolderViewState();
}

class _ScanCardFrontBackHolderViewState extends State<ScanCardFrontBackHolderView> {
  late String apiToken,qrData="QR_DATA";

  bool _load=false;
  //business card
  String strVisitingCardImagePath = "", strVisitingCardBase64Image = "",physicalVisitingCardPic="",
      physicalCardFront="",physicalCardBack="",strVisitingCardBase64ImageFront = "",strVisitingCardBase64ImageBack="",
      physicalCardFrontNetwork="",physicalCardBackNetwork="";
  //scan card data
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurName = TextEditingController();
  final TextEditingController _controllerCompanyName = TextEditingController();
  final TextEditingController _controllerJobTittle = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerOfficeContact = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerEmail2 = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();
  final TextEditingController _controllerOfficeContact2 = TextEditingController();
  final TextEditingController _controllerFreeField = TextEditingController();
  late String profilePic;
  //String _pictures = "";
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
          captureDoc("F");
        }else{
          _controllerName.text = widget.name;
          _controllerSurName.text=widget.surName;
          _controllerFreeField.text=widget.freeField;
          _controllerCompanyName.text = widget.companyName;
          _controllerJobTittle.text = widget.jobTittle;
          _controllerAddress.text = widget.address;
          _controllerOfficeContact.text = widget.officeContact;
          _controllerOfficeContact2.text=widget.mobileNo2;
          _controllerPhoneNumber.text = widget.phone;
          _controllerEmail.text = widget.email;
          _controllerEmail2.text=widget.email2;
          physicalCardFrontNetwork=widget.profilePic;
          physicalCardBackNetwork=widget.profilePic2;
          _controllerDob.text=widget.dob;
        }
      }

    }));

    super.initState();
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
                AppStyle.hSmallSpace,

                Padding(
                  padding: AppStyle.commonPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    "Scan Front Card",
                                    style: AppStyle.appSmallTextBlack
                                        .copyWith(fontSize: 11),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                            AppStyle.hSmallSpace,
                            physicalCardFront.isNotEmpty?Container(
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
                                      File(physicalCardFront.toString())),
                                  fit: BoxFit.fill,
                                ),
                              ),):physicalCardFrontNetwork.isEmpty?const SizedBox():
                            InkWell(
                              onTap: () {
                                if(widget.view!="F"){
                                  _showCardDialog(physicalCardFrontNetwork);
                                }
                              },
                              child: Container(
                                height: 100,
                               // width: 180,
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
                                )),
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
                                if(widget.view!="F"){
                                  _showCardDialog(physicalCardBackNetwork);
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
                widget.view=="F"?Padding(
                  padding: AppStyle.commonPadding,
                  child: Text("Edit Card Details",style: AppStyle.appSmallTextAppColor,),
                ):const SizedBox(),
                Flexible(
                  child: ListView(
                    children: [
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
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
                      ),
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
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
                              labelText: "First Name",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
                          ),
                        ),
                      ),// first name
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
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
                              //hintText: 'Enter Designation',
                              labelText: "Designation",
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
                              //hintText: 'Enter Company Name',
                              labelText: "Company Name",
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
                              //hintText: 'Enter Email Id',
                              labelText: "Email Id",
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
                            controller: _controllerEmail2,
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
                              //hintText: 'Enter Email Id 2',
                              labelText: "Email Id 2",
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
                                FontAwesomeIcons.mobile,
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
                              //hintText: 'Enter Mobile Number',
                              labelText: "Mobile Number",
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
                              hintText: 'Office Contact Number',
                              labelText: "Office Contact Number",
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
                            controller: _controllerOfficeContact2,
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
                              labelText: 'Office Contact Number 2',
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
                      Padding(
                        padding: AppStyle.commonPadding,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _controllerFreeField,
                            style: AppStyle.appSmallTextBlack,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            //maxLength: 10,
                            decoration: InputDecoration(
                              fillColor: AppStyle.appShade.withOpacity(0.5),
                              filled: true,
                              contentPadding: const EdgeInsets.all(05),
                              prefixIcon: Icon(
                                FontAwesomeIcons.fileText,
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
                              labelText: 'Free Field',
                              //hintText: "Email",
                              hintStyle: AppStyle.appSmallTextAppColor,
                              labelStyle: AppStyle.appSmallTextGrey,
                            ),
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

  _showCardDialog(String pic) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            //margin: AppStyle.commonPadding,
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
                      color: AppStyle.appShade.withOpacity(0.5),
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
                const SizedBox(
                  height: 10,
                ),
                IconButton(
                  color: AppStyle.appShade,
                  icon: Icon(FontAwesomeIcons.xmark,color: AppStyle.appColor,size: AppStyle.mediumIconSize,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            )));
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
            //String? contactNames=result['analyzeData']['ContactNames']??"";
            String? contactNames=result['analyzeData']['FirstName']??result['analyzeData']['ContactNames'];
            String? contactSureName=result['analyzeData']['LastName']??"";
            String? mobilePhones=result['analyzeData']['MobilePhones']??"";
            String? email=result['analyzeData']['Emails']??"";
            String? workPhones=result['analyzeData']['WorkPhones']??"";
            String? workPhones2=result['analyzeData']['WorkPhones1']??"";
            String? jobTitles=result['analyzeData']['JobTitles']??"";
            String? companyNames=result['analyzeData']['CompanyNames']??"";
            String? addresses=result['analyzeData']['Addresses']??"";

            //_controllerFullName.text=contactNames!;
            _controllerName.text=contactNames!;
            _controllerSurName.text=contactSureName!;
            _controllerPhoneNumber.text=mobilePhones!;
            _controllerEmail.text=email!;
            _controllerOfficeContact.text=workPhones!;
            _controllerOfficeContact2.text=workPhones2!;
            _controllerJobTittle.text=jobTitles!;
            _controllerCompanyName.text=companyNames!;
            _controllerAddress.text=addresses!;
          }else{
           // String? contactNames=result['analyzeData']['ContactNames']??"";
            String? contactNames=result['analyzeData']['FirstName']??result['analyzeData']['ContactNames'];
            String? contactSureName=result['analyzeData']['LastName']??"";

            String? mobilePhones=result['analyzeData']['MobilePhones']??"";
            String? email=result['analyzeData']['Emails']??"";
            String? workPhones=result['analyzeData']['WorkPhones']??"";
            String? workPhones2=result['analyzeData']['WorkPhones1']??"";
            String? jobTitles=result['analyzeData']['JobTitles']??"";
            String? companyNames=result['analyzeData']['CompanyNames']??"";
            String? addresses=result['analyzeData']['Addresses']??"";

            if(_controllerName.text.isEmpty){
              _controllerName.text=contactNames!;
            }
            if(_controllerSurName.text.isEmpty){
              _controllerSurName.text=contactSureName!;
            }
            if(_controllerPhoneNumber.text.isEmpty){
              _controllerPhoneNumber.text=mobilePhones!;
            }
            if(_controllerEmail.text.isEmpty){
              _controllerEmail.text=email!;
            }
            if(_controllerOfficeContact.text.isEmpty){
              _controllerOfficeContact.text=workPhones!;
            }
            if(_controllerOfficeContact2.text.isEmpty){
              _controllerOfficeContact2.text=workPhones2!;
            }
            if(_controllerJobTittle.text.isEmpty){
              _controllerJobTittle.text=jobTitles!;
            }
            if(_controllerCompanyName.text.isEmpty){
              _controllerCompanyName.text=companyNames!;
            }
            if(_controllerAddress.text.isEmpty){
              _controllerAddress.text=addresses!;
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

  _saveBusinessCard() async{

    setState(() {
      _load=true;
    });

    Map data={
      "dob": _controllerDob.text,
      "contactName":"${_controllerName.text}\t ${_controllerSurName.text}",
      "surName": _controllerSurName.text,
      "name": _controllerName.text,
      "freeField":_controllerFreeField.text,
      "companyName":_controllerCompanyName.text,
      "email":_controllerEmail.text,
      "jobTitle":_controllerJobTittle.text,
      "mobileNo":_controllerPhoneNumber.text,
      "workPhoneno":_controllerOfficeContact.text,
      "address":_controllerAddress.text,
      "scannedcard": strVisitingCardBase64ImageFront,
      "scannedcard2Back":strVisitingCardBase64ImageBack,
      "email2":_controllerEmail2.text,
      "mobileNo2":_controllerOfficeContact2.text,


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

  Future<void> saveContactInPhone(context) async {
    try {

      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;
        if (permission == PermissionStatus.granted) {
          Contact newContact = new Contact();
          newContact.givenName = "${_controllerName.text}\t${_controllerSurName.text}";
          newContact.emails = [
            Item(label: "email", value: _controllerEmail.text),
            Item(label: "email", value: _controllerEmail2.text)
          ];
          newContact.company = _controllerCompanyName.text;
          newContact.jobTitle=_controllerJobTittle.text;
          newContact.phones = [
            Item(label: "mobile", value: _controllerPhoneNumber.text),
            Item(label: "mobile", value: _controllerOfficeContact.text),
            Item(label: "mobile", value: _controllerOfficeContact2.text)
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
        newContact.givenName = "${_controllerName.text}\t${_controllerSurName.text}";
        newContact.emails = [
          Item(label: "email", value: _controllerEmail.text),
          Item(label: "email", value: _controllerEmail2.text)
        ];
        newContact.company = _controllerCompanyName.text;
        newContact.jobTitle=_controllerJobTittle.text;
        newContact.phones = [
          Item(label: "mobile", value: _controllerPhoneNumber.text),
          Item(label: "mobile", value: _controllerOfficeContact.text),
          Item(label: "mobile", value: _controllerOfficeContact2.text)
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
      "dob": _controllerDob.text,
      "contactName":"${_controllerName.text}\t ${_controllerSurName.text}",
      "surName": _controllerSurName.text,
      "name": _controllerName.text,
      "freeField":_controllerFreeField.text,
      "companyName":_controllerCompanyName.text,
      "email":_controllerEmail.text,
      "jobTitle":_controllerJobTittle.text,
      "mobileNo":_controllerPhoneNumber.text,
      "workPhoneno":_controllerOfficeContact.text,
      "address":_controllerAddress.text,
      "scannedcard": strVisitingCardBase64ImageFront,
      "scannedcard2Back":strVisitingCardBase64ImageBack,
      "email2":_controllerEmail2.text,
      "mobileNo2":_controllerOfficeContact2.text,

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
