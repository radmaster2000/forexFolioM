import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
const darkBackgroundColor = Color(0xff0C090A);

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: darkBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.2),
                offset: const Offset(1, 0)),
            BoxShadow(
                color: Colors.grey.withOpacity(.2),
                offset: const Offset(0, 1)),
            BoxShadow(
                color: Colors.grey.withOpacity(.2),
                offset: const Offset(-1, 0)),
            BoxShadow(
                color: Colors.grey.withOpacity(.2),
                offset: const Offset(0, -1)),
          ]),
      child: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white70,
        size: 18,
      ),
    );
  }
}
class ButtonWidget extends StatelessWidget {
  final String text;
  final List<Color> backColor;

  final List<Color> textColor;
  final GestureTapCallback onPressed;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.backColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Shader textGradient = LinearGradient(
      colors: <Color>[textColor[0], textColor[1]],
    ).createShader(
      const Rect.fromLTWH(
        0.0,
        0.0,
        200.0,
        70.0,
      ),
    );
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.07,
      width: size.width * 0.9,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              stops: const [0.4, 2],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: backColor,
            ),
          ),
          child: Align(
            child: Text(
              text,
              style: TextStyle(
                foreground: Paint()..shader = textGradient,
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }
}