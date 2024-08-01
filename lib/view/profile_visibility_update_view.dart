import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controller/api_controller.dart';
import '../utils/app_constant.dart';
import '../utils/app_cookies.dart';
import '../widgets/check_box_widget.dart';
import 'login_view.dart';

class ProfileVisibilityUpdateView extends StatefulWidget {
  const ProfileVisibilityUpdateView({super.key});

  @override
  State<ProfileVisibilityUpdateView> createState() => _ProfileVisibilityUpdateViewState();
}

class _ProfileVisibilityUpdateViewState extends State<ProfileVisibilityUpdateView> {
  GlobalKey globalKey = GlobalKey();
  late String apiToken,qrData="QR_DATA";

  bool _load=false;

  //origination Details
  bool blOrgCheck=true,blTittleDesignation=true,blCompanyName=true,blLandLineNoDirect=true,blLandLineNoBoard=true,blCountry=true,
      blState=true,blCity=true,blPinCode=true,blAddressLine1=true,blAddressLine2=true,
      blAddressLine3=true,blOrganisationWebsite=true,blProfilePicCheck=true,blFrontCardPicCheck=true,
      blBackCardPicCheck=true,blWhatsAppCheck=true,blMobile2Check=true,blEmailCheck=true,blBloodGroupCheck=true,blDobCheck=true,blExtCheck=true;

  //social media
  bool blSocialMediaCheck=true,blLinkedIn=true,blTwitter=true,blInstagram=true,blThreads=true,blFacebook=true,blYouTube=true,
      blTelegram=true,blSnapChat=true,blFreeFiled1=true,blFreeFiled2=true,blFreeFiled3=true,blPersonalWebsite=true;

  String whatsAppNo="",mobileNo="",surName="",name="",dob="",emailId="",profilePic="",physicalVisitingCardPic="",physicalVisitingCardPicBack="",
      companyName="",titleDesignation="",landLineNoDirect="",landLineNoBoard="",country="",
      state="",city="",pincode="",addressLine1="",addressLine2="",addressLine3="",organisationWebsite="",
      linkedinId="",twitterId="",facebookId="",instagramId="",threadsId="",youtubeId="",telegram="",snapchat="",
      personalWebSite="",freeField1="",freeField12="",freeField13="",bloodGroup="",extension="";


  @override
  void initState() {

    AppCookies.instance
        .getStringValue("whatsAppNumber")
        .then((value) => setState(() {
      whatsAppNo = value;
    }));
    AppCookies.instance
        .getStringValue("apiToken")
        .then((value) => setState(() {
      apiToken = value;
      if(apiToken.isEmpty){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView()));
      }else{
        _getUserProfileData();
        //debugPrint("apiToken===> $apiToken");
      }

    }));
    super.initState();
  }

  _getUserProfileData() async{

    setState(() {
      _load=true;
    });

    try {
      final  result=await ApiController().get("profile/v1/details",apiToken);
      setState(() {
        _load = false;

        if (result['success']) {
          //personal details
          whatsAppNo=result['personalData']['whatsAppNo']??"";
          blWhatsAppCheck=checkValue(result['personalData']['whatsAppNo_visibility']);

          mobileNo=result['personalData']['mobileNo2']??"";
          blMobile2Check=checkValue(result['personalData']['mobileNo2_visibility']);

          surName=result['personalData']['surName']??"";
          name=result['personalData']['name']??"";

          dob=result['personalData']['dob']??"";
          blDobCheck=checkValue(result['personalData']['dob_visibility']);

          bloodGroup=result['personalData']['bloodGroup']??"";
          blBloodGroupCheck=checkValue(result['personalData']['bloodGroup_visibility']);


          emailId=result['personalData']['emailId']??"";
          blEmailCheck=checkValue(result['personalData']['emailId_visibility']);

          profilePic=result['personalData']['profilePic']??"";
          blProfilePicCheck=checkValue(result['personalData']['profilePic_visibility']);

          physicalVisitingCardPic=result['personalData']['physicalVisitingCardPic']??"";
          blFrontCardPicCheck=checkValue(result['personalData']['physicalVisitingCardPic_visibility']);

          physicalVisitingCardPicBack=result['personalData']['physicalVisitingCardPicBack']??"";
          blBackCardPicCheck=checkValue(result['personalData']['physicalVisitingCardPic2Back_visibility']);

         // debugPrint("-->profile $blProfilePicCheck -->front--> $blFrontCardPicCheck---> $blBackCardPicCheck");

          //origination details
          titleDesignation=result['organizationData']['titleDesignation']??"";
          blTittleDesignation=checkValue(result['organizationData']['titleDesignation_visibility']);

          companyName=result['organizationData']['companyName']??"";
          blCompanyName=checkValue(result['organizationData']['companyName_visibility']);

          landLineNoDirect=result['organizationData']['landLineNoDirect']??"";
          blLandLineNoDirect=checkValue(result['organizationData']['landLineNoDirect_visibility']);

          landLineNoBoard=result['organizationData']['landLineNoBoard']??"";
          blLandLineNoBoard=checkValue(result['organizationData']['landLineNoBoard_visibility']);

          extension=result['organizationData']['ext_no']??"";
          blExtCheck=checkValue(result['organizationData']['ext_no_visibility']);

          country=result['organizationData']['country']??"";
          blCountry=checkValue(result['organizationData']['country_visibility']);

          state=result['organizationData']['state']??"";
          blState=checkValue(result['organizationData']['state_visibility']);

          city=result['organizationData']['city']??"";
          blCity=checkValue(result['organizationData']['city_visibility']);

          pincode=result['organizationData']['pincode']??"";
          blPinCode=checkValue(result['organizationData']['pincode_visibility']);

          addressLine1=result['organizationData']['addressLine1']??"";
          blAddressLine1=checkValue(result['organizationData']['addressLine1_visibility']);

          addressLine2=result['organizationData']['addressLine2']??"";
          blAddressLine2=checkValue(result['organizationData']['addressLine2_visibility']);

          addressLine3=result['organizationData']['addressLine3']??"";
          blAddressLine3=checkValue(result['organizationData']['addressLine3_visibility']);

          organisationWebsite=result['organizationData']['organisationWebsite']??"";
          blOrganisationWebsite=checkValue(result['organizationData']['organisationWebsite_visibility']);

          //social media details
          linkedinId=result['socialMediaData']['linkedinId']??"";
          twitterId=result['socialMediaData']['twitterId']??"";
          facebookId=result['socialMediaData']['facebookId']??"";
          instagramId=result['socialMediaData']['instagramId']??"";
          threadsId=result['socialMediaData']['threadsId']??"";
          youtubeId=result['socialMediaData']['youtubeId']??"";
          telegram=result['socialMediaData']['telegram']??"";
          snapchat=result['socialMediaData']['snapchat']??"";
          freeField1=result['socialMediaData']['freeField1']??"";
          freeField12=result['socialMediaData']['freeField12']??"";
          freeField13=result['socialMediaData']['freeField13']??"";
          personalWebSite=result['socialMediaData']['personalWebSite']??"";

          //visibility
          blLinkedIn=checkValue(result['socialMediaData']['linkedinId_visibility']);
          blTwitter=checkValue(result['socialMediaData']['twitterId_visibility']);
          blFacebook=checkValue(result['socialMediaData']['facebookId_visibility']);
          blInstagram=checkValue(result['socialMediaData']['instagramId_visibility']);
          blThreads=checkValue(result['socialMediaData']['threadsId_visibility']);
          blYouTube=checkValue(result['socialMediaData']['youtubeId_visibility']);
          blTelegram=checkValue(result['socialMediaData']['telegram_visibility']);
          blSnapChat=checkValue(result['socialMediaData']['snapchat_visibility']);
          blFreeFiled1=checkValue(result['socialMediaData']['freeField1_visibility']);
          blFreeFiled2=checkValue(result['socialMediaData']['freeField12_visibility']);
          blFreeFiled3=checkValue(result['socialMediaData']['freeField13_visibility']);
          blPersonalWebsite=checkValue(result['socialMediaData']['personalWebSite_visibility']);
          //checkUncheckOrg();
          checkUncheckSocialMedia();

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

  _updateUserProfileVisibilityData() async{

    setState(() {
      _load=true;
    });

    Map data={
      "whatsAppNo_visibility": blWhatsAppCheck?"yes":"no",
      "mobileNo_visibility": blMobile2Check?"yes":"no",
      "mobileNo2_visibility":blMobile2Check?"yes":"no",
      "surName_visibility": "yes",
      "name_visibility": "yes",
      "dob_visibility": blDobCheck?"yes":"no",
      "emailId_visibility": blEmailCheck?"yes":"no",
      "profilePic_visibility": blProfilePicCheck?"yes":"no",
      "physicalVisitingCardPic_visibility": blFrontCardPicCheck?"yes":"no",
      "physicalVisitingCardPic2Back_visibility": blBackCardPicCheck?"yes":"no",
      "bloodGroup_visibility":blBloodGroupCheck?"yes":"no",
      "ext_no_visibility":blExtCheck?"yes":"no",

      "titleDesignation_visibility": blTittleDesignation?"yes":"no",
      "companyName_visibility": blCompanyName?"yes":"no",
      "landLineNoDirect_visibility": blLandLineNoDirect?"yes":"no",
      "landLineNoBoard_visibility": blLandLineNoBoard?"yes":"no",
      "country_visibility": blCountry?"yes":"no",
      "state_visibility": blState?"yes":"no",
      "city_visibility": blCity?"yes":"no",
      "pincode_visibility": blPinCode?"yes":"no",
      "addressLine1_visibility": blAddressLine1?"yes":"no",
      "addressLine2_visibility": blAddressLine2?"yes":"no",
      "addressLine3_visibility": blAddressLine3?"yes":"no",
      "organisationWebsite_visibility": blOrganisationWebsite?"yes":"no",
      "linkedinId_visibility": blLinkedIn?"yes":"no",
      "twitterId_visibility": blTwitter?"yes":"no",
      "facebookId_visibility": blFacebook?"yes":"no",
      "instagramId_visibility": blInstagram?"yes":"no",
      "threadsId_visibility": blThreads?"yes":"no",
      "youtubeId_visibility": blYouTube?"yes":"no",
      "telegram_visibility": blTelegram?"yes":"no",
      "snapchat_visibility": blSnapChat?"yes":"no",
      "personalWebSite_visibility": blPersonalWebsite?"yes":"no",
      "freeField1_visibility": blFreeFiled1?"yes":"no",
      "freeField12_visibility": blFreeFiled2?"yes":"no",
      "freeField13_visibility": blFreeFiled3?"yes":"no"
    };

    //debugPrint("data--> $data");

    try {
      final  result=await ApiController().post("profile/v1/profilevisiblityupdate",data,apiToken);
      setState(() {
        _load = false;

        if (result['success']) {
          //_getUserProfileData();
          Navigator.pop(context);
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

  //check all
  void checkOrgDetailsAll(){
    setState(() {
      if(blOrgCheck){
        blTittleDesignation=true;
        blCompanyName=true;
        blLandLineNoDirect=true;
        blLandLineNoBoard=true;
        blCountry=true;
        blState=true;
        blCity=true;
        blPinCode=true;
        blAddressLine1=true;
        blAddressLine2=true;
        blAddressLine3=true;
        blOrganisationWebsite=true;

        blBloodGroupCheck=true;
        blProfilePicCheck=true;
        blWhatsAppCheck=true;
        blMobile2Check=true;
        blEmailCheck=true;
        blDobCheck=true;
        blFrontCardPicCheck=true;
        blBackCardPicCheck=true;
        blExtCheck=true;

      }else{
        blTittleDesignation=false;
        blCompanyName=false;
        blLandLineNoDirect=false;
        blLandLineNoBoard=false;
        blCountry=false;
        blState=false;
        blCity=false;
        blPinCode=false;
        blAddressLine1=false;
        blAddressLine2=false;
        blAddressLine3=false;
        blOrganisationWebsite=false;

        blBloodGroupCheck=false;
        blProfilePicCheck=false;
        blWhatsAppCheck=false;
        blMobile2Check=false;
        blEmailCheck=false;
        blDobCheck=false;
        blFrontCardPicCheck=false;
        blBackCardPicCheck=false;
        blExtCheck=false;

      }

    });
  }
  void checkSocialDetailsAll(){
    setState(() {
      if(blSocialMediaCheck){
        blLinkedIn=true;blTwitter=true;blInstagram=true;blThreads=true;blFacebook=true;blYouTube=true;
        blTelegram=true;blSnapChat=true;blFreeFiled1=true;blFreeFiled2=true;blFreeFiled3=true;blPersonalWebsite=true;
      }else{
        blLinkedIn=false;blTwitter=false;blInstagram=false;blThreads=false;blFacebook=false;blYouTube=false;
        blTelegram=false;blSnapChat=false;blFreeFiled1=false;blFreeFiled2=false;blFreeFiled3=false;blPersonalWebsite=false;
      }

    });
  }
 /* void checkUncheckOrg(){
    setState(() {
      if(blTittleDesignation &&
          blCompanyName &&
          blLandLineNoDirect &&
          blLandLineNoBoard &&
          blCountry &&
          blState &&
          blCity &&
          blPinCode &&
          blAddressLine1 &&
          blAddressLine2 &&
          blAddressLine3 &&
          blOrganisationWebsite &&
          blBloodGroupCheck &&
          blWhatsAppCheck &&
          blMobile2Check &&
          blEmailCheck &&
          blDobCheck &&
          blFrontCardPicCheck &&
          blBackCardPicCheck &&
          blExtCheck){
        blOrgCheck=true;
      }else{
        blOrgCheck=false;
      }
    });
  }*/
  void checkUncheckSocialMedia(){
    setState(() {
      if(blLinkedIn &&
          blTwitter &&
          blInstagram &&
          blThreads &&
          blFacebook &&
          blYouTube &&
          blTelegram &&
          blSnapChat &&
          blFreeFiled1 &&
          blFreeFiled2 &&
          blFreeFiled3 &&
          blPersonalWebsite){
        blSocialMediaCheck=true;
      }else{
        blSocialMediaCheck=false;
      }
    });
  }


  bool checkValue(String val){
    if(val=="yes"){
      return true;
    }else{
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: AppStyle.appShade,
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
          title: Text("Update Profile Visibility",style: AppStyle.appBarTextBlack,),
        ),
        body:_load?Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppStyle.loading,
        )):Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                decoration:  const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text("Personal Details",style: AppStyle.appSmallTextAppColor.copyWith(fontSize: 11),),
                        GFCheckbox(
                            type: GFCheckboxType.basic,
                            activeBgColor: AppStyle.appColor,
                            size: AppStyle.tooBigIconSize,
                            onChanged: (bool? value) {
                              setState(() {
                                blOrgCheck=value!;
                                checkOrgDetailsAll();
                              });
                            }, value:blOrgCheck )
                      ],
                    ),*/
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Profile Pic",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blProfilePicCheck=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blProfilePicCheck),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Front Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blFrontCardPicCheck=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blFrontCardPicCheck),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Back Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blBackCardPicCheck=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blBackCardPicCheck),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$titleDesignation",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blTittleDesignation=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blTittleDesignation),
                        ],
                      ),
                    ),
                    /*ListTile(
                        contentPadding: const EdgeInsets.all(2),
                        title: Text("Title Designation",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$titleDesignation",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blTittleDesignation=value!;
                            checkUncheckOrg();
                          });
                        }, value: blTittleDesignation),
                        ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$companyName",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blCompanyName=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blCompanyName),
                        ],
                      ),
                    ),
                    /*ListTile(
                        contentPadding: const EdgeInsets.all(2),
                        title: Text("Company Name",style: AppStyle.appSmallTextGrey,),
                        //subtitle:  Text("$companyName",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blCompanyName=value!;
                            checkUncheckOrg();
                          });
                        }, value: blCompanyName),
                      ),*/



                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$country",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blCountry=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blCountry),
                        ],
                      ),
                    ),
                    /* ListTile(
                        title: Text("Country",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$country",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blCountry=value!;
                            checkUncheckOrg();
                          });
                        }, value: blCountry),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$state",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blState=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blState),
                        ],
                      ),
                    ),
                    /* ListTile(
                        title: Text("State",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$state",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blState=value!;
                            checkUncheckOrg();
                          });
                        }, value: blState),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$city",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blCity=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blCity),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("City",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$city",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blCity=value!;
                            checkUncheckOrg();
                          });
                        }, value: blCity),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$pincode",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blPinCode=value!;
                             // checkUncheckOrg();
                            });
                          }, value: blPinCode),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("Pin code",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$pincode",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blPinCode=value!;
                            checkUncheckOrg();
                          });
                        }, value: blPinCode),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$addressLine1",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blAddressLine1=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blAddressLine1),
                        ],
                      ),
                    ),
                    /* ListTile(
                        title: Text("Address Line 1",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$addressLine1",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blAddressLine1=value!;
                            checkUncheckOrg();
                          });
                        }, value: blAddressLine1),
                      ),*/
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$emailId",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blEmailCheck=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blEmailCheck),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$whatsAppNo",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blWhatsAppCheck=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blWhatsAppCheck),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$mobileNo",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blMobile2Check=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blMobile2Check),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$landLineNoDirect",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blLandLineNoDirect=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blLandLineNoDirect),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$extension",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blExtCheck=value!;
                             // checkUncheckOrg();
                            });
                          }, value: blExtCheck),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$landLineNoBoard",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blLandLineNoBoard=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blLandLineNoBoard),
                        ],
                      ),
                    ),


                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$organisationWebsite",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blOrganisationWebsite=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blOrganisationWebsite),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$bloodGroup",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blBloodGroupCheck=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blBloodGroupCheck),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("$dob",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),)),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blDobCheck=value!;
                              //checkUncheckOrg();
                            });
                          }, value: blDobCheck),
                        ],
                      ),
                    ),

                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    //social media
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text("Social Media Details",style: AppStyle.appSmallTextAppColor.copyWith(fontSize: 11),),
                        GFCheckbox(
                            type: GFCheckboxType.basic,
                            activeBgColor: AppStyle.appColor,
                            size: AppStyle.tooBigIconSize,
                            onChanged: (bool? value) {
                              setState(() {
                                blSocialMediaCheck=value!;
                                checkSocialDetailsAll();
                              });
                            }, value: blSocialMediaCheck)
                      ],
                    ),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.linkedinIn,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(linkedinId.length > 50 ? '${linkedinId.substring(0, 40)}...' : linkedinId,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),
                            overflow: TextOverflow.clip,),
                          const Spacer(),
                          Checkbox(
                              onChanged: (bool? value) {
                                setState(() {
                                  blLinkedIn=value!;
                                  checkUncheckSocialMedia();
                                });
                              }, value: blLinkedIn),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("linkedIn",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$linkedinId",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blLinkedIn=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blLinkedIn),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/icon/twitter.png",
                            color: AppStyle.appColor,
                            scale: 4,
                          ),
                          AppStyle.wSpace,
                          Text(
                            twitterId.length > 50 ? '${twitterId.substring(0, 40)}...' : twitterId,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blTwitter=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blTwitter),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("Twitter",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$twitterId",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blTwitter=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blTwitter),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.facebook,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            facebookId.length > 50 ? '${facebookId.substring(0, 40)}...' : facebookId,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blFacebook=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blFacebook),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("Facebook",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$facebookId",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blFacebook=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blFacebook),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.instagram,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            instagramId.length > 50 ? '${instagramId.substring(0, 40)}...' : instagramId,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blInstagram=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blInstagram),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("Instagram",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$instagramId",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blInstagram=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blInstagram),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/icon/threads.png",
                            color: AppStyle.appColor,
                            width: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            threadsId.length > 50 ? '${threadsId.substring(0, 40)}...' : threadsId,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blThreads=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blThreads),
                        ],
                      ),
                    ),
                    /* ListTile(
                        title: Text("Threads",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$threadsId",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blThreads=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blThreads),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.youtube,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            youtubeId.length > 50 ? '${youtubeId.substring(0, 40)}...' : youtubeId,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blYouTube=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blYouTube),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("YouTube",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$youtubeId",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blYouTube=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blYouTube),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.telegram,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            telegram.length > 50 ? '${telegram.substring(0, 40)}...' : telegram,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blTelegram=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blTelegram),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("Telegram",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$telegram",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blTelegram=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blTelegram),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.snapchat,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            snapchat.length > 50 ? '${snapchat.substring(0, 40)}...' : snapchat,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blSnapChat=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blSnapChat),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("Snapchat",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$snapchat",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blSnapChat=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blSnapChat),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.globe,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            personalWebSite.length > 50 ? '${personalWebSite.substring(0, 40)}...' : personalWebSite,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blPersonalWebsite=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blPersonalWebsite),
                        ],
                      ),
                    ),
                    /* ListTile(
                        title: Text("Personal web site",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$personalWebSite",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blPersonalWebsite=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blPersonalWebsite),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.link,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            freeField1.length > 50 ? '${freeField1.substring(0, 40)}...' : freeField1,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blFreeFiled1=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blFreeFiled1),
                        ],
                      ),
                    ),
                    /* ListTile(
                        title: Text("Free Field 1",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$freeField1",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blFreeFiled1=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blFreeFiled1),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.link,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            freeField12.length > 50 ? '${freeField12.substring(0, 40)}...' : freeField12,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blFreeFiled2=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blFreeFiled2),
                        ],
                      ),
                    ),
                    /*ListTile(
                        title: Text("Free Field 2",style: AppStyle.appSmallTextGrey,),
                        subtitle:  Text("$freeField12",style: AppStyle.appSmallTextAppColor,),
                        trailing: Checkbox(onChanged: (bool? value) {
                          setState(() {
                            blFreeFiled2=value!;
                            checkUncheckSocialMedia();
                          });
                        }, value: blFreeFiled2),
                      ),*/

                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FontAwesomeIcons.link,
                            color: AppStyle.appColor,
                            size: AppStyle.smallIconSize,
                          ),
                          AppStyle.wSpace,
                          Text(
                            freeField13.length > 50 ? '${freeField13.substring(0, 40)}...' : freeField13,
                            style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                          const Spacer(),
                          Checkbox(onChanged: (bool? value) {
                            setState(() {
                              blFreeFiled3=value!;
                              checkUncheckSocialMedia();
                            });
                          }, value: blFreeFiled3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _load?const SizedBox(height: 10,):Container(
          padding: AppStyle.commonPadding,
          child: ElevatedButton(
            child: Text("Save Changes",
              style: AppStyle.appBtnTxtStyleWhite,),
            onPressed: () {
              _updateUserProfileVisibilityData();
            },),
        ),
      ),
    );
  }
}
