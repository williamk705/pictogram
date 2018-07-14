import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import '../routes/picture-gallery.dart';

class LoginPage extends StatefulWidget {

  LoginPage();

  @override
  LoginPageView createState() => new LoginPageView();
}

class LoginPageView extends State<LoginPage> {

  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if(account != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => new PictureGallery(_googleSignIn, account))
        );
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<Null> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Widget _buildBody() {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        new Theme(
          data: new ThemeData(

          ),
          isMaterialAppTheme: true,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Form(
                  autovalidate: true,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new TextFormField(
                        decoration: new InputDecoration(
                            labelText: "Email", fillColor: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Password",
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                      ),
                      new MaterialButton(
                        height: 40.0,
                        minWidth: 350.0,
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('LOGIN'),
                        onPressed: () {},
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      new MaterialButton(
                        height: 40.0,
                        minWidth: 350.0,
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('GOOGLE SIGN IN'),
                        onPressed: () {
                          _handleSignIn();
                        },
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 15.0)
                      ),
                      new Text(
                          'No account yet? Create One',
                        style: new TextStyle(color: Colors.blue)
                      )
                    ],
                  )
                )
              )
            ]
          )
        )
      ])
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

}