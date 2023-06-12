import 'package:flutter/material.dart';
import 'package:sutt_task_final/classes/hex_color.dart';
import 'package:sutt_task_final/classes/fadeanimation.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:sutt_task_final/services/secure_storage.dart';
import 'package:sutt_task_final/services/userprovider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final state = await UserSecureStorage.getLoggedIn();
    String route = state == 1.toString() ? '/home' : '/login';
    print(state);
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        context.go(route);
      }
    });
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              HexColor("#4b4293").withOpacity(0.8),
              HexColor("#4b4293"),
              HexColor("#08418e"),
              HexColor("#08418e")
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
            image: const AssetImage('lib/assets/background.jpg'),
          ),
        ),
        child: Center(
          child: FadeAnimation(
              delay: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("lib/assets/icon.png",
                    height: 250,
                    width: 250,
                  ),
                  Text('Welcome',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}


