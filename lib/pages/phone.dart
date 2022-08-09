import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/pages/code.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/widgets/custom_text_field.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(0.0),
              ),
            ),
            Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Image.asset('assets/logo.png',
                        width: 100, height: 100)),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Text(
                          'Чтобы совершать заказы, необходимо подтвердить номер телефона.',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 0),
                            child: TextFieldCustom(
                                controller: _phoneController,
                                title: '',
                                keyboardType: TextInputType.phone,
                                needPhoneMask: true,
                                needCodeMask: false,
                                enabled: true),
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 50, top: 25),
                        child: ScaleButton(
                          duration: const Duration(
                            milliseconds: 150,
                          ),
                          onTap: () {
                            if (_phoneController.text.length == 19) {
                              context
                                  .nextPage(
                                      CodePage(phone: _phoneController.text))
                                  .then((value) => Navigator.pop(context));
                            } else {
                              MyFlushbar.showFlushbar(context, 'Внимание',
                                  'Неверно введён номер телефона');
                            }
                          },
                          bound: 0.05,
                          child: Container(
                            width: 100,
                            decoration: const BoxDecoration(
                              borderRadius: radius,
                              color: red,
                            ),
                            height: 50,
                            child: Center(
                                child: Text(
                              'Далее',
                              style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(flex: 1, child: Container())
              ],
            ),
          ],
        ));
  }
}
