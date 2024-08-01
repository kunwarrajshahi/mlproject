import 'package:dmi/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_cookies.dart';
import 'login_view.dart';

class HelpSupportView extends StatefulWidget {
  const HelpSupportView({Key? key}) : super(key: key);

  @override
  State<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<HelpSupportView> {

  bool showPreamble=false,showMentor=false,showThought=false,showTech=false;
  late String apiToken;
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
    super.initState();
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
          title: Text("Help & Support",style: AppStyle.appBarTextBlack,),
        ),
        body:ListView(
          padding: EdgeInsets.zero,
          children: [
            InkWell(
              onTap: (){
                setState(() {
                  /*if(showThought){
                      showThought=false;
                    }else{
                      showThought=true;
                    }*/
                  final snackBar = SnackBar(
                    content: Text(
                      'This features under development!',
                      style: AppStyle.appSmallTextAppWhite,
                    ),
                    backgroundColor: (Colors.black87),
                    /*action: SnackBarAction(
                        label: 'Ok',
                        onPressed: () {},
                      ),*/
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: Padding(
                padding: AppStyle.commonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("App Tutorials",style: AppStyle.appSmallTextAppColor,),
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
            InkWell(
              onTap: () async {

                //String email = Uri.encodeComponent("deepakmundrainitiatives@gmail.com");
                //String subject = Uri.encodeComponent("Save Trees VC Help");
                //String body = Uri.encodeComponent("Hi! describe your problem");
                EmailContent email = EmailContent(
                  to: [
                    'support@savetreesvc.com',
                  ],
                  subject: 'Save Trees VC Help',
                  body: 'How we can help you!',
                );

                OpenMailAppResult result =
                    await OpenMailApp.composeNewEmailInMailApp(
                    nativePickerTitle: 'Select email app to compose',
                    emailContent: email);
                if (!result.didOpen && !result.canOpen) {
                  showNoMailAppsDialog(context);
                } else if (!result.didOpen && result.canOpen) {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        MailAppPickerDialog(
                          mailApps: result.options,
                          emailContent: email,
                        ),
                  );
                }
              },
              child: Padding(
                padding: AppStyle.commonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Contact Us/Helpdesk",style: AppStyle.appSmallTextAppColor,),
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
                setState(() {
                  /*if(showMentor){
                      showMentor=false;
                    }else{
                      showMentor=true;
                    }*/
                  final snackBar = SnackBar(
                    content: Text(
                      'This features under development!',
                      style: AppStyle.appSmallTextAppWhite,
                    ),
                    backgroundColor: (Colors.black87),
                    /*action: SnackBarAction(
                        label: 'Ok',
                        onPressed: () {},
                      ),*/
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: Padding(
                padding: AppStyle.commonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("FAQ",style: AppStyle.appSmallTextAppColor,),
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


            AppStyle.hSmallSpace,
          ],
        )
      ),
    ) ;
  }
  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App",style: AppStyle.appSmallTextAppColor,),
          content: Text("No mail apps installed",style: AppStyle.appSmallTextBlack,),
          actions: <Widget>[
            TextButton(
              child: Text("OK",style: AppStyle.appSmallTextAppColor,),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

}
