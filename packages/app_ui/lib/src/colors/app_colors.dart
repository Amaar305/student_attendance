import 'package:flutter/material.dart';

/// Defines the color palette for the App UI Kit.
abstract class AppColors {
  /// Black
  static const Color black = Color(0xFF000000);

  /// The background color.
  static const Color background = Color(0xFF181818);

  /// The background color 3.
  static const Color background3 = Color(0xFF1C1C1C);

  /// The button color.
  static const Color buttonColor = Color(0xFF171B2A);

  /// The background color 2.
  static const Color background2 = Color(0xFF1C1C1C);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// The light blue color.
  static const Color lightBlue = Color(0xFF77C9F1);

  /// static const Color lightBlue = Color(0xFF1DA1F2);
  static const Color lightBlueFilled = Color(0xffF7FBFD);

  /// The blue primary color and swatch.
  static const Color blue = Color(0xff259cd9);

  /// The deep blue color.
  static const Color deepBlue = Color(0xff259CD5);

  /// The border outline color.
  static const Color borderOutline = Color.fromARGB(45, 250, 250, 250);

  /// Light dark.
  static const Color lightDark = Color.fromARGB(164, 120, 119, 119);

  /// Dark.
  static const Color dark = Color.fromARGB(255, 58, 58, 58);

  /// Primary dark blue color.
  static const Color primaryDarkBlue = Color(0xff1c1e22);

  /// Grey.
  static const Color grey = Colors.grey;

  /// The bright grey color.
  static const Color brightGrey = Color.fromARGB(255, 224, 224, 224);

  /// The dark grey color.
  static const Color darkGrey = Color.fromARGB(255, 66, 66, 66);

  /// The emphasize grey color.
  static const Color emphasizeGrey = Color.fromARGB(255, 97, 97, 97);

  /// The emphasize dark grey color.
  static const Color emphasizeDarkGrey = Color.fromARGB(255, 40, 37, 37);

  /// Red material color.
  static const MaterialColor red = Colors.red;

  /// Green material color.
  static const MaterialColor green = Colors.green;

  /// The primary Instagram gradient pallete.
  static const primaryGradient = <Color>[
    Color(0xFF833AB4), // Purple
    Color(0xFFF77737), // Orange
    Color(0xFFE1306C), // Red-pink
    Color(0xFFC13584), // Red-purple
    Color(0xFF833AB4), // Duplicate of the first color
  ];

  /// The primary Telegram gradient chat background pallete.
  static const primaryBackgroundGradient = <Color>[
    Color.fromARGB(255, 119, 69, 121),
    Color.fromARGB(255, 141, 124, 189),
    Color.fromARGB(255, 50, 94, 170),
    Color.fromARGB(255, 111, 156, 189),
  ];

  /// The primary Telegram gradient chat message bubble pallete.
  static const primaryMessageBubbleGradient = <Color>[
    Color.fromARGB(255, 226, 128, 53),
    Color.fromARGB(255, 228, 96, 182),
    Color.fromARGB(255, 107, 73, 195),
    Color.fromARGB(255, 78, 173, 195),
  ];

  /// The primary Telegram gradient chat message bubble pallete.
  static const platinumBackgroundGradient = <Color>[
    Color.fromRGBO(232, 232, 232, 0.45),
    Color.fromRGBO(23, 27, 42, 0.1),
  ];

  /// The primary Telegram gradient chat message bubble pallete.
  static const masterBackgroundGradient = <Color>[
    Color.fromRGBO(74, 74, 73, 1),
    Color.fromRGBO(32, 32, 31, 1),
  ];

  /// The primary Telegram gradient chat message bubble pallete.
  static const virtualCardGradient = <Color>[
    Color(0xFF00359E),
    Color(0xFF155EEF),
  ];

  ///
  static const Color hinTextColor = Color(0xff88879C);

  ///
  static const Color cardContainerColor = Color.fromRGBO(238, 241, 248, 0.53);

  /// App primary colour 2
  static const Color primary2 = Colors.black;
  // static const Color primary2 = Color(0xff002a54);

  ///
  static const Color secondaryColor = Color(0xFFFBFCFF);

  ///
  static const Color orange = Colors.orange;
}
