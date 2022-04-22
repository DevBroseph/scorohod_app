import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustom extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final TextInputType keyboardType;
  final bool needPhoneMask;
  final bool needCodeMask;
  final bool enabled;
  final bool greyColorWhenDisabled;
  final bool isCodeField;
  final bool isRequired;

  const TextFieldCustom({
    Key? key,
    required this.controller,
    required this.title,
    required this.keyboardType,
    required this.needPhoneMask,
    required this.needCodeMask,
    required this.enabled,
    this.greyColorWhenDisabled = true,
    this.isCodeField = false,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<TextFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              Text.rich(
                TextSpan(
                  text: widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    height: 1.2,
                    fontFamily: 'SFUI',
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    if (widget.isRequired)
                      const TextSpan(
                        text: "*",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          height: 1.2,
                          fontFamily: 'SFUI',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              if (!widget.enabled &&
                  widget.controller.text != '' &&
                  widget.needPhoneMask)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Colors.green[400],
                  ),
                ),
            ],
          ),
        ),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: !widget.enabled && widget.greyColorWhenDisabled
                ? null
                : Border.all(
                    width: 1,
                    color: Colors.black.withOpacity(0.15),
                    style: BorderStyle.solid,
                  ),
            color: !widget.enabled && widget.greyColorWhenDisabled
                ? const Color(0xFFEEEEEE)
                : Colors.transparent,
          ),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            onChanged: (text) {
              if (text.length == 4 && widget.isCodeField) {
                FocusScope.of(context).unfocus();
                setState(() {});
              }
            },
            enabled: widget.enabled,
            inputFormatters: widget.needPhoneMask
                ? [TextInputMask(mask: '\\+ 7 (999) 999-99-99', reverse: false)]
                : widget.needCodeMask
                    ? [
                        LengthLimitingTextInputFormatter(4),
                      ]
                    : null,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            style: TextStyle(
              fontSize: 15,
              color: !widget.enabled && widget.greyColorWhenDisabled
                  ? const Color(0xFF8F8F8F)
                  : Colors.black,
              height: 1.2,
              fontFamily: 'SFUI',
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }
}
