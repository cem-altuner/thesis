import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black54,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final tileDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 7,
      offset: Offset(0, 7), // changes position of shadow
    ),
  ],
  borderRadius: BorderRadius.all(
      Radius.circular(20.0) //                 <--- border radius here
      ),
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFFFFFFFF),
  borderRadius: BorderRadius.circular(0.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kCompanyTileDecorationStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(0.0),
);

final kShoppingListsTileDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(0.0)),
);

final kAddShoppingListsTileDecorationStyle = BoxDecoration(
  color: Color(0xFFFFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(0.0)),
);

final kErrorTextStyle = TextStyle(
    fontFamily: 'OpenSans',
    color: Colors.black,
    decorationStyle: TextDecorationStyle.double);

final kFormTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans',
);

final kButtonTextStyle = TextStyle(
  color: Color(0xFF527DAA),
  letterSpacing: 1.5,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kTextTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans',
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

const pickerCityData = '''[[
"Istanbul",
"Izmir"
]]''';
