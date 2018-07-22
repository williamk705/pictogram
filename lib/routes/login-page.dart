import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/picture-gallery.dart';
import '../helper/alert-modal.dart';

class LoginPage extends StatefulWidget {

  LoginPage();

  @override
  LoginPageView createState() => new LoginPageView();
}

class LoginPageView extends State<LoginPage> {

  /// Class variables which includes FireBase, controllers for forms, and
  /// a google sign in object
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    _persistSignIn();
  }

  /// Persist a login when the user opens the flutter application,
  /// checks if a user is already signed in and routes them to the
  /// gallery page if they are.
  Future _persistSignIn() async {
    var user = await _auth.currentUser();
    if(user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => new PictureGallery(_auth, user))
      );
    }else {
      await _googleSignIn.disconnect();
    }
  }

  /// Logs in a user through Google authentication and uses those Google credentials
  /// for with firebase to persist logins.
  Future _handleGoogleLogin() async {
    try {
      final account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final FirebaseUser user = await _auth.signInWithGoogle(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
      );
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => new PictureGallery(_auth, currentUser))
      );
    } catch (error) {
      Popups.alert(
        context,
        'Error',
        'Incorrect username or password'
      );
    }
  }

  /// Logs in a user with email and password
  Future _handleLogin(String e, String p) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(email: e, password: p);
      await _googleSignIn.disconnect();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new PictureGallery(_auth, user))
      );
    } catch (error) {
      Popups.alert(
          context,
          'Error',
          'Incorrect username or password'
      );
    }
  }

  /// the main widget for the login pages body
  /// this widget includes forms and buttons for login
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
                        controller: _usernameController,
                        decoration: new InputDecoration(
                            labelText: "Email", fillColor: Colors.white
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      new TextFormField(
                        controller: _passwordController,
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
                        onPressed: () {
                          _handleLogin(_usernameController.text.toString(), _passwordController.text.toString());
                        },
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
                          _handleGoogleLogin();
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