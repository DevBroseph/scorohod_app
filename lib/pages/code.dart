import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/pages/account.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';

class CodePage extends StatefulWidget {
  const CodePage({Key? key, required this.phone}) : super(key: key);

  final String phone;

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationCode = '';
  int countTimer = 60;
  Timer _timer = Timer(Duration(), () {});

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: shadow),
  );

  final focusedPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      // border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      boxShadow: shadow,
      color: Colors.grey[100],
      borderRadius: radius,
    ),
  );

  final submittedPinTheme = const PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Color.fromRGBO(234, 239, 243, 1),
    ),
  );

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _setTimer();
    super.initState();
  }

  void _setTimer() {
    _checkPhone();
    setState(() {
      countTimer = 60;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countTimer != 0) {
        setState(() {
          countTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _checkPhone() async {
    await auth.verifyPhoneNumber(
      timeout: Duration(seconds: 60),
      phoneNumber: widget.phone
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('-', ' '),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // String smsCode = 'xxxx';
        setState(() {
          verificationCode = verificationId;
        });

        // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: smsCode);
        // print(smsCode);
        // Sign the user in (or link) with the credential
        // await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DataProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Image.asset('assets/logo.png', height: 100, width: 100)),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        Text(
                          'СМС отправлено на номер:',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.phone,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    )),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  showCursor: false,
                  onCompleted: (pin) => print(pin),
                  onChanged: (text) async {
                    if (text.length == 6) {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationCode, smsCode: text);
                      // Sign the user in (or link) with the credential
                      var result = await auth.signInWithCredential(credential);
                      if (result.user != null) {
                        MyFlushbar.showFlushbar(
                            context, 'Успешно.', 'Номер подтвержден');
                        Timer(Duration(seconds: 3), () {
                          user.setUserPhone(widget.phone);
                          Navigator.pop(context);
                        });
                      } else {
                        MyFlushbar.showFlushbar(
                            context, 'Ошибка.', 'Код неверный.');
                      }
                    }
                  },
                ),
                SizedBox(height: 15),
                if (countTimer != 0)
                  Text(
                    'Повторить отправку через: $countTimer',
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.w600),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      _setTimer();
                    },
                    child: const Text(
                      'Повторить отправку.',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
