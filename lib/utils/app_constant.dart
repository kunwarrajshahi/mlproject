import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custome_dialog.dart';


const String message=
    "DMi(Deepak Mundra Initiative, Adding Value to Lives)\n\n"

    "I believe we owe a lot to the society and environment we live in.\n\n"

    "I would like to call it PSR (personal social responsibility), as my bit"
    " towards my PSR i want to contribute back to the society and the environment,"
    " have some ideas around it and would like to implement these ideas gradually.\n\n"

    "To start with i am offering paper less visiting card to"
    " masses free for lifetime. Yes you guessed it right,"
    " idea is to save paper and say no to paper visiting cards."
    "Little bit we all can do for the nature.";

const String messagePreamble="We all owe & wish to contribute towards the environment we live in.\n\n"

"Introducing PSR\n"
"As in corporate world we call it CSR (Corporate Social Responsibility), would like to coin a new term for Individuals like us - PSR (Personal Social Responsibility).\n"
"PSR is like social responsibilities of Individuals like us, our bit, we can contribute back to the society and the environment we live in.\n\n"

"CSR is imposed by law while PSR is imposed by heart.\n\n"

"Have some thoughts & ideas around it and would like to implement these ideas gradually.\n\n"

"To start with we are offering a this platform where you can stop giving paper visiting cards and also stop accepting paper visiting cards.\n"
"- we are offering paper less visiting card to masses for free for lifetime in the form of QR code.\n"
"- we also offering visiting card scanner, whereby when someone giving you paper visiting card, we just scan the card and return the paper visiting card then & there.\n"
"- Added advantage is that the recipient of the card is able to save card in mobile contacts then & there and becoming more efficient in terms of contact management. Generally otherwise majority of these paper visiting cards are never saved in phone contacts.\n\n"

"Yes you have understood it right, idea is to save paper and say no to paper visiting cards.\n\n"

"Little bit we all can do for the nature & environment. And we all treat this as our PSR.\n\n"

"Hypothesis & Assumptions\n"
"- 20,000 visiting cards = 1 Tree 🌳\n"
"- On an average each person does 200 meetings every year\n"
"- if 50 persons start using our platform, results into saving of 1 Tree annually\n\n"

"Encourage Others\n"
"Please do encourage others to use this mobile app, also spread awareness among people in your network to use this platform\n\n"

"This platform would help individuals to contribute back to the nature & help them #SaveTrees\n\n"

"Thanking you for being part of this initiative.\n"
"Regards, Deepak Mundra\n"
"On Behalf of Mentor Board, Thought Partners, Technology Partners & all the Volunteers";

const String intro="(Our bit to the environment we livein)"
    "\n\nThis mobile app has got 2 features which enables you stop using paper visiting cards :"
    "\n\n1) Create your digital visiting card and share via QR card"
    "\n2) Scan and save visiting card of other people"
    "\n\nAnd thus Save Trees 🙂";

class AppStyle{
  static Map<String, String> headers = {"Content-type": "application/json"};

  //Production URL
  //static String baseURL = "https://deepakmundra.com/api/";
  static String baseURL = "https://savetreesvc.com/api/";
  static Color appColor=Colors.teal;
  static Color appShade=const Color(0xffECF2FF);
  static Color backgroundColor=const Color(0xfff0f0f0);

  //size
  static double smallTextSize=12;
  static double mediumTextSize=16;
  static double bigTextSize=20;
  static double tooBigTextSize=28;

  static double smallIconSize=18;
  static double mediumIconSize=20;
  static double bigIconSize=22;
  static double tooBigIconSize=24;

  static SizedBox hSpace=const SizedBox(height: 15,);
  static SizedBox hSmallSpace=const SizedBox(height: 10,);
  static SizedBox wSpace=const SizedBox(width: 10,);


  static EdgeInsets commonPadding=const EdgeInsets.all(6);


//normal small text style
  static TextStyle appSmallTextBlack= GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.black
  );
  static TextStyle appSmallTextGrey= GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.black
  );
  static TextStyle appSmallTextAppColor=  GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w500,
      color:appColor
  );
  static TextStyle appSmallTextAppWhite=  GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w500,
      color:Colors.white
  );

//bold small text style
  static TextStyle appSmallBoldTextBlack=GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w600,
      color: Colors.black
  );
  static TextStyle appSmallBoldTextGrey=GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w600,
      color: Colors.grey
  );
  static TextStyle appSmallBoldTextAppColor=  GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w600,
      color:appColor
  );
  static TextStyle appSmallBoldTextAppWhite=  GoogleFonts.inter(
      fontSize: smallTextSize,
      fontWeight:FontWeight.w600,
      color:Colors.white
  );

//title text style
  static TextStyle appTittleTextBlack=GoogleFonts.inter(
      fontSize: mediumTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.black
  );
  static TextStyle appTittleTextWhite=GoogleFonts.inter(
      fontSize: mediumTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.white
  );
  static TextStyle appTittleTextAppColor=GoogleFonts.inter(
      fontSize: mediumTextSize,
      fontWeight:FontWeight.w500,
      color: appColor
  );
  static TextStyle appTittleTextGrey=GoogleFonts.inter(
      fontSize: mediumTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.grey
  );

//appBar text style
  static TextStyle appBarTextBlack=GoogleFonts.inter(
      fontSize: bigTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.black
  );
  static TextStyle appBarTextWhite=GoogleFonts.inter(
      fontSize: bigTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.white
  );
  static TextStyle appBarTextAppColor=GoogleFonts.inter(
      fontSize: bigTextSize,
      fontWeight:FontWeight.w500,
      color: appColor
  );

  //too big
  static TextStyle appTooBigTextBlack=GoogleFonts.inter(
      fontSize: tooBigTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.black
  );
  static TextStyle appTooBigTextWhite=GoogleFonts.inter(
      fontSize: tooBigTextSize,
      fontWeight:FontWeight.w500,
      color: Colors.white
  );
  static TextStyle appTooBigTextAppColor=GoogleFonts.inter(
      fontSize: tooBigTextSize,
      fontWeight:FontWeight.w500,
      color: appColor
  );

//button text style

  static TextStyle appBtnTxtStyleWhite=GoogleFonts.inter(
      fontSize: mediumTextSize,
      color: Colors.white,
      fontWeight: FontWeight.w600);
  static TextStyle appBtnTxtStyleAppColor=GoogleFonts.inter(
      fontSize: mediumTextSize,
      color: appColor,
      fontWeight: FontWeight.w600);
  static TextStyle appBtnTxtStyleBlack=GoogleFonts.inter(
      fontSize: mediumTextSize,
      color: Colors.black87,
      fontWeight: FontWeight.w600);
  static TextStyle appSplashTextAppColor=  GoogleFonts.inter(
      fontSize: 12,
      fontWeight:FontWeight.w500,
      color:Colors.black87,
      wordSpacing: 5,
  );

  static Widget loading=
  Column(children: [
    CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Positioned(
            left: 0,right: 0,bottom: 0,top: 0,
            child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(backgroundColor: AppStyle.appShade,
                )),),
          Image.asset("assets/image/dmi_png.png",scale: 10,),
        ],
      ),
    ),
    hSmallSpace,
    Text("Paperless Visiting Card",style: AppStyle.appSmallTextGrey,)
  ],);
  static Widget loadingWhite=
  Column(children: [
    CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Positioned(
            left: 0,right: 0,bottom: 0,top: 0,
            child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(backgroundColor: AppStyle.appShade,
                )),),
          Image.asset("assets/image/dmi_png.png",scale: 8,),
        ],
      ),
    ),
    hSmallSpace,
    Text("Paperless Visiting Card",style: AppStyle.appSmallTextAppWhite,)
  ],);



  static List<Widget> day(){
    List<Widget> days=[Center(child: Text('*\tdd',style: AppStyle.appSmallBoldTextGrey,textAlign: TextAlign.center,)),];
    for(int i=0;i<=31;i++){
      days.add(Center(child: Text('$i',style: AppStyle.appSmallBoldTextBlack,textAlign: TextAlign.center,)),);
    }
    return days;
  }
  static List<Widget> month(){
    List<Widget> months=[Center(child: Text('*\tmm',style: AppStyle.appSmallBoldTextGrey,textAlign: TextAlign.center,)),];
    for(int i=0;i<=12;i++){
      months.add(Center(child: Text('$i',style: AppStyle.appSmallBoldTextBlack,textAlign: TextAlign.center,)),);
    }
    return months;
  }
  static List<Widget> years(){
    List<Widget> year=[Center(child: Text('yyyy',style: AppStyle.appSmallBoldTextGrey,textAlign: TextAlign.center,)),];;
    for(int i=1800;i<=2023;i++){
      year.add(Center(child: Text('$i',style: AppStyle.appSmallBoldTextBlack,textAlign: TextAlign.center,)),);
    }
    return year;
  }

  static String getVal(String val){

    if(val.isEmpty || val=="" || val==null){
      return "";
    }else{
      return val;
    }
  }

  static   String getDay(String stringdate)
  {
    String _stringdate="";

    List<String> validadeSplit = stringdate.split('/');

    if(validadeSplit.length > 1)
    {
      int day = int.parse(validadeSplit[0].toString());
      int month = int.parse(validadeSplit[1].toString());
      int year = int.parse(validadeSplit[2].toString());

      _stringdate="$day";
    }
    return _stringdate;
  }

  static   String getMonth(String stringdate)
  {
    String _stringdate="";

    List<String> validadeSplit = stringdate.split('/');

    if(validadeSplit.length > 1)
    {
      int day = int.parse(validadeSplit[0].toString());
      int month = int.parse(validadeSplit[1].toString());
      int year = int.parse(validadeSplit[2].toString());

      _stringdate="$month";
    }
    return _stringdate;
  }

  static   String getYear(String stringdate)
  {
    String _stringdate="";

    List<String> validadeSplit = stringdate.split('/');

    if(validadeSplit.length > 1)
    {
      int day = int.parse(validadeSplit[0].toString());
      int month = int.parse(validadeSplit[1].toString());
      int year = int.parse(validadeSplit[2].toString());

      _stringdate="$year";
    }
    return _stringdate;
  }

  static Widget footer=ClipPath(
      clipper: OvalTopBorderClipper(),
      child: Container(
        padding: const EdgeInsets.only(top: 25,bottom: 10),
        alignment: Alignment.center,
        color: AppStyle.appShade,
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text:  TextSpan(
                text: 'While you ',
                style: AppStyle.appSmallTextBlack,
                children: <TextSpan>[
                  TextSpan(text: '#',
                    style: AppStyle.appSmallTextBlack.copyWith(color: Colors.blue),),
                  TextSpan(text: 'save',
                    style: AppStyle.appSmallTextBlack.copyWith(color: Colors.red),),
                  TextSpan(text: 'trees',
                    style: AppStyle.appSmallTextBlack.copyWith(color: AppStyle.appColor),),
                  TextSpan(text: ',\nalso be more organised in your contact management',
                    style: AppStyle.appSmallTextBlack,),
                ],
              ),
            ),
            /*Text("While you #saveTrees, you also be more organised in your contact management",
                        style: AppStyle.appSmallTextBlack,textAlign: TextAlign.center,),*/
            AppStyle.hSmallSpace,
            Text("🇮🇳 This app is developed in Bharat 🇮🇳",
              style: AppStyle.appSmallTextAppColor.copyWith(fontSize: 11,fontWeight: FontWeight.w600),)
          ],
        ),
      )
  );
  static Widget header=Column(
    children: [
      ClipPath(
        clipper: OvalBottomBorderClipper(),
        child: Container(
          width: Size.infinite.width,
          // padding: AppStyle.commonPadding,
          decoration: BoxDecoration(
            color: AppStyle.appShade,
          ),
          child:Padding(
            padding: const EdgeInsets.only(top: 5,bottom: 10),
            child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/image/dmi_png.png",)
            ),
          ),
        ),
      ),
      AppStyle.hSmallSpace,
      RichText(
        textAlign: TextAlign.center,
        text:  TextSpan(
          text: 'Thanks for being part of\n',
          style: AppStyle.appSmallTextBlack,
          children: <TextSpan>[
            TextSpan(text: '#',
              style: AppStyle.appSmallTextBlack.copyWith(color: Colors.blue),),
            TextSpan(text: 'save',
              style: AppStyle.appSmallTextBlack.copyWith(color: Colors.red),),
            TextSpan(text: 'trees',
              style: AppStyle.appSmallTextBlack.copyWith(color: AppStyle.appColor),),
            TextSpan(text: '\tinitiative',
              style: AppStyle.appSmallTextBlack,),
          ],
        ),
      ),
    ],
  );


  static   Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      //webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static Widget errmsg(String text,bool show){
    //error message widget.
    if(show == true){
      //if error is true then show error message box
      return Container(
        padding: const EdgeInsets.all(10.00),
        margin: const EdgeInsets.only(bottom: 10.00),
        color: Colors.red,
        child: Row(children: [

          Container(
            margin: const EdgeInsets.only(right:6.00),
            child: const Icon(Icons.info, color: Colors.white),
          ), // icon for error message

          Text(text, style: AppStyle.appSmallTextAppWhite),
          //show error message text
        ]),
      );
    }else{
      return Container();
      //if error is false, return empty container.
    }
  }

  static void showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => PlaceholderDialog(
        icon: Icon(
          FontAwesomeIcons.internetExplorer,
          color: AppStyle.appColor,
          size: 50.0,
        ),
        title: 'Alert',
        message: 'Check your Internet Connection!',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Close',style: AppStyle.appSmallTextAppColor,),
          ),
        ],
      ),
    );
  }

}