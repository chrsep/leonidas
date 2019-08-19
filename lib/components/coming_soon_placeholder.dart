import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/leonidas_theme.dart';

class ComingSoonPlaceholder extends StatelessWidget {
  const ComingSoonPlaceholder({Key key, this.sectionName}) : super(key: key);

  final String sectionName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Flex(
              children: [
                Text(
                  'UNDER DEVELOPMENT',
                  style: LeonidasTheme.overline,
                ),
                Text(sectionName + ' section', style: LeonidasTheme.h5,),
              ],
              direction: Axis.vertical,
            ),
          )
        ],
      ),
    );
  }
}
