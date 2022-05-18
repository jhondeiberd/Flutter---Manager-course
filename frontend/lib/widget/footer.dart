import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Footer extends StatelessWidget{

 @override
 Widget build(BuildContext context){
  return  BottomAppBar(
   child:
      Container(
        child: Text (AppLocalizations.of(context).createdIn, textAlign: TextAlign.center, style: TextStyle(
            color: Color.fromRGBO(146, 0, 11, 1),
            fontSize: 20
        ), ),
        padding: const EdgeInsets.all(20),
      ),
    color: const Color.fromRGBO(233, 233, 233, 1),
  );
 }
}
