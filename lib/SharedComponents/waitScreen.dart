import 'package:flutter/material.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';


class WaitScreen extends StatelessWidget {
  final String title;

  WaitScreen({@required this.title});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(appBar:GFAppBar(centerTitle: true,backgroundColor: Color(0xFF4527A0),title: Text(title)),body: GFLoader(
          type: GFLoaderType.circle)),
    );

  }
}