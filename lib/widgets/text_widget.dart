import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({Key? key,
    this.fontSize = 12,
    required this.title,
    this.color = Colors.white,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  final double fontSize;
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
