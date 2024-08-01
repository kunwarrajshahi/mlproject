import 'package:flutter/material.dart';

import '../utils/app_constant.dart';

class PlaceholderDialog extends StatelessWidget {
  const PlaceholderDialog({
    this.icon,
    this.title,
    this.message,
    this.actions = const [],
    Key? key,
  }) : super(key: key);

  final Widget? icon;
  final String? title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      icon: icon,
      title: title == null
          ? null
          : Text(
        title!,
        textAlign: TextAlign.center,
      ),
      titleTextStyle: AppStyle.appTittleTextBlack,
      content: message == null
          ? null
          : Text(
        message!,
        textAlign: TextAlign.center,
      ),
      contentTextStyle: AppStyle.appSmallTextBlack,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowButtonSpacing: 8.0,
      actions: actions,
    );
  }
}