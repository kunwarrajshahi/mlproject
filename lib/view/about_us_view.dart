import 'package:dmi/controller/api_controller.dart';
import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:dmi/view/details_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'login_view.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  bool showPreamble=false,showMentor=false,showThought=false,showTech=false;
  late String apiToken;
  bool _load=false;
  List thoughtData=[];
  List technologyData=[
    {
      "name":"Mithlesh Kumar Sharma",
      "profile_details":"Software Engineer | 4+ Year Experience in Software Development | iTechBuddy Founder",
      "description":"---",
      "profile_pic":"assets/image/mithlesh.jpg"
    }
  ];
  List mentorBoardData=[
  ];
  List preambleData=[
    {
      "name":"CA Deepak Mundra",
      "profile_details":"CA by Profession, Chef by Passion",
      "description":messagePreamble,
      "profile_pic":"assets/image/deepak.jpeg"
    }
  ];

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
        _getThoughtPartnersData();
      }

    }));
    super.initState();
  }
  _getThoughtPartnersData() async{

    setState(() {
      _load=true;
    });

    try {
      final  result=await ApiController().get("partnerlist",apiToken);
      setState(() {
        //_load = false;

        //debugPrint("response-->$result");
        if (result['success']) {
          thoughtData=result['data'];
          _getMentorBoardData();
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
  _getMentorBoardData() async{

    setState(() {
      _load=true;
    });

    try {
      final  result=await ApiController().get("mentorlist",apiToken);
      setState(() {
        _load = false;

        //debugPrint("response-->$result");
        if (result['success']) {
          mentorBoardData=result['data'];
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
          title: Text("About Us",style: AppStyle.appBarTextBlack,),
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
                  if(showPreamble){
                    showPreamble=false;
                  }else{
                    showPreamble=true;
                  }
                });
              },
              child: Padding(
                padding: AppStyle.commonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Preamble & Idea by",style: AppStyle.appSmallTextAppColor,),
                    Icon(
                      showPreamble?FontAwesomeIcons.angleDown:FontAwesomeIcons.angleRight,
                      size: AppStyle.mediumIconSize,
                      color: AppStyle.appColor,
                    ),
                  ],
                ),
              ),
            ),
            showPreamble?preambleWidget():const SizedBox(),
            const Divider(
              thickness: 1,
            ),
            InkWell(
              onTap: (){
                setState(() {
                  if(showMentor){
                    showMentor=false;
                  }else{
                    showMentor=true;
                  }
                });
              },
              child: Padding(
                padding: AppStyle.commonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Mentors & Patrons",style: AppStyle.appSmallTextAppColor,),
                    Icon(
                      showMentor?FontAwesomeIcons.angleDown:FontAwesomeIcons.angleRight,
                      size: AppStyle.mediumIconSize,
                      color: AppStyle.appColor,
                    ),
                  ],
                ),
              ),
            ),
            showMentor?mentorBoardWidget():const SizedBox(),
            //AppStyle.hSmallSpace,
            const Divider(
              thickness: 1,
            ),
            InkWell(
              onTap: (){
                setState(() {
                  if(showThought){
                    showThought=false;
                  }else{
                    showThought=true;
                  }
                });
              },
              child: Padding(
                padding: AppStyle.commonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Thought partners",style: AppStyle.appSmallTextAppColor,),
                    Icon(
                      showThought?FontAwesomeIcons.angleDown:FontAwesomeIcons.angleRight,
                      size: AppStyle.mediumIconSize,
                      color: AppStyle.appColor,
                    ),
                  ],
                ),
              ),
            ),
            showThought?thoughtWidget():const SizedBox(),
           // AppStyle.hSmallSpace,
            const Divider(
              thickness: 1,
            ),
            /*InkWell(
              onTap: (){
                setState(() {
                  if(showTech){
                    showTech=false;
                  }else{
                    showTech=true;
                  }
                });
              },
              child: Padding(
                padding: AppStyle.commonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Technology lead",style: AppStyle.appSmallTextAppColor,),
                    Icon(
                      showTech?FontAwesomeIcons.angleDown:FontAwesomeIcons.angleRight,
                      size: AppStyle.mediumIconSize,
                      color: AppStyle.appColor,
                    ),
                  ],
                ),
              ),
            ),
            showTech?technologyWidget():const SizedBox(),
            const Divider(
              thickness: 1,
            ),*/
            AppStyle.hSmallSpace,
          ],
        )
      ),
    ) ;
  }

  Widget thoughtWidget(){
    return ListView.builder(
        padding:AppStyle.commonPadding,
        /*gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),*/
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: thoughtData.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsView(
                    name:thoughtData[index]["name"],
                    description: thoughtData[index]["description"],
                    desi: thoughtData[index]["profile_details"],
                    imagePath: thoughtData[index]["profile_pic"],
                  section: "Thought partners",)));
            },
            child: Card(
              color: AppStyle.appShade.withOpacity(0.5),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: AppStyle.appShade,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(thoughtData[index]["profile_pic"]),
                            fit: BoxFit.fill
                        )),
                  ),
                  Flexible(
                    child: Padding(
                      padding: AppStyle.commonPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(thoughtData[index]["name"],style: AppStyle.appSmallTextAppColor,),
                          const SizedBox(height: 5,),
                          Text(thoughtData[index]["profile_details"],
                            style: AppStyle.appSmallTextBlack,maxLines: 1,overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }

  Widget technologyWidget(){
    return ListView.builder(
        padding:AppStyle.commonPadding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: technologyData.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsView(
                    name:technologyData[index]["name"],
                    description: technologyData[index]["description"],
                    desi: technologyData[index]["profile_details"],
                    imagePath: technologyData[index]["profile_pic"],
                    section: "Technology Lead",)));
            },
            child: Card(
              color: AppStyle.appShade.withOpacity(0.5),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: AppStyle.appShade,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: AssetImage(technologyData[index]["profile_pic"]),
                            fit: BoxFit.fill
                        )),
                  ),
                  Flexible(
                    child: Padding(
                      padding: AppStyle.commonPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(technologyData[index]["name"],style: AppStyle.appSmallTextAppColor,),
                          const SizedBox(height: 5,),
                          Text(technologyData[index]["profile_details"],
                            style: AppStyle.appSmallTextBlack,maxLines: 1,overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  Widget mentorBoardWidget(){
    return ListView.builder(
        padding:AppStyle.commonPadding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mentorBoardData.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsView(
                    name:mentorBoardData[index]["name"],
                    description: mentorBoardData[index]["description"],
                    desi: mentorBoardData[index]["profile_details"],
                    imagePath: mentorBoardData[index]["profile_pic"],
                    section: "Mentor Board",)));
            },
            child: Card(
              color: AppStyle.appShade.withOpacity(0.5),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: AppStyle.appShade,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(mentorBoardData[index]["profile_pic"]),
                            fit: BoxFit.fill
                        )),
                  ),
                  Flexible(
                    child: Padding(
                      padding: AppStyle.commonPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mentorBoardData[index]["name"],style: AppStyle.appSmallTextAppColor,),
                          const SizedBox(height: 5,),
                          Text(mentorBoardData[index]["profile_details"],
                            style: AppStyle.appSmallTextBlack,)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }
  Widget preambleWidget(){
    return ListView.builder(
        padding:AppStyle.commonPadding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: preambleData.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsView(
                    name:preambleData[index]["name"],
                    description: preambleData[index]["description"],
                    desi: preambleData[index]["profile_details"],
                    imagePath: preambleData[index]["profile_pic"],
                    section: "Preamble",)));
            },
            child: Card(
              color: AppStyle.appShade.withOpacity(0.5),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: AppStyle.appShade,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: AssetImage(preambleData[index]["profile_pic"]),
                            fit: BoxFit.fill
                        )),
                  ),
                  Flexible(
                    child: Padding(
                      padding: AppStyle.commonPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(preambleData[index]["name"],style: AppStyle.appSmallTextAppColor,),
                          const SizedBox(height: 5,),
                          Text(preambleData[index]["profile_details"],
                            style: AppStyle.appSmallTextBlack,)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }

}
