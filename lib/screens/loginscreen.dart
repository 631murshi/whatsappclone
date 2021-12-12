import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsappclone/screens/homescreen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class loginscreen extends StatefulWidget {
  const loginscreen({Key? key}) : super(key: key);

  @override
  _loginscreenState createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  String dropdownValue = 'india';
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth_auth = FirebaseAuth.instance;

  late String verificationId;
  bool Showloading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      Showloading = true;
    });

    try {
      final authCredential =
          await FirebaseAuth_auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        Showloading = false;
      });
      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => homescreen()));
      }
    } on FirebaseException catch (e) {
      setState(() {
        Showloading = false;
      });
      _scaffoldkey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  getMobileFormWidget(context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, right: 10, left: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Enter your phone number",
                        style:
                            TextStyle(fontSize: 18, color: HexColor("008069")),
                      ),
                      Expanded(child: SizedBox()),
                      Icon(Icons.more_vert)
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Whatsapp will need to verify your phone number"),
                  Text(
                    "what's my number?",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
            Container(
                child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: TextStyle(color: HexColor("008069")),
              underline: Container(
                height: 2,
                width: 200,
                color: HexColor("008069"),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['india', 'USA', 'china', 'australia']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //     width: 70,
                //     //margin: EdgeInsets.only(top: 10),
                //     //padding: EdgeInsets.only(left: 6),
                //     child: TextField(
                //         autocorrect: true,
                //         decoration: InputDecoration(
                //           prefixText: "+",
                //           contentPadding: EdgeInsets.only(top: 10),
                //           enabledBorder: UnderlineInputBorder(
                //             borderSide: BorderSide(color: HexColor("008069")),
                //           ),
                //           focusedBorder: UnderlineInputBorder(
                //             borderSide: BorderSide(color: HexColor("008069")),
                //           ),
                //         )
                //     )
                // ),
                Container(
                    width: 200,
                    margin: EdgeInsets.only(left: 10),
                    //padding: EdgeInsets.only(left: 6),
                    child: TextField(
                        controller: phoneController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: "phone number",
                          contentPadding: EdgeInsets.only(top: 10),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("008069")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("008069")),
                          ),
                        ))),
              ],
            ),
            Expanded(child: SizedBox()),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              height: 36,
              width: 100,
              decoration: BoxDecoration(color: HexColor("008069")),
              child: FlatButton(
                onPressed: () async {
                  setState(() {
                    Showloading = true;
                  });

                  await FirebaseAuth_auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (phoneAuthCredential) async {
                        setState(() {
                          Showloading = false;
                        });
                        //signInWithPhoneAuthCredential(phoneAuthCredential);
                      },
                      verificationFailed: (verificationFailed) async {
                        setState(() {
                          Showloading = false;
                        });
                        _scaffoldkey.currentState!.showSnackBar(SnackBar(
                            content:
                                Text(verificationFailed.message.toString())));
                      },
                      codeSent: (verificationId, resendingToken) async {
                        setState(() {
                          Showloading = false;
                          currentState =
                              MobileVerificationState.SHOW_OTP_FORM_STATE;
                          this.verificationId = verificationId;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {});
                },
                child: Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70, right: 14, left: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Verifying your number",
                              style: TextStyle(
                                  fontSize: 18, color: HexColor("008069")),
                            ),
                            Expanded(child: SizedBox()),
                            Icon(Icons.more_vert)
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Waiting to automatically an SMS sent to"),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " Wrong number?",
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    //padding: EdgeInsets.only(left: 6),
                    child: TextField(
                        controller: otpController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: " -  -  -   -  -  - ",
                          helperText: "Enter 6-digit code",
                          contentPadding: EdgeInsets.only(top: 10),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("008069")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor("008069")),
                          ),
                        )),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () async {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: otpController.text);
                      signInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    child: Text("VERIFY"),
                    color: HexColor("008069"),
                    textColor: Colors.white,
                  )
                ])));
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: Container(
          child: Showloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
