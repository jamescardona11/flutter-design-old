import 'package:flutter/material.dart';
import 'package:login_animated_app/constants.dart';
import 'package:login_animated_app/pages/sign_in_layout.dart';
import 'package:login_animated_app/pages/sign_up_layout.dart';
import 'package:login_animated_app/pages/splash_layout.dart';

class LoginPage extends StatelessWidget {
  //static const String pageRoute = 'login_layout_route_id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          SplashLayout(
            isShowInputCard: true,
          ),
          Positioned(
            bottom: 0,
            child: SignInLayout(),
          ),
          Positioned(
            bottom: 0,
            child: SignUpLayout(),
          ),
        ],
      ),
    );
  }
}