import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../scoped_models/main-model.dart';

class Header extends StatelessWidget with PreferredSizeWidget{
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model)
    {
      return AppBar(
        backgroundColor: const Color.fromRGBO(233, 233, 233, 1),
        toolbarHeight: 100,
        elevation: 0,
        actions: [model.authUser!= null?Center(
            child:
            Padding(
                padding: EdgeInsets.only(right: 40.0),
                child:
                TextButton(
                  onPressed: () {
                    // print(model.authUser);
                    Navigator.pushNamed(
                        context, "/profile");
                  },
                  child: Text(
                    AppLocalizations.of(context).myProfile,
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor
                    ),
                  ),
                )
            )
        )
        :SizedBox(height: 0,),
          model.authUser!= null?Center(
              child:
              Padding(
                  padding: EdgeInsets.only(right: 40.0),
                  child:
                  TextButton(
                    onPressed: () {
                      model.logout();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (Route<dynamic> route) => false);
                    },
                    child: Text(
                      AppLocalizations.of(context).logOut,
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor
                      ),
                    ),
                  )
              )
          )
        :SizedBox(height: 0,),
          Center(
              child:
              Padding(
                  padding: EdgeInsets.only(right: 40.0),
                  child:
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/how-to", (Route<dynamic> route) => false);
                    },
                    child: Text(
                      AppLocalizations.of(context).howTo,
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor
                      ),
                    ),
                  )
              )
          )
          ],
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context).courseRating, style: TextStyle(
                  color: Color.fromRGBO(146, 0, 11, 1),
                  fontSize: 30,
                  fontFamily: 'SpaceGrotesk'
              ),),),

          ],
        ),
      );
    });
    ;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}