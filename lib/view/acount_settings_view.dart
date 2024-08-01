import 'package:dmi/view/change_whatsapp_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controller/api_controller.dart';
import '../utils/app_constant.dart';
import '../utils/app_cookies.dart';
import 'login_view.dart';

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {

  bool showPreamble=false,showMentor=false,showThought=false,showTech=false;
  late String apiToken,id;
  bool _load=false;

  final TextEditingController _controllerReason = TextEditingController();

  @override
  void initState() {
    AppCookies.instance
        .getStringValue("apiToken")
        .then((value) => setState(() {
      apiToken = value;
      if(apiToken.isEmpty){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView()));
      }
    }));
    AppCookies.instance
        .getStringValue("id")
        .then((value) => setState(() {
      id = value;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            title: Text("Settings",style: AppStyle.appBarTextBlack,),
          ),
          body:_load?Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppStyle.loading,
          )):ListView(
            padding: EdgeInsets.zero,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    /*if(showPreamble){
                      showPreamble=false;
                    }else{
                      showPreamble=true;
                    }*/
                    _showDialog();
                  });
                },
                child: Padding(
                  padding: AppStyle.commonPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text("Delete Account",style: AppStyle.appSmallTextAppColor,),
                      Icon(
                        showPreamble?FontAwesomeIcons.angleDown:FontAwesomeIcons.angleRight,
                        size: AppStyle.mediumIconSize,
                        color: AppStyle.appColor,
                      ),
                    ],
                  ),
                ),
              ),
              /*showPreamble?Padding(
                padding: const EdgeInsets.all(8.0),
                child: reason(),
              ):const SizedBox(),*/
              const Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangeWhatsAppView()));
                },
                child: Padding(
                  padding: AppStyle.commonPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text("Change WhatsApp Number",style: AppStyle.appSmallTextAppColor,),
                      Icon(
                        showMentor?FontAwesomeIcons.angleDown:FontAwesomeIcons.angleRight,
                        size: AppStyle.mediumIconSize,
                        color: AppStyle.appColor,
                      ),
                    ],
                  ),
                ),
              ),
              //AppStyle.hSmallSpace,
              const Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    //_backUpCard();
                    /*final snackBar = SnackBar(
                      content: Text(
                        'This features under development!',
                        style: AppStyle.appSmallTextAppWhite,
                      ),
                      backgroundColor: (Colors.black87),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                    AppStyle.launchInBrowser(Uri.parse("https://savetreesvc.com/scaned/card/export/$id"));
                  });
                },
                child: Padding(
                  padding: AppStyle.commonPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text("Backup Visiting Cards",style: AppStyle.appSmallTextAppColor,),
                      Icon(
                        showThought?FontAwesomeIcons.angleDown:FontAwesomeIcons.angleRight,
                        size: AppStyle.mediumIconSize,
                        color: AppStyle.appColor,
                      ),
                    ],
                  ),
                ),
              ),

              // AppStyle.hSmallSpace,
              const Divider(
                thickness: 1,
              ),

              AppStyle.hSmallSpace,
            ],
          )
      ),
    ) ;
  }

  Widget reason(){
    return Column(
      children: [
        Padding(
          padding: AppStyle.commonPadding,
          child: TextFormField(
            controller: _controllerReason,
            style: AppStyle.appSmallTextBlack,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            //maxLength: 150,
            maxLines: 5,
            decoration: InputDecoration(
              fillColor: AppStyle.appShade.withOpacity(0.5),
              filled: true,
              contentPadding: const EdgeInsets.all(05),
              prefixIcon: Icon(
                FontAwesomeIcons.question,
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
              labelText: 'Enter your reason (optional)',
              hintText: "Why you want to delete your account",
              hintStyle: AppStyle.appSmallTextAppColor,
              labelStyle: AppStyle.appSmallTextGrey,
            ),
          ),
        ),
        Padding(
          padding:
          AppStyle.commonPadding,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              child: Text(
               "Send Delete Request",
                style: AppStyle.appBtnTxtStyleWhite,
              ),
              onPressed: () {
                setState(() {
                  _showDialog();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  _showDialog() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            margin: AppStyle.commonPadding,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListView(
                      children: [
                        Text("Thanks,😊 for using Save Trees Vc",
                          style: AppStyle.appTittleTextBlack
                          ,textAlign: TextAlign.center,),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Are you sure you want to delete your account?",
                            style: AppStyle.appTittleTextAppColor
                            ,textAlign: TextAlign.center,),
                        ),
                        const SizedBox(
                          height: 15,
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
                                      Navigator.of(context).pop();
                                      _logout();

                                    },
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )));
  }

  _logout() async{

    setState(() {
      _load=true;
    });

    try {
      final  result=await ApiController().post("profile/v1/logout",{"action":"delete"},apiToken);
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
          //AppCookies.instance.removeValue("Login");
          //AppCookies.instance.removeValue("whatsAppNumber");
          //AppCookies.instance.removeValue("apiToken");
          AppCookies.instance.removeAll();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginView()));
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

  _backUpCard() async{

    setState(() {
      _load=true;
    });

    try {
      final  result=await ApiController().post("scaned/card/export",{},apiToken);
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
