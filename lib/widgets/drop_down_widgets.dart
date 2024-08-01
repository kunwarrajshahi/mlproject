import 'package:dmi/utils/app_constant.dart';
import 'package:flutter/material.dart';


class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final EdgeInsets contentPadding;

  DropDownFormField(
      {Key? key, FormFieldSetter<dynamic>? onSaved,
        FormFieldValidator<dynamic>? validator,
        bool autovalidates = false,
        this.titleText = 'Title',
        this.hintText = 'Select one option',
        this.required = false,
        this.errorText = 'Please select one option',
        this.value,
        required this.dataSource,
        required this.textField,
        required this.valueField,
        required this.onChanged,
        this.filled = true,
        this.contentPadding = const EdgeInsets.fromLTRB(08, 05, 05, 02)})
      : super(key: key,
    onSaved: onSaved,
    validator: validator,
    //autovalidateMode: autovalidates,
    initialValue: value == '' ? null : value,
    builder: (FormFieldState<dynamic> state) {
      return InputDecorator(
        decoration: InputDecoration(
          fillColor: AppStyle.appShade.withOpacity(0.5),
          contentPadding: contentPadding,
          labelText: titleText,
          filled: filled,
          labelStyle: AppStyle.appSmallTextBlack,
          border: OutlineInputBorder(
              borderSide:  BorderSide(
                  color: AppStyle.appColor,
                  width: 0.5
              ),
              borderRadius: BorderRadius.circular(5.0)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            underline: Container(color: Colors.transparent),
            style: AppStyle.appSmallTextBlack,
            isExpanded: true,
            hint: Text(
              hintText,
              style: AppStyle.appSmallTextBlack,
            ),
            value: value == '' ? null : value.toString(),
            onChanged: (dynamic newValue) {
              state.didChange(newValue);
              onChanged(newValue);
            },
            items: dataSource.map((item) {
              return DropdownMenuItem<dynamic>(
                value: "${item[valueField]}",
                child: Text("${item[textField]}",
                  overflow: TextOverflow.ellipsis,style: AppStyle.appSmallTextBlack,),
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}