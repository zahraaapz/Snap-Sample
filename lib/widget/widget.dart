import 'package:flutter/material.dart';

import '../constant/dimens.dart';

class MyBackButton extends StatelessWidget {
  MyBackButton({
    super.key,
    required this.onPressed
  });
Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: Dimens.medium,
        left: Dimens.medium,
        
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 3),
              blurRadius:10,
            )
          ]),
        child: IconButton(onPressed: onPressed, icon: Icon(Icons.arrow_back)),));
  }
}