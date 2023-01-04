import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fyp/profile/themes.dart';
// import 'package:fyp/profile/utils/user_preferences.dart';

AppBar buildAppBar(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      ThemeSwitcher(
        builder: (context) => IconButton(
          icon: Icon(icon),
          onPressed: () {
            var lightTheme;
           // final theme = isDarkMode ? MyThemes.lightTheme : MyThemes.darkTheme;

            // final switcher = ThemeSwitcher.of(context)!;
            // switcher.changeTheme(theme: theme);
          },
        ),
      ),
    ],
  );
}

class MyThemes {
}
