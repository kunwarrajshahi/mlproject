import 'dart:convert';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dmi/controller/api_controller.dart';
import 'package:dmi/view/create_contact_view.dart';
import 'package:dmi/view/dashboard_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/custome_dialog.dart';
import 'create_qr_profile_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin{

  int otp=0000;
  bool showOtp=false,_load=false,timer=true;
  final TextEditingController _controllerOtp=TextEditingController();
  final TextEditingController _controllerNumber=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String termsAndCond="";
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.repeat();
    /*AppCookies.instance.getStringValue("visitData").then((value) =>
        setState(() {
          if (value == "T") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DashboardView()));
          }
        }));*/
    AppCookies.instance
        .getStringValue("apiToken")
        .then((value) => setState(() {
      //debugPrint("apiToken===> $value");
    }));
    AppCookies.instance
        .getStringValue("tcpc")
        .then((value) => setState(() {
      termsAndCond=value;
    }));
    AppCookies.instance
        .getStringValue("whatsAppNumber")
        .then((value) => setState(() {
    }));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             AppStyle.header,
            Flexible(
              child: ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(12),
                      decoration:  const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
                      ),
                      child: showOtp?otpWidget():phoneWidget())),
            ),
            AppStyle.footer
          ],
        ),
      ),
    );
  }

  Widget phoneWidget(){

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const SizedBox(height: 40,),
          Text("Login",
            style: AppStyle.appTooBigTextBlack,
            textAlign: TextAlign.center,),
          const SizedBox(height: 40,),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("OTP wil be sent on your",style: AppStyle.appSmallTextBlack,
                  textAlign: TextAlign.center,),
                SizedBox(
                  width: 100,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      FadeAnimatedText('WhatsApp',
                          textAlign:TextAlign.center,textStyle:AppStyle.appTittleTextAppColor,
                          duration: const Duration(milliseconds: 800)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppStyle.hSmallSpace,
          Padding(
            padding: AppStyle.commonPadding,
            child: TextFormField(
              controller: _controllerNumber,
              style: AppStyle.appSmallTextBlack,
              //keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              //maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your WhatsApp number';
                }
                else if (value.length!=10) {
                  return 'Invalid Number';
                }
                return null;
              },
              decoration:  InputDecoration(
                contentPadding: const EdgeInsets.all(05),
                fillColor: AppStyle.appShade.withOpacity(0.5),
                prefixIcon: Icon(FontAwesomeIcons.whatsapp,
                  color: AppStyle.appColor,size: AppStyle.smallIconSize,),
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
                labelText: 'Enter your WhatsApp number',
                hintText: "Mobile Number",
                hintStyle: AppStyle.appSmallTextAppColor,
                labelStyle:AppStyle.appSmallTextBlack,
              ),
            ),
          ),

          /*Text("WhatsApp",style: AppStyle.appTittleTextAppColor,
            textAlign: TextAlign.center,),*/
          /*RichText(
            textAlign: TextAlign.center,
            text:  TextSpan(
              text: 'We will send you an ',
              style: AppStyle.appSmallTextBlack,
              children: <TextSpan>[
                TextSpan(text: 'One Time Password(OTP) on this',
                  style: AppStyle.appSmallTextBlack,),
                TextSpan(text: '  WhatsApp ',
                  style: AppStyle.appSmallTextAppColor,),
                TextSpan(text: 'number',
                  style: AppStyle.appSmallTextBlack,),
              ],
            ),
          ),*/
          const SizedBox(height: 40,),
          _load?AppStyle.loading:Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FloatingActionButton(
                child: Icon(FontAwesomeIcons.angleRight,size: AppStyle.bigIconSize,color: Colors.white,),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendAuth();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget otpWidget(){

  return ListView(
    children: [
      const SizedBox(height: 40,),
      Text("Verify OTP",
        style: AppStyle.appTooBigTextBlack,
        textAlign: TextAlign.center,),
      const SizedBox(height: 30,),

      AppStyle.hSmallSpace,
      /*Text("Check your WhatsApp",style: AppStyle.appTittleTextBlack,
          textAlign: TextAlign.center,),*/
      SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Check your",style: AppStyle.appSmallTextBlack,
              textAlign: TextAlign.center,),
            SizedBox(
              width: 100,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  FadeAnimatedText('\tWhatsApp',
                      textAlign:TextAlign.start,textStyle:AppStyle.appTittleTextAppColor,
                      duration: const Duration(milliseconds: 800)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /*RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Check your",
            style: AppStyle.appSmallTextBlack,
            children: <TextSpan>[
              TextSpan(text: ' WhatsApp',
                style: AppStyle.appTittleTextAppColor,),
             *//* TextSpan(text: " for ${_controllerNumber.text}",
                style: AppStyle.appSmallTextBlack.copyWith(color: Colors.grey),),
              TextSpan(text: ' on your device.',
                style: AppStyle.appSmallTextBlack.copyWith(color: Colors.grey),),*//*

            ],
          ),
        ),*/
      /*RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Please check your',
            style: AppStyle.appSmallTextBlack,
            children: <TextSpan>[
              TextSpan(text: ' WhatsApp',
                style: AppStyle.appSmallTextAppColor,),
              TextSpan(text: " on ${_controllerNumber.text}",
                style: AppStyle.appSmallTextBlack,),
               TextSpan(text: ' for One Time Password(OTP).',
                style: AppStyle.appSmallTextBlack,),
               TextSpan(text: ' Enter that below ',
                style: AppStyle.appSmallTextBlack,),
          ],
          ),
        ),*/
      AppStyle.hSpace,
      OtpTextField(
        numberOfFields: 4,
        textStyle: AppStyle.appSmallTextBlack,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        focusedBorderColor: AppStyle.appColor,
        // fieldWidth: 50,
        //set to true to show as box or false to show as dash
        showFieldAsBox: true,
        borderColor: AppStyle.appColor,
        fillColor: AppStyle.appShade.withOpacity(0.5),
        //runs when a code is typed in
        onCodeChanged: (String code) {
          _controllerOtp.text=code;
        },
        //runs when every textfield is filled
        onSubmit: (String verificationCode){
          _controllerOtp.text=verificationCode;
          /*showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text("Verification Code"),
                    content: Text('Code entered is $verificationCode'),
                  );
                }
            );*/

        }, // end onSubmit
      ),
      AppStyle.hSpace,

      timer?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Didn't receive it? Retry in",
            style: AppStyle.appSmallTextBlack,),
          AppStyle.hSmallSpace,
          CircularCountDownTimer(
            initialDuration: 0,
            controller: CountDownController(),
            width: 30,
            height: 30,
            ringColor: Colors.grey[300]!,
            ringGradient: null,
            fillColor: AppStyle.appColor,
            fillGradient: null,
            backgroundColor: AppStyle.appShade,
            backgroundGradient: null,
            strokeWidth: 3.0,
            strokeCap: StrokeCap.round,
            textStyle:AppStyle.appSmallTextGrey,
            textFormat: CountdownTextFormat.S,
            isReverse: true,
            isReverseAnimation: false,
            isTimerTextShown: true,
            autoStart: true,
            onStart: () {
              //debugPrint('Countdown Started');
            },
            onComplete: () {
              //debugPrint('Countdown Ended');
              setState(() {
                timer=false;
              });
            },
            onChange: (String timeStamp) {
             // debugPrint('Countdown Changed $timeStamp');
            },
            duration: 30,
          ),
        ],
      ):Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Text("Don't get OTP?",style:  AppStyle.appSmallBoldTextGrey,
                textAlign: TextAlign.center,),*/
            InkWell(
                onTap: (){
                  setState(() {
                    //showOtp=false;_
                    _sendAuth();
                    controller.repeat();
                  });
                },
                child: Text("Resend OTP",
                  style: AppStyle.appSmallTextAppColor,))
          ],
        ),
      ),
      const SizedBox(height: 40,),
      _load?AppStyle.loading:Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            child: Text("Submit",
              style: AppStyle.appBtnTxtStyleWhite,),
            onPressed: () {
              if(_controllerOtp.text.isEmpty){
                final snackBar = SnackBar(
                  content: const Text('OTP Required!'),
                  backgroundColor: (Colors.black87),
                  action: SnackBarAction(
                    label: 'dismiss',
                    onPressed: () {
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else{
                _verifyAuth();
              }
            },),
        ),
      )
    ],
  );
}


  _sendAuth() async{

    setState(() {
      _load=true;
    });
    Map data={
      "whatsAppNo":_controllerNumber.text
    };
    try {
      final  result=await ApiController().post("profile/v1/sendotp", data,"");
      setState(() {
        _load = false;
       // showOtp=true;
        if (result['success']) {
          otp = result['data'];
          timer=true;
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
          if(_controllerNumber.text=="8409550401"){
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: const Text("Verification Code"),
                  content: Text('Your OTP is $otp'),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton.icon(
                        icon:  Icon(FontAwesomeIcons.check,
                          size: AppStyle.smallIconSize,color: Colors.white,),
                        onPressed: (){
                          Navigator.pop(context);
                          setState(() {
                            showOtp=true;
                          });
                        }, label: Text("Ok",
                      style: AppStyle.appBtnTxtStyleWhite,))
                  ],
                );
              }
          );
          }else{
            setState(() {
              showOtp=true;
            });
          }
        } else {
          showDialog(
            context: context,
            builder: (ctx) => PlaceholderDialog(
              icon: Icon(
                FontAwesomeIcons.triangleExclamation,
                color: AppStyle.appColor,
                size: 50.0,
              ),
              title: 'Alert',
              message: result['message'].toString(),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Ok',style: AppStyle.appSmallTextAppColor,),
                ),
              ],
            ),
          );
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
  _verifyAuth() async{

    setState(() {
      _load=true;
    });
    Map data={
      "whatsAppNo":_controllerNumber.text,
      "otp":_controllerOtp.text,
      "termsAndCond":termsAndCond
    };
    try {
      final  result=await ApiController().post("profile/v1/otpverification", data,"");
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
          AppCookies.instance
              .setStringValue("Login","T" );
          AppCookies.instance
              .setStringValue("whatsAppNumber", _controllerNumber.text);
          AppCookies.instance
              .setStringValue("apiToken", result['api_token']);
          AppCookies.instance
              .setStringValue("name", result['name']);
          AppCookies.instance
              .setStringValue("id", result['profileid'].toString());

          if(result['register']=="no"){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const CreateQRProfileView(update: false,)));
          }else{
            AppCookies.instance.setStringValue("visitData", "T");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const DashboardView()));
          }

        } else {
          showDialog(
            context: context,
            builder: (ctx) => PlaceholderDialog(
              icon: Icon(
                FontAwesomeIcons.triangleExclamation,
                color: AppStyle.appColor,
                size: 50.0,
              ),
              title: 'Alert',
              message: result['message'].toString(),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Ok',style: AppStyle.appSmallTextAppColor,),
                ),
              ],
            ),
          );
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
  void dispose() {
    // TODO: implement dispose
    controller.stop();
    super.dispose();
  }

}
