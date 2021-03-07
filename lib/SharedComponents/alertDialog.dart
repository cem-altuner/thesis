import 'package:thesis/keys/myKeys.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';

class Alert {
  static void showCatalog() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: NoomiKeys.navKey.currentState.overlay.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          'Please create at least 1 shopping list.',
                          style: kTextTextStyle,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 220.0,
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        onPressed: () {
                          NoomiKeys.navKey.currentState.pop();
                        },
                        child: Text(
                          "Okay.",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showLogin(String message) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: NoomiKeys.navKey.currentState.overlay.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          message,
                          style: kTextTextStyle,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 220.0,
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        onPressed: () {
                          NoomiKeys.navKey.currentState.pop();
                        },
                        child: Text(
                          "Okay.",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showRegister() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: NoomiKeys.navKey.currentState.overlay.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          'We sent an activision e-mail.\nPlease confirm it.',
                          style: kTextTextStyle,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 220.0,
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        onPressed: () {
                          NoomiKeys.navKey.currentState.pop();
                          NoomiKeys.navKey.currentState.pop();
                        },
                        child: Text(
                          "Okay.",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showConnectionAlert() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: NoomiKeys.navKey.currentState.overlay.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          'Connection Problem\n',
                          style: kTextTextStyle,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 220.0,
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        onPressed: () {
                          NoomiKeys.navKey.currentState.pop();
                        },
                        child: Text(
                          "Okay",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showOfflineAlert() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: NoomiKeys.navKey.currentState.overlay.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          'You have an internet problem\n',
                          style: kTextTextStyle,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 220.0,
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        onPressed: () {
                          NoomiKeys.navKey.currentState.pop();
                        },
                        child: Text(
                          "Okay.",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
