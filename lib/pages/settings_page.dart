import 'package:Shush/assets/localization/dropdown_to_locale.dart';
import 'package:Shush/assets/localization/dropdown_to_short.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool gender;
  Color unselectedColor = Colors.grey.withOpacity(0.4);
  Color selectedColor = Colors.yellow[800].withOpacity(0.6);

  String dropDownValue = '-'; 

  String lang;

  void checkSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gender = prefs.getBool('gender');
    });
    lang = prefs.getString('lang');
  }

  @override
  void initState() {
    checkSP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'voicePackTitle'.tr().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  letterSpacing: 4.0,
                  color: Colors.yellow[800].withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            GestureDetector(
              onTap: () async {
                print("male gender set");
                gender = true;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('gender', true);
                print("SP gender = " + prefs.getBool('gender').toString());
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'maleVoice'.tr().toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 4.0,
                        color: Colors.grey.withOpacity(0.9),
                      ),
                    ),
                  ),
                  SizedBox(width: 30.0),
                  Icon(
                    Icons.check,
                    color: gender ?? true ? selectedColor : unselectedColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                print("female gender set");
                gender = false;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('gender', false);
                print("SP gender = " + prefs.getBool('gender').toString());
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'femaleVoice'.tr().toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 4.0,
                        color: Colors.grey.withOpacity(0.9),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Icon(
                    Icons.check,
                    color: gender ?? true ? unselectedColor : selectedColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 60.0),
            Center(
              child: Text(
                'language'.tr().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  letterSpacing: 4.0,
                  color: Colors.yellow[800].withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            DropdownButton<String>(
              value: lang ?? 'English',
              items: <String>[
                'Hrvatski',
                'English',
                'Français',
                'Deutsch',
                'Italiano',
                'Español'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 4.0,
                        color: Colors.grey.withOpacity(0.9),
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String newValue) async {
                setState(() {
                  EasyLocalization.of(context).locale = Locale(
                        toShort["$newValue"].toString(),
                        toLocale[toShort["$newValue"]].toString());
                  lang = newValue;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('lang', newValue);
              },
            ),
            SizedBox(height: 60.0),
            IconButton(
              icon: Icon(Icons.clear),
              iconSize: MediaQuery.of(context).size.height * 0.05,
              color: Colors.yellow[800].withOpacity(0.7),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
