import 'package:flutter/material.dart';
import 'package:snap_example/constant/dimens.dart';
import 'package:snap_example/constant/text_style.dart';

import '../widget/widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class CurrentwidgetStates {
  CurrentwidgetStates._();

  static const stateSelectOrgin = 0;
  static const stateSelectDestination = 0;
  static const stateSelectDriver = 0;
}

class _MyHomePageState extends State<MyHomePage> {
  List currentWidgetList = [CurrentwidgetStates.stateSelectOrgin];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            color: Colors.grey,
          ),
          currentWidget(),
          MyBackButton(
            onPressed: () {
if (currentWidgetList.length>1) {
  setState(() {
    currentWidgetList.removeLast();
  });
}





            },
          ),
          origin(),
        ],
      )),
    );
  }

  Widget currentWidget() {
    Widget widget = origin();

    switch (currentWidgetList.last) {
      case CurrentwidgetStates.stateSelectOrgin:
        widget = origin();
        break;

      case CurrentwidgetStates.stateSelectOrgin:
        widget = distination();
        break;

      case CurrentwidgetStates.stateSelectDriver:
        widget = driver();
        break;
    }
    return widget;
  }

  Positioned origin() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(Dimens.large),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentWidgetList.add(CurrentwidgetStates.stateSelectDestination);

                });
              },
              child: Text(
                'انتخاب مبدا',
                style: MyTextStyle.bottun,
              )),
        ));
  }

  Positioned distination() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(Dimens.large),
          child: ElevatedButton(
              onPressed: () {
                   setState(() {
                  currentWidgetList.add(CurrentwidgetStates.stateSelectDriver);

                });
              },
              child: Text(
                'انتخاب مقصد',
                style: MyTextStyle.bottun,
              )),
        ));
  }

  Positioned driver() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(Dimens.large),
          child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'درخواست راننده',
                style: MyTextStyle.bottun,
              )),
        ));
  }
}
