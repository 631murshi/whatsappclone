import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/screens/homescreen.dart';
import 'package:whatsappclone/screens/loginscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
    );
  }
}
class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  initState(){
    super.initState();
    Timer(Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                Welcome()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: HexColor("FFFFFF"),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            Icon(FontAwesomeIcons.whatsapp,size: 60,
              color:HexColor("4ECC5C") ,)
          ],
        )
    ),);
  }
}
class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50,left: 10,right: 10),
              child: Column(
                children: [
                  Text("Welcome to WhatsApp",style: TextStyle(
                      color:HexColor("008069"),fontSize: 26,
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text("Read our privacy policy.Tap 'Agree and Continue'"
                      "\n to accept the Terms and Condition",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,)
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=>loginscreen()));
              },
              child: Container(
                margin: EdgeInsets.only(left: 30.0,right: 30.0,bottom: 44.0),
                height: 46,
                width: 360,
                decoration: BoxDecoration(
                    color: HexColor("008069"),
                    border: Border.all(color: Colors.white, width: 1)),
                child: Center(
                  child: Text(
                    "AGREE AND CONTINUE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class Permenent extends StatefulWidget {
  const Permenent({Key? key}) : super(key: key);

  @override
  _PermenentState createState() => _PermenentState();
}

class _PermenentState extends State<Permenent>{
  late FirebaseAuth Firebase_auth;
  User? _user;
  bool isLoading= true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase_auth=FirebaseAuth.instance;
    _user= Firebase_auth.currentUser;
    isLoading =false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ):_user == null ? loginscreen():homescreen();
  }
}
