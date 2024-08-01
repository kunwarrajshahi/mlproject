import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmi/controller/api_controller.dart';
import 'package:dmi/utils/app_constant.dart';
import 'package:dmi/utils/app_cookies.dart';
import 'package:dmi/view/scan_card_front_back_holder_view.dart';
import 'package:dmi/view/scan_card_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../widgets/custome_dialog.dart';
import 'login_view.dart';

class SavedBusinessCardDetails extends StatefulWidget {

  const SavedBusinessCardDetails({Key? key}) : super(key: key);


  @override
  State<SavedBusinessCardDetails> createState() => _SavedBusinessCardDetailsState();
}

class _SavedBusinessCardDetailsState extends State<SavedBusinessCardDetails> {
  late String apiToken;
  bool _load=false,showSearchView=false;
  List _cardData=[];
  List _cardSearchData=[];
  int value = 0;
  TextEditingController _controllerSearch=TextEditingController();
  @override
  void initState() {

    AppCookies.instance
        .getStringValue("whatsAppNumber")
        .then((value) => setState(() {
    }));

    AppCookies.instance
        .getStringValue("apiToken")
        .then((value) => setState(() {
      apiToken = value;
      if(apiToken.isEmpty){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView()));
      }else{
        _getUserProfileData("");
      }

    }));
    super.initState();
  }

  _getUserProfileData(String filter) async{



    setState(() {
      showSearchView=false;
      _load=true;
    });

    Map data={
      "filter":"$filter"//ByName | ByDate
    };

    try {
      final  result=await ApiController().post("profile/v1/scaned/card/list",data,apiToken);

      setState(() {
        _load = false;

        if (result['success']) {
          //personal details
          _cardData=result['data'];
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

  _getSearchUserProfileData(String search) async{

    setState(() {
      _load=true;
    });

    Map data={
      "search":search//ByName | ByDate
    };

    try {
      final  result=await ApiController().post("profile/v2/scaned/card/search",data,apiToken);

      setState(() {
        _load = false;

        if (result['success']) {
          //personal details
          _cardSearchData=result['data'];
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

  _deleteCard(String id) async{

    setState(() {
      _load=true;
    });

    Map data={
      "cardId":"$id"//ByName | ByDate
    };

    try {
      final  result=await ApiController().post("profile/v1/scaned/card/delete",data,apiToken);

      setState(() {
        _load = false;

        if (result['success']) {
          _getUserProfileData("");
          final snackBar = SnackBar(
            content: Text(
              '${result['message']}',
              style: AppStyle.appSmallTextAppWhite,
            ),
            backgroundColor: (Colors.black87),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
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
  _validateNumber(String number) async{

    setState(() {
      _load=true;
    });

    Map data={
      "whatsAppNo":number.replaceAll(' ', '')//ByName | ByDate
    };

    try {
      final  result=await ApiController().post("profile/v1/checkWhatsapp",data,apiToken);

      setState(() {
        _load = false;

        if (result['success']) {

          AppStyle.launchInBrowser(Uri.parse(
              "whatsapp://send?phone=${number.replaceAll(' ', '')}"
          ));

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
              message: "Invalid WhatsApp Number",
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Close',style: AppStyle.appSmallTextAppColor,),
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
          title: Text("Saved Visiting Card",style: AppStyle.appBarTextBlack,),
          /*actions: [PopupMenuButton(
              padding: EdgeInsets.zero,
              shape: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppStyle.appShade,
                  )
              ),
              onSelected: (value) {
                setState(() {
                  if(value==1){
                    _getUserProfileData("ByFName");
                  }else if(value==2){
                    _getUserProfileData("ByLName");
                  }else if(value==3){
                    _getUserProfileData("ByCompany");
                  }else{
                    _getUserProfileData("ByDate");
                  }
                });
              },
              icon: Icon(FontAwesomeIcons.filter,color: Colors.black,
                size: AppStyle.mediumIconSize,),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By Name",style: AppStyle.appSmallTextBlack,),
                      Icon(
                        FontAwesomeIcons.sortAlphaDown,
                        color: AppStyle.appColor,
                        size: AppStyle.smallIconSize,
                      ),
                    ],
                  ),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By Last Name",style: AppStyle.appSmallTextBlack,),
                      Icon(
                        FontAwesomeIcons.sortAlphaDown,
                        color: AppStyle.appColor,
                        size: AppStyle.smallIconSize,
                      ),
                    ],
                  ),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By Company",style: AppStyle.appSmallTextBlack,),
                      Icon(
                        FontAwesomeIcons.sortAlphaDown,
                        color: AppStyle.appColor,
                        size: AppStyle.smallIconSize,
                      ),
                    ],
                  ),
                  value: 3,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By Date",style: AppStyle.appSmallTextBlack,),
                      Icon(
                        FontAwesomeIcons.calendarCheck,
                        color: AppStyle.appColor,
                        size: AppStyle.smallIconSize,
                      ),
                    ],
                  ),
                  value: 4,
                ),
              ]
          )],*/
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              color: AppStyle.appShade,
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _controllerSearch,
                  style: AppStyle.appSmallTextBlack,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  //maxLength: 10,
                  decoration:  InputDecoration(
                    contentPadding: const EdgeInsets.all(05),
                    fillColor: AppStyle.appShade.withOpacity(0.5),
                    prefixIcon: Icon(FontAwesomeIcons.magnifyingGlassMinus,
                      color: AppStyle.appColor,size: AppStyle.smallIconSize,),
                    suffixIcon: _controllerSearch.text.isNotEmpty?InkWell(
                      onTap:(){
                        setState(() {
                          //_controllerSearch.text="";
                          showSearchView=false;
                          FocusScope.of(context).unfocus();
                          _controllerSearch.clear();
                        });
                      },
                      child: Icon(FontAwesomeIcons.xmark,
                        color: AppStyle.appColor,size: AppStyle.smallIconSize,),
                    ):const SizedBox(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
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
                    //labelText: 'Search your',
                    hintText: "Which card you looking for",
                    hintStyle: AppStyle.appSmallTextAppColor.copyWith(color: Colors.grey),
                    labelStyle:AppStyle.appSmallTextBlack,
                  ),
                  onChanged: (data){
                    if(data.isNotEmpty){
                      showSearchView=true;
                      _getSearchUserProfileData(data);
                    }else{
                      showSearchView=false;
                    }
                  },
                ),
              ),
            ),
            showSearchView?const SizedBox():_cardData.isNotEmpty?Container(
              color: AppStyle.appShade,
              //height: 100,
              width: MediaQuery.of(context).size.width,
              padding: AppStyle.commonPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customRadioButton("Date", 4),
                  customRadioButton("Company", 3),
                  customRadioButton("First Name", 1),
                  customRadioButton("Surname", 2),
                ],
              ),
            ):const SizedBox(),
            _load?Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppStyle.loading,
            )):_cardData.isNotEmpty?Flexible(child:
            showSearchView?_cardSearchData.isNotEmpty?cardSearchWidget():
            Center(child: Text("No data found!",style: AppStyle.appSmallTextGrey,)):
            cardWidget()):Container(
              padding: const EdgeInsets.all(8.0),
              height: MediaQuery.of(context).size.height/2,
              child: Center(child: Text("No data found!",style: AppStyle.appSmallTextGrey,)),
            ),
          ],
        )
      ),
    );
  }
  Widget cardWidget(){
    return ListView.builder(
        padding:AppStyle.commonPadding,
       // shrinkWrap: true,
       // physics: const NeverScrollableScrollPhysics(),
        itemCount: _cardData.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: (){
             /* Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScanCardView(
                    view: "T",
                    fullName: _cardData[index]["contactName"]??"",
                    companyName: _cardData[index]["companyName"]??"",
                    jobTittle: _cardData[index]["jobTitle"]??"",
                    officeContact: _cardData[index]["workPhoneno"]??"",
                    email: _cardData[index]["email"]??"",
                    address: _cardData[index]["address"]??"",
                    phone: _cardData[index]["mobileNo"]??"",
                    dob: _cardData[index]["dob"]??"",
                    profilePic: _cardData[index]["profilePic"],
                    id: _cardData[index]["id"].toString(),))).then((value) => _getUserProfileData(""));*/
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScanCardFrontBackHolderView(
                      view: "T",
                      name: _cardData[index]["name"]??"",
                      surName: _cardData[index]["surName"]??"",
                      profilePic2: _cardData[index]["profilePic2"]??"",
                      freeField: _cardData[index]["freeField"]??"",
                      email2: _cardData[index]["email2"]??"",
                      mobileNo2: _cardData[index]["mobileNo2"]??"",
                      fullName: _cardData[index]["contactName"]??"",
                      companyName: _cardData[index]["companyName"]??"",
                      jobTittle: _cardData[index]["jobTitle"]??"",
                      officeContact: _cardData[index]["workPhoneno"]??"",
                      email: _cardData[index]["email"]??"",
                      address: _cardData[index]["address"]??"",
                      phone: _cardData[index]["mobileNo"]??"",
                      dob: _cardData[index]["dob"]??"",
                      profilePic: _cardData[index]["profilePic"],
                      id: _cardData[index]["id"].toString()))).then((value) => _getUserProfileData(""));
            },
            child: Card(
              color: AppStyle.appShade.withOpacity(0.5),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardData[index]["profilePic"]!=null?Container(
                        width: 120,
                        height: 80,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            color: AppStyle.appShade,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage(_cardData[index]["profilePic"]),
                                fit: BoxFit.fill
                            )),
                      ):Container(
                        width: 120,
                        height: 80,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            color: AppStyle.appShade,
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                                image: AssetImage("assets/image/new_logo.png"),
                                fit: BoxFit.fill
                            )),
                      ),

                      //AppStyle.hSmallSpace,
                      SizedBox(
                       // width: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            DateFormat.yMMMMd().format(DateTime.parse(_cardData[index]["created_at"])),
                            style: AppStyle.appSmallTextBlack,overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: AppStyle.commonPadding,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_cardData[index]["contactName"]}",style: AppStyle.appSmallTextAppColor,),
                                    const SizedBox(height: 5,),
                                   /* Text(_cardData[index]["jobTitle"],
                                      style: AppStyle.appSmallTextBlack,maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    Text(_cardData[index]["email"],
                                      style: AppStyle.appSmallTextBlack,maxLines: 1,overflow: TextOverflow.ellipsis,),*/
                                    Text("${_cardData[index]["companyName"]??"---"}",
                                      style: AppStyle.appSmallTextBlack,maxLines: 1,overflow: TextOverflow.ellipsis,)
                                  ],
                                ),
                              ),
                            ),
                            //const Spacer(),

                          ],
                        ),
                        const Divider(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap:(){
                                if(_cardData[index]["mobileNo"].toString().isNotEmpty && _cardData[index]["mobileNo"]!=null){
                                  AppStyle.launchInBrowser(Uri.parse("tel://${_cardData[index]["mobileNo"].replaceAll(' ', '')}"));
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => PlaceholderDialog(
                                      icon: Icon(
                                        FontAwesomeIcons.triangleExclamation,
                                        color: AppStyle.appColor,
                                        size: 50.0,
                                      ),
                                      title: 'Alert',
                                      message: 'Mobile Number Not Found! Please Update Mobile Number in Card Holder',
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: Text('Close',style: AppStyle.appSmallTextAppColor,),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                              },
                              child: CircleAvatar(
                                backgroundColor: AppStyle.appShade,
                                radius: 15,
                                child: Icon(FontAwesomeIcons.phoneFlip,color: AppStyle.appColor,
                                  size: AppStyle.smallIconSize,),
                              ),
                            ),
                            AppStyle.wSpace,
                            InkWell(
                              onTap:(){
                                if(_cardData[index]["mobileNo"].toString().isNotEmpty && _cardData[index]["mobileNo"]!=null){
                                  _validateNumber(_cardData[index]["mobileNo"].toString());
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => PlaceholderDialog(
                                      icon: Icon(
                                        FontAwesomeIcons.triangleExclamation,
                                        color: AppStyle.appColor,
                                        size: 50.0,
                                      ),
                                      title: 'Alert',
                                      message: 'Mobile Number Not Found! Please Update Mobile Number in Card Holder',
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: Text('Close',style: AppStyle.appSmallTextAppColor,),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                              },
                              child: CircleAvatar(
                                backgroundColor: AppStyle.appShade,
                                radius: 15,
                                child: Icon(FontAwesomeIcons.whatsapp,color: AppStyle.appColor,
                                  size: AppStyle.smallIconSize,),
                              ),
                            ),
                            AppStyle.wSpace,
                            CircleAvatar(
                              backgroundColor: AppStyle.appShade,
                              radius: 15,
                              child: PopupMenuButton(
                                  padding: EdgeInsets.zero,
                                  shape: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppStyle.appShade,
                                      )
                                  ),
                                  onSelected: (value) async {

                                    if(value==1){
                                      /*Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ScanCardView(
                                            view: "T",
                                            fullName: _cardData[index]["contactName"]??"",
                                            companyName: _cardData[index]["companyName"]??"",
                                            jobTittle: _cardData[index]["jobTitle"]??"",
                                            officeContact: _cardData[index]["workPhoneno"]??"",
                                            email: _cardData[index]["email"]??"",
                                            address: _cardData[index]["address"]??"",
                                            phone: _cardData[index]["mobileNo"]??"",
                                              dob: _cardData[index]["dob"]??"",
                                            profilePic: _cardData[index]["profilePic"],
                                              id: _cardData[index]["id"].toString()))).then((value) => _getUserProfileData(""));*/
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ScanCardFrontBackHolderView(
                                              view: "T",
                                              name: _cardData[index]["name"]??"",
                                              surName: _cardData[index]["surName"]??"",
                                              profilePic2: _cardData[index]["profilePic2"]??"",
                                              freeField: _cardData[index]["freeField"]??"",
                                              email2: _cardData[index]["email2"]??"",
                                              mobileNo2: _cardData[index]["mobileNo2"]??"",
                                              fullName: _cardData[index]["contactName"]??"",
                                              companyName: _cardData[index]["companyName"]??"",
                                              jobTittle: _cardData[index]["jobTitle"]??"",
                                              officeContact: _cardData[index]["workPhoneno"]??"",
                                              email: _cardData[index]["email"]??"",
                                              address: _cardData[index]["address"]??"",
                                              phone: _cardData[index]["mobileNo"]??"",
                                              dob: _cardData[index]["dob"]??"",
                                              profilePic: _cardData[index]["profilePic"],
                                              id: _cardData[index]["id"].toString()))).then((value) => _getUserProfileData(""));
                                    }
                                    else if(value==2){
                                      _showDialog(_cardData[index]["id"].toString());
                                    }else if(value==4){
                                      setState(() {
                                        _load=true;
                                      });
                                      if(_cardData[index]["profilePic"]!=null && _cardData[index]["profilePic2"]!=null){
                                        final response = await get(Uri.parse(_cardData[index]["profilePic"]));
                                        final directory = await getTemporaryDirectory();
                                        File file = await File('${directory.path}/${_cardData[index]["mobileNo"]}_image.png')
                                            .writeAsBytes(response.bodyBytes);

                                        //back
                                        final response2 = await get(Uri.parse(_cardData[index]["profilePic2"]));
                                        final directory2 = await getTemporaryDirectory();
                                        File file2 = await File('${directory2.path}/${_cardData[index]["mobileNo"]}_image2.png')
                                            .writeAsBytes(response2.bodyBytes);


                                        final result = await Share.shareXFiles([XFile(file.path),XFile(file2.path)]);

                                        if (result.status == ShareResultStatus.success) {
                                          //debugPrint('Thank you for sharing the picture!');
                                          setState(() {
                                            _load=false;
                                          });
                                        }else{
                                          setState(() {
                                            _load=false;
                                          });
                                        }
                                      }else{
                                        if(_cardData[index]["profilePic"]!=null){
                                          final response = await get(Uri.parse(_cardData[index]["profilePic"]));
                                          final directory = await getTemporaryDirectory();
                                          File file = await File('${directory.path}/${_cardData[index]["mobileNo"]}_image.png')
                                              .writeAsBytes(response.bodyBytes);
                                          final result = await Share.shareXFiles([XFile(file.path)]);

                                          if (result.status == ShareResultStatus.success) {
                                            //debugPrint('Thank you for sharing the picture!');
                                            setState(() {
                                              _load=false;
                                            });
                                          }else{
                                            setState(() {
                                              _load=false;
                                            });
                                          }
                                        }
                                        else{

                                            //back
                                            final response2 = await get(Uri.parse(_cardData[index]["profilePic2"]));
                                            final directory2 = await getTemporaryDirectory();
                                            File file2 = await File('${directory2.path}/${_cardData[index]["mobileNo"]}_image2.png')
                                                .writeAsBytes(response2.bodyBytes);

                                            final result = await Share.shareXFiles([XFile(file2.path)]);

                                            if (result.status == ShareResultStatus.success) {
                                              //debugPrint('Thank you for sharing the picture!');
                                              setState(() {
                                                _load=false;
                                              });
                                            }else{
                                              setState(() {
                                                _load=false;
                                              });
                                            }

                                        }
                                      }
                                    }
                                    else{
                                      setState(() {
                                        _load=true;
                                      });
                                      final response = await get(Uri.parse(_cardData[index]["profilePic"]));
                                      final directory = await getTemporaryDirectory();
                                      File file = await File('${directory.path}/${_cardData[index]["mobileNo"]}_image.png')
                                          .writeAsBytes(response.bodyBytes);

                                      final result = await Share.shareWithResult(/*[XFile(file.path)]*/
                                              "Hello,\n\nThanks for connecting Save Trees VC!\n\n"
                                              "Front Visiting Card: ${_cardData[index]["profilePic"]??""}\n"
                                              "Back Visiting Card: ${_cardData[index]["profilePic2"]??""}\n\n"
                                              "Date of Birth: ${_cardData[index]["dob"]??""}\n"
                                              "Name: ${_cardData[index]["contactName"]??""}\n"
                                                  "Designation: ${_cardData[index]["jobTitle"]??""}\n"
                                              "Company Name: ${_cardData[index]["companyName"]??""}\n"
                                                  "Email : ${_cardData[index]["email"]??""}\n"
                                                  "Email 2: ${_cardData[index]["email2"]??""}\n"
                                                  "Mobile No: ${_cardData[index]["mobileNo"]??""}\n"
                                              "office Contact: ${_cardData[index]["workPhoneno"]??""}\n"
                                              "office Contact 2: ${_cardData[index]["mobileNo2"]??""}\n"
                                              "Address: ${_cardData[index]["address"]??""}\n"
                                                  "Free Field: ${_cardData[index]["freeField"]??""}\n"
                                              "\n\n"
                                              "\n\nRegards"
                                              "\n\nSave Trees VC"
                                              "\n\nHave a nice day!");
                                      if (result.status == ShareResultStatus.success) {
                                        setState(() {
                                          _load=false;
                                        });
                                      }else{
                                        setState(() {
                                          _load=false;
                                        });
                                      }
                                    }

                                  },
                                  icon: Icon(FontAwesomeIcons.angleDown,color: AppStyle.appColor,
                                    size: AppStyle.smallIconSize,),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Edit Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.userEdit,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Delete Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.trash,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,

                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 4,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Share Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.share,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,

                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Share Card Details",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.share,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,

                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            AppStyle.wSpace,
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget cardSearchWidget(){
    return ListView.builder(
        padding:AppStyle.commonPadding,
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: _cardSearchData.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: (){

              setState(() {
                //showSearchView=false;
                FocusScope.of(context).unfocus();
                _controllerSearch.clear();
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScanCardFrontBackHolderView(
                      view: "T",
                      name: _cardSearchData[index]["name"]??"",
                      surName: _cardSearchData[index]["surName"]??"",
                      profilePic2: _cardSearchData[index]["profilePic2"]??"",
                      freeField: _cardSearchData[index]["freeField"]??"",
                      email2: _cardSearchData[index]["email2"]??"",
                      mobileNo2: _cardSearchData[index]["mobileNo2"]??"",
                      fullName: _cardSearchData[index]["contactName"]??"",
                      companyName: _cardSearchData[index]["companyName"]??"",
                      jobTittle: _cardSearchData[index]["jobTitle"]??"",
                      officeContact: _cardSearchData[index]["workPhoneno"]??"",
                      email: _cardSearchData[index]["email"]??"",
                      address: _cardSearchData[index]["address"]??"",
                      phone: _cardSearchData[index]["mobileNo"]??"",
                      dob: _cardSearchData[index]["dob"]??"",
                      profilePic: _cardSearchData[index]["profilePic"],
                      id: _cardSearchData[index]["id"].toString()))).then((value) => _getUserProfileData(""));

            },
            child: Card(
              color: AppStyle.appShade.withOpacity(0.5),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardSearchData[index]["profilePic"]!=null?Container(
                        width: 120,
                        height: 80,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            color: AppStyle.appShade,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage(_cardSearchData[index]["profilePic"]),
                                fit: BoxFit.fill
                            )),
                      ):Container(
                        width: 120,
                        height: 80,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            color: AppStyle.appShade,
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                                image: AssetImage("assets/image/new_logo.png"),
                                fit: BoxFit.fill
                            )),
                      ),
                      //AppStyle.hSmallSpace,
                      SizedBox(
                        // width: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            DateFormat.yMMMMd().format(DateTime.parse(_cardSearchData[index]["created_at"])),
                            style: AppStyle.appSmallTextBlack,overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: AppStyle.commonPadding,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_cardSearchData[index]["contactName"]}",style: AppStyle.appSmallTextAppColor,),
                                    const SizedBox(height: 5,),
                                    Text("${_cardSearchData[index]["companyName"]??"---"}",
                                      style: AppStyle.appSmallTextBlack,maxLines: 1,overflow: TextOverflow.ellipsis,)
                                  ],
                                ),
                              ),
                            ),
                            //const Spacer(),

                          ],
                        ),
                        const Divider(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap:(){
                                if(_cardSearchData[index]["mobileNo"].toString().isNotEmpty && _cardSearchData[index]["mobileNo"]!=null){
                                  AppStyle.launchInBrowser(Uri.parse("tel://${_cardSearchData[index]["mobileNo"].replaceAll(' ', '')}"));
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => PlaceholderDialog(
                                      icon: Icon(
                                        FontAwesomeIcons.triangleExclamation,
                                        color: AppStyle.appColor,
                                        size: 50.0,
                                      ),
                                      title: 'Alert',
                                      message: 'Mobile Number Not Found! Please Update Mobile Number in Card Holder',
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: Text('Close',style: AppStyle.appSmallTextAppColor,),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                              },
                              child: CircleAvatar(
                                backgroundColor: AppStyle.appShade,
                                radius: 15,
                                child: Icon(FontAwesomeIcons.phoneFlip,color: AppStyle.appColor,
                                  size: AppStyle.smallIconSize,),
                              ),
                            ),
                            AppStyle.wSpace,
                            InkWell(
                              onTap:(){
                                if(_cardSearchData[index]["mobileNo"].toString().isNotEmpty && _cardSearchData[index]["mobileNo"]!=null){
                                  _validateNumber(_cardSearchData[index]["mobileNo"].toString());
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => PlaceholderDialog(
                                      icon: Icon(
                                        FontAwesomeIcons.triangleExclamation,
                                        color: AppStyle.appColor,
                                        size: 50.0,
                                      ),
                                      title: 'Alert',
                                      message: 'Mobile Number Not Found! Please Update Mobile Number in Card Holder',
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: Text('Close',style: AppStyle.appSmallTextAppColor,),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                              },
                              child: CircleAvatar(
                                backgroundColor: AppStyle.appShade,
                                radius: 15,
                                child: Icon(FontAwesomeIcons.whatsapp,color: AppStyle.appColor,
                                  size: AppStyle.smallIconSize,),
                              ),
                            ),
                            AppStyle.wSpace,
                            CircleAvatar(
                              backgroundColor: AppStyle.appShade,
                              radius: 15,
                              child: PopupMenuButton(
                                  padding: EdgeInsets.zero,
                                  shape: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppStyle.appShade,
                                      )
                                  ),
                                  onSelected: (value) async {

                                    if(value==1){
                                      setState(() {
                                        //showSearchView=false;
                                        FocusScope.of(context).unfocus();
                                        _controllerSearch.clear();
                                      });
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ScanCardFrontBackHolderView(
                                              view: "T",
                                              name: _cardSearchData[index]["name"]??"",
                                              surName: _cardSearchData[index]["surName"]??"",
                                              profilePic2: _cardSearchData[index]["profilePic2"]??"",
                                              freeField: _cardSearchData[index]["freeField"]??"",
                                              email2: _cardSearchData[index]["email2"]??"",
                                              mobileNo2: _cardSearchData[index]["mobileNo2"]??"",
                                              fullName: _cardSearchData[index]["contactName"]??"",
                                              companyName: _cardSearchData[index]["companyName"]??"",
                                              jobTittle: _cardSearchData[index]["jobTitle"]??"",
                                              officeContact: _cardSearchData[index]["workPhoneno"]??"",
                                              email: _cardSearchData[index]["email"]??"",
                                              address: _cardSearchData[index]["address"]??"",
                                              phone: _cardSearchData[index]["mobileNo"]??"",
                                              dob: _cardSearchData[index]["dob"]??"",
                                              profilePic: _cardSearchData[index]["profilePic"],
                                              id: _cardSearchData[index]["id"].toString()))).then((value) => _getUserProfileData(""));
                                    }
                                    else if(value==2){
                                      _showDialog(_cardSearchData[index]["id"].toString());
                                    }else if(value==4){
                                      setState(() {
                                        _load=true;
                                      });
                                      if(_cardSearchData[index]["profilePic"]!=null && _cardSearchData[index]["profilePic2"]!=null){
                                        final response = await get(Uri.parse(_cardSearchData[index]["profilePic"]));
                                        final directory = await getTemporaryDirectory();
                                        File file = await File('${directory.path}/${_cardSearchData[index]["mobileNo"]}_image.png')
                                            .writeAsBytes(response.bodyBytes);

                                        //back
                                        final response2 = await get(Uri.parse(_cardSearchData[index]["profilePic2"]));
                                        final directory2 = await getTemporaryDirectory();
                                        File file2 = await File('${directory2.path}/${_cardSearchData[index]["mobileNo"]}_image2.png')
                                            .writeAsBytes(response2.bodyBytes);


                                        final result = await Share.shareXFiles([XFile(file.path),XFile(file2.path)]);

                                        if (result.status == ShareResultStatus.success) {
                                          //debugPrint('Thank you for sharing the picture!');
                                          setState(() {
                                            _load=false;
                                          });
                                        }else{
                                          setState(() {
                                            _load=false;
                                          });
                                        }
                                      }else{
                                        if(_cardSearchData[index]["profilePic"]!=null){
                                          final response = await get(Uri.parse(_cardSearchData[index]["profilePic"]));
                                          final directory = await getTemporaryDirectory();
                                          File file = await File('${directory.path}/${_cardSearchData[index]["mobileNo"]}_image.png')
                                              .writeAsBytes(response.bodyBytes);
                                          final result = await Share.shareXFiles([XFile(file.path)]);

                                          if (result.status == ShareResultStatus.success) {
                                            //debugPrint('Thank you for sharing the picture!');
                                            setState(() {
                                              _load=false;
                                            });
                                          }else{
                                            setState(() {
                                              _load=false;
                                            });
                                          }
                                        }
                                        else{

                                          //back
                                          final response2 = await get(Uri.parse(_cardSearchData[index]["profilePic2"]));
                                          final directory2 = await getTemporaryDirectory();
                                          File file2 = await File('${directory2.path}/${_cardSearchData[index]["mobileNo"]}_image2.png')
                                              .writeAsBytes(response2.bodyBytes);

                                          final result = await Share.shareXFiles([XFile(file2.path)]);

                                          if (result.status == ShareResultStatus.success) {
                                            //debugPrint('Thank you for sharing the picture!');
                                            setState(() {
                                              _load=false;
                                            });
                                          }else{
                                            setState(() {
                                              _load=false;
                                            });
                                          }

                                        }
                                      }
                                    }
                                    else{
                                      setState(() {
                                        _load=true;
                                      });
                                      final response = await get(Uri.parse(_cardSearchData[index]["profilePic"]));
                                      final directory = await getTemporaryDirectory();
                                      File file = await File('${directory.path}/${_cardSearchData[index]["mobileNo"]}_image.png')
                                          .writeAsBytes(response.bodyBytes);

                                      final result = await Share.shareWithResult(/*[XFile(file.path)]*/
                                          "Hello,\n\nThanks for connecting Save Trees VC!\n\n"
                                              "Front Visiting Card: ${_cardSearchData[index]["profilePic"]??""}\n"
                                              "Back Visiting Card: ${_cardSearchData[index]["profilePic2"]??""}\n\n"
                                              "Date of Birth: ${_cardSearchData[index]["dob"]??""}\n"
                                              "Name: ${_cardSearchData[index]["contactName"]??""}\n"
                                              "Designation: ${_cardSearchData[index]["jobTitle"]??""}\n"
                                              "Company Name: ${_cardSearchData[index]["companyName"]??""}\n"
                                              "Email : ${_cardSearchData[index]["email"]??""}\n"
                                              "Email 2: ${_cardSearchData[index]["email2"]??""}\n"
                                              "Mobile No: ${_cardSearchData[index]["mobileNo"]??""}\n"
                                              "office Contact: ${_cardSearchData[index]["workPhoneno"]??""}\n"
                                              "office Contact 2: ${_cardSearchData[index]["mobileNo2"]??""}\n"
                                              "Address: ${_cardSearchData[index]["address"]??""}\n"
                                              "Free Field: ${_cardSearchData[index]["freeField"]??""}\n"
                                              "\n\n"
                                              "\n\nRegards"
                                              "\n\nSave Trees VC"
                                              "\n\nHave a nice day!");
                                      if (result.status == ShareResultStatus.success) {
                                        setState(() {
                                          _load=false;
                                        });
                                      }else{
                                        setState(() {
                                          _load=false;
                                        });
                                      }
                                    }

                                  },
                                  icon: Icon(FontAwesomeIcons.angleDown,color: AppStyle.appColor,
                                    size: AppStyle.smallIconSize,),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Edit Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.userPen,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Delete Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.trash,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 4,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Share Card",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.share,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,

                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Share Card Details",style: AppStyle.appSmallTextBlack.copyWith(fontSize: 11),),
                                          Icon(
                                            FontAwesomeIcons.share,
                                            color: AppStyle.appColor,
                                            size: 12,
                                          ),
                                          //AppStyle.wSpace,

                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            AppStyle.wSpace,
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _showDialog(String id) {
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Are you sure you want to delete?",
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
                                      _deleteCard(id);

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

  Widget customRadioButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          value = index;
          if(value==1){
            _getUserProfileData("ByFName");
          }else if(value==2){
            _getUserProfileData("ByLName");
          }else if(value==3){
            _getUserProfileData("ByCompany");
          }else{
            _getUserProfileData("ByDate");
          }
        });
      },
      child: Text(
        text,
        style: (value == index)?AppStyle.appSmallTextAppColor:AppStyle.appSmallTextGrey
      ),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
     // borderSide:BorderSide(color: (value == index) ? AppStyle.appColor : Colors.grey,width:1,),
     // highlightColor: (value == index)? AppStyle.appColor : Colors.grey,
    );
  }
}
