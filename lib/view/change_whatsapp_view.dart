import 'package:flutter/material.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'login_view.dart';

class ChangeWhatsAppView extends StatefulWidget {
  const ChangeWhatsAppView({super.key});

  @override
  State<ChangeWhatsAppView> createState() => _ChangeWhatsAppViewState();
}

class _ChangeWhatsAppViewState extends State<ChangeWhatsAppView> with TickerProviderStateMixin {


  bool showOtp=false,_load=false,timer=true;
  final TextEditingController _controllerOtp=TextEditingController();
  final TextEditingController _controllerNumber=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController controller;
  late Animation<double> animation;
  late String apiToken;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.repeat();

    AppCookies.instance
        .getStringValue("apiToken")
        .then((value) => setState(() {
      apiToken=value;
      if(apiToken.isEmpty){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView()));
      }
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
          title: Text("Account Setting",style: AppStyle.appBarTextBlack,),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //AppStyle.header,
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
            //AppStyle.footer
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
          Text("Change Number",
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
                  return 'Please enter WhatsApp number';
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
                labelText: 'Enter New WhatsApp number',
                hintText: "New WhatsApp Number",
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
                //debugPrint('Countdown Changed $timeStamp');
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
      final  result=await ApiController().post("profile/v1/changeWhatsapp", data,apiToken);
      setState(() {
        _load = false;

        if (result['success']) {
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
          setState(() {
            showOtp=true;
          });
        } else {
          _showDialog(result['message']);
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
    };
    try {
      final  result=await ApiController().post("profile/v1/whatsAppOtpVerification", data,apiToken);
      setState(() {
        _load = false;

        if (result['success']) {

          /*final snackBar = SnackBar(
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
          ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
          _showLoginDialog();

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
  void dispose() {
    // TODO: implement dispose
    controller.stop();
    super.dispose();
  }

  _showDialog(String message) {
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
                        Text("Alert",
                          style: AppStyle.appTittleTextBlack
                          ,textAlign: TextAlign.center,),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("$message",
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
                              /*AppStyle.wSpace,
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

                                    },
                                  ),
                                ),
                              ),*/

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

  _showLoginDialog() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height / 2.2,
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
                        Text("Alert",
                          style: AppStyle.appTittleTextBlack
                          ,textAlign: TextAlign.center,),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Your WhatsApp number has been successfully changed,"
                              "Please continue to Login with your new WhatsApp number",
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
                                      'Continue',
                                      style: AppStyle.appBtnTxtStyleBlack,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _logout();
                                    },
                                  ),
                                ),
                              ),
                              /*AppStyle.wSpace,
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

                                    },
                                  ),
                                ),
                              ),*/

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
}
