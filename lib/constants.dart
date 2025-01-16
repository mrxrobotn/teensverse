import 'package:flutter/material.dart';

const Color chartColor1 = Color(0xFF28ACF2);
const Color chartColor2 = Color(0xFFFE0000);
const Color backgroundColorLight = Color(0xFFF2F6FF);
const Color backgroundColorDark = Color(0xFF25254B);
const Color shadowColorLight = Color(0xFF4A5367);
const Color shadowColorDark = Colors.black;
const Color cardColor = Colors.green;
const Color textField = Color(0xFFD9F6FA);

List<String> roles = ['Admin', 'Staff', 'Educator', 'Student', 'Parent'];

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

const String htmlFirstContent = '''
      <html lang="en-EN">
        <head>
          <style>
            body {
              font-family: Arial, sans-serif;
              line-height: 1.6;
              color: #333;
            }
            a {
              color: #007bff;
              text-decoration: none;
            }
          </style>
        </head>
        <body>
          <p>Hi,</p>
          <p>Thank you for registering with Teens Verse! We're excited to have you participate in our internal test.</p>
          <p>To begin your Teens Verse experience, please download our platform (Windows only) using the link below:</p>
          <p><a href="https://drive.google.com/drive/folders/17BOnaT1aEdXKT8I8EPEOGdJ3DnQLs6ss" download>Download Teens Verse</a></p>
          <p>If you have any questions or need assistance, feel free to contact us at production@dall4all.org.</p>
          <p>Best regards,<br/>Teens Verse Team</p>
        </body>
      </html>
    ''';