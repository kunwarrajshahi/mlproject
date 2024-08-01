import 'package:dmi/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailsView extends StatefulWidget {
  final String imagePath,name,desi,description,section;

  const DetailsView({Key? key, required this.imagePath,
    required this.name, required this.desi, required this.description, required this.section}) : super(key: key);

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
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
          title: Text(widget.section,style: AppStyle.appBarTextBlack,),
        ),
        body: Padding(
          padding: AppStyle.commonPadding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name, style: AppStyle.appTittleTextAppColor),
                        const SizedBox(height: 5,),
                        Text(widget.desi, style: AppStyle.appSmallTextGrey),
                      ],
                    ),
                  ),
                  Hero(
                    tag: widget.imagePath,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: AppStyle.appShade,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          image:widget.section!="Preamble"?DecorationImage(
                              image: NetworkImage(widget.imagePath),
                              fit: BoxFit.fill
                          ): DecorationImage(
                              image: AssetImage(widget.imagePath),
                              fit: BoxFit.fill
                          )),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Flexible(child: ListView(
                children: [Text(widget.description,style: AppStyle.appSmallTextBlack,
                textAlign: TextAlign.justify,)],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
