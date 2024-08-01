import 'dart:async';
import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:dmi/view/create_contact_view.dart';
import 'package:dmi/view/login_view.dart';
import 'package:dmi/view/terms_conditions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dashboard_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>  with TickerProviderStateMixin {
  bool show1=false,show2=false,show3=false,show4=false,show5=false;

  @override
  void initState() {
    super.initState();
    printOne();
    printTwo();
    printThree();
    printFour();
    printFive();
  }

  printFive() async {
    var _duration = const Duration(milliseconds: 3000);
    return Timer(_duration, navigationFivePage);
  }
  printFour() async {
    var _duration = const Duration(milliseconds: 2500);
    return Timer(_duration, navigationFourPage);
  }
  printThree() async {
    var _duration = const Duration(milliseconds: 2000);
    return Timer(_duration, navigationThreePage);
  }
  printTwo() async {
    var _duration = const Duration(milliseconds: 1500);
    return Timer(_duration, navigationTwoPage);
  }
  printOne() async {
    var _duration = const Duration(milliseconds: 1000);
    //debugPrint("timer--> $_duration");
    return Timer(_duration, navigationOnePage);
  }

  void navigationFivePage() {
    setState(() {
      show5=true;
      startTime();
    });
  }
  void navigationFourPage() {
    setState(() {
      show4=true;
    });
  }
  void navigationThreePage() {
    setState(() {
      show3=true;
    });
  }
  void navigationTwoPage() {
    setState(() {
      show2=true;
    });
  }
  void navigationOnePage() {
    setState(() {
      show1=true;
    });
  }

  startTime() async {
    var _duration = const Duration(milliseconds: 2500);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    AppCookies.instance.getStringValue("tcpc").then((value) =>
        setState(() {
          String termsCondition=value;
          if (termsCondition == "T") {
            //debugPrint("terms and contention value accepted $value");
          }else{
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const TermsAndConditionsView()));
          }
        }));
    AppCookies.instance
        .getStringValue("Login")
        .then((value) => setState(() {
      String checkOneTime = value;

      if(checkOneTime=="T" && checkOneTime.isNotEmpty ){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const DashboardView()));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView()));
      }}));

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height/6,
                child: Image.asset("assets/image/c1.png"),
                ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                     // padding: AppStyle.commonPadding,
                      decoration: BoxDecoration(
                        color: AppStyle.appShade,
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(top: 5,bottom: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                 /* Positioned(
                                    child: SizedBox(
                                        child: CircularProgressIndicator(backgroundColor: AppStyle.appShade,
                                        )),
                                    left: 0,right: 0,bottom: 0,top: 0,),*/
                                  Image.asset("assets/image/dmi_png.png",),
                                ],
                              ),
                            ),
                          ],
                        ),/*Image.asset("assets/image/dmi_png.png",height: 12.h,)*/
                      ),
                    ),
                  ),
                  AppStyle.hSmallSpace,
                  RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      text: 'Thanks',
                      style: AppStyle.appSmallTextBlack,
                      children: <TextSpan>[
                        show1?TextSpan(text: '\tfor',
                          style: AppStyle.appSmallTextBlack,):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                        show2?TextSpan(text: '\tbeing',
                          style: AppStyle.appSmallTextBlack,):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                        show3?TextSpan(text: '\tpart',
                          style: AppStyle.appSmallTextBlack,):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                        show4?TextSpan(text: '\tof\n',
                          style: AppStyle.appSmallTextBlack,):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                        show5?TextSpan(text: '#',
                          style: AppStyle.appSmallTextBlack.copyWith(color: Colors.blue),):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                        show5?TextSpan(text: 'save',
                          style: AppStyle.appSmallTextBlack.copyWith(color: Colors.red),):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                        show5?TextSpan(text: 'trees',
                          style: AppStyle.appSmallTextBlack.copyWith(color: AppStyle.appColor),):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                        show5?TextSpan(text: '\tinitiative',
                          style: AppStyle.appSmallTextBlack,):TextSpan(text: '',
                          style: AppStyle.appSmallTextBlack,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:AppStyle.footer
            ),

            //AppStyle.hSmallSpace,
          ],
        )
      ),
    );
  }
}






class TransitionsHomePage extends StatefulWidget {
  const TransitionsHomePage({Key? key}) : super(key: key);

  @override
  TransitionsHomePageState createState() => TransitionsHomePageState();
}

class TransitionsHomePageState extends State<TransitionsHomePage> {
  bool _slowAnimations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Material Transitions')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _TransitionListTile(
                  title: 'Container transform',
                  subtitle: 'OpenContainer',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const SplashView();
                        },
                      ),
                    );
                  },
                ),
                _TransitionListTile(
                  title: 'Shared axis',
                  subtitle: 'SharedAxisTransition',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const SplashView();
                        },
                      ),
                    );
                  },
                ),
                _TransitionListTile(
                  title: 'Fade through',
                  subtitle: 'FadeThroughTransition',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const SplashView();
                        },
                      ),
                    );
                  },
                ),
                _TransitionListTile(
                  title: 'Fade',
                  subtitle: 'FadeScaleTransition',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const SplashView();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 0.0),
          SafeArea(
            child: SwitchListTile(
              value: _slowAnimations,
              onChanged: (bool value) async {
                setState(() {
                  _slowAnimations = value;
                });
                // Wait until the Switch is done animating before actually slowing
                // down time.
                if (_slowAnimations) {
                  await Future<void>.delayed(const Duration(milliseconds: 300));
                }
                timeDilation = _slowAnimations ? 20.0 : 1.0;
              },
              title: const Text('Slow animations'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransitionListTile extends StatelessWidget {
  const _TransitionListTile({
    this.onTap,
    required this.title,
    required this.subtitle,
  });

  final GestureTapCallback? onTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      leading: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.black54,
          ),
        ),
        child: const Icon(
          Icons.play_arrow,
          size: 35,
        ),
      ),
      onTap: onTap,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
