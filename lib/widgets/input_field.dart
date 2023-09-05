import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Palette.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
            Text(title,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontStyle: FontStyle.italic)
              ),
          Container(
            margin: EdgeInsets.only(top:8),
            height: 42,
            decoration: BoxDecoration(
              /*border: Border.all(
                color: Colors.grey,
                width: 0,
              ),*/
              //borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget ==null?false:true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                    controller: controller,
                    style: titleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      //hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.background,
                          width: 2,
                        ),
                      ),
                    ),

                  ),
                ),
                widget == null?Container():Container(child:widget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

