import 'package:buzzinga/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buzzinga/widgets/login_container.dart';
import 'package:buzzinga/widgets/register_container.dart';
import 'package:buzzinga/styles/button_style.dart';
import 'package:ant_design_flutter/ant_design_flutter.dart' as ant_design;

enum Status {login, register}

class Enter_Screen extends StatefulWidget {
  static const String id = 'Enter_Screen';

  @override
  State<Enter_Screen> createState() => _Enter_ScreenState();
}

class _Enter_ScreenState extends State<Enter_Screen> with SingleTickerProviderStateMixin {

  Status current = Status.login;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    print('Enter Screen');
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: secondaryColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Hero(
                      tag: 'logo',
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(controller),
                        child: Image(
                          image: AssetImage('images/logo.png'),
                          width: 200,
                          height: 200,
                        ),
                      ),
                    )
                ),
                Material(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  elevation: 5,
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        )
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: SegmentedButton(
                            showSelectedIcon: false,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)){
                                    return Color(0xFFF4CE14);
                                  }
                                  return Colors.black12;
                                },
                              ),
                            ),
                            segments: [
                              ButtonSegment<Status>(value: Status.login, label: Text('Login')),
                              ButtonSegment<Status>(value: Status.register, label: Text('Register')),
                            ],
                            selected:<Status>{current} ,
                            onSelectionChanged: (Set<Status> newSelection){
                              setState(() {
                                current = newSelection.first;
                              });
                            },
                          ),
                        ),
                        current == Status.login ? Login_Container() : Register_Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
