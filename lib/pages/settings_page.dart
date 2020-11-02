import 'package:Shush/assets/localization/dropdown_to_locale.dart';
import 'package:Shush/assets/localization/dropdown_to_short.dart';
import 'package:Shush/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  String dropDownValue = '-'; //rabit će presistat, tj sranje

  String selectedVoice = "cro";

  String lang;

  void checkSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gender = prefs.getBool('gender');
    });

    await prefs.setString('lang', lang);
    print("language in SP : " + prefs.getString('lang').toString());
    print("language in locale: " + context.locale.toString());
  }

  @override
  void initState() {
    checkSP();
    super.initState();
  }

  List<String> languages = [
    'Hrvatski',
    'English',
    'Français',
    'Deutsch',
    'Italiano',
    'Español'
  ];

  List<String> locales = [
    'hr_HR',
    'en_GB',
    'fr_FR',
    'de_DE',
    'it_IT',
    'es_ES'
  ];

  List<Widget> langaugesList(double height) {
    List<Widget> languagesList = List.generate(languages.length, (index) {
      return Container(
        height: height / languages.length,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 8,
              child: FittedBox(
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      languages[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // fontSize: MediaQuery.of(context).size.height * 0.03,
                        letterSpacing: 3.0,
                        color: Colors.yellow[800].withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    });
    return languagesList;
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    selectedIndex = locales.indexOf(context.locale.toString());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(165, 165, 165, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 63,
              child: Container(
                // color: Colors.red,
                child: Column(
                  children: [
                    Expanded(
                      flex: 20,
                      child: FittedBox(
                        child: Center(
                          child: Text(
                            'voicePackTitle'.tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // fontSize: MediaQuery.of(context).size.height * 0.03,
                              letterSpacing: 4.0,
                              color: Color.fromRGBO(236, 151, 20, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 24,
                      child: Column(
                        children: [
                          Expanded(
                            flex: gender ? 6 : 5,
                            child: FittedBox(
                              child: GestureDetector(
                                onTap: () async {
                                  print("male gender set");
                                  gender = true;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('gender', true);
                                  print("SP gender = " +
                                      prefs.getBool('gender').toString());
                                  setState(() {});
                                },
                                child: Center(
                                  child: Consumer<ThemeNotifier>(
                                          builder: (context, notifier, child) {
                                        return Text(
                                          'maleVoice'.tr().toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            // fontSize: MediaQuery.of(context).size.height * 0.03,
                                            letterSpacing: 3.0,
                                            color: gender
                                                ? Colors.yellow[800]
                                                    .withOpacity(0.8)
                                                : Color.fromRGBO(165, 165, 165, 1),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: gender ? 4 : 5,
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 24,
                      child: Column(
                        children: [
                          Expanded(
                            flex: !gender ? 6 : 5,
                            child: FittedBox(
                              child: GestureDetector(
                                onTap: () async {
                                  print("female gender set");
                                  gender = false;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('gender', false);
                                  print("SP gender = " +
                                      prefs.getBool('gender').toString());
                                  setState(() {});
                                },
                                child: Center(
                                  child: Consumer<ThemeNotifier>(
                                    builder: (context, notifier, child) {
                                      return Text(
                                        'femaleVoice'.tr().toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // fontSize:
                                          // MediaQuery.of(context).size.height * 0.03,
                                          fontFamily: 'OpenSansCondensed',
                                          letterSpacing: 3.0,
                                          color: !gender
                                                    ? Colors.yellow[800]
                                                        .withOpacity(0.8)
                                                    : Color.fromRGBO(165, 165, 165, 1),
                                        ),
                                      );
                                    }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: !gender? 4 : 5,
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: Container(),
            ),
            Expanded(
              flex: 15,
              child: FittedBox(
                child: Container(
                  // color: Colors.blue,
                  child: Center(
                    child: Text(
                      'language'.tr().toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 4.0,
                        color: Color.fromRGBO(236, 151, 20, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(),
            ),
            Expanded(
              flex: 100,
              child: LayoutBuilder(builder: (context, constraints) {
                print(constraints.maxHeight);
                return Container(
                  // color: Colors.amber,
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(languages.length, (index) {
                      return Container(
                        height: constraints.maxHeight / languages.length,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: selectedIndex == index ? 9 : 8,
                              child: GestureDetector(
                                onTap: () {
                                  selectedIndex = index;
                                  setState(() {
                                    EasyLocalization.of(context).locale =
                                        Locale(
                                            toShort[languages[index]]
                                                .toString(),
                                            toLocale[toShort[languages[index]]]
                                                .toString());
                                    dropDownValue = languages[index];
                                    //tu dodat one voices in specific languages i guess (tribat će razradit s obzirun kako je za sad postavno)
                                    lang = languages[index];
                                  });
                                  checkSP();
                                },
                                child: FittedBox(
                                  child: Container(
                                    // color: Colors.blue,
                                    child: Center(
                                      child: Consumer<ThemeNotifier>(
                                          builder: (context, notifier, child) {
                                        return Text(
                                          languages[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            // fontSize: MediaQuery.of(context).size.height * 0.03,
                                            letterSpacing: 3.0,
                                            color: selectedIndex == index
                                                ? Colors.yellow[800]
                                                    .withOpacity(0.8)
                                                : Color.fromRGBO(165, 165, 165, 1),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: selectedIndex == index ? 4 : 5,
                              child: Container(
                                  // color: Colors.green,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
            Expanded(
              flex: 15,
              child: Container(),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: Container(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Center(
    //           child: Text(
    //             'voicePackTitle'.tr().toString(),
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               fontSize: MediaQuery.of(context).size.height * 0.03,
    //               letterSpacing: 4.0,
    //               color: Colors.yellow[800].withOpacity(0.8),
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: 40.0),
    //         GestureDetector(
    //           onTap: () async {
    //             print("male gender set");
    //             gender = true;
    //             SharedPreferences prefs = await SharedPreferences.getInstance();
    //             prefs.setBool('gender', true);
    //             print("SP gender = " + prefs.getBool('gender').toString());
    //             setState(() {});
    //           },
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Center(
    //                 child: Text(
    //                   'maleVoice'.tr().toString(),
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     fontSize: MediaQuery.of(context).size.height * 0.03,
    //                     fontFamily: 'OpenSansCondensed',
    //                     letterSpacing: 4.0,
    //                     color: Colors.grey.withOpacity(0.9),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(width: 30.0),
    //               Icon(
    //                 Icons.check,
    //                 color: gender ?? true ? selectedColor : unselectedColor,
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(height: 20.0),
    //         GestureDetector(
    //           onTap: () async {
    //             print("female gender set");
    //             gender = false;
    //             SharedPreferences prefs = await SharedPreferences.getInstance();
    //             prefs.setBool('gender', false);
    //             print("SP gender = " + prefs.getBool('gender').toString());
    //             setState(() {});
    //           },
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Center(
    //                 child: Text(
    //                   'femaleVoice'.tr().toString(),
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     fontSize: MediaQuery.of(context).size.height * 0.03,
    //                     fontFamily: 'OpenSansCondensed',
    //                     letterSpacing: 4.0,
    //                     color: Colors.grey.withOpacity(0.9),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(width: 20.0),
    //               Icon(
    //                 Icons.check,
    //                 color: gender ?? true ? unselectedColor : selectedColor,
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(height: 60.0),
    //         Center(
    //           child: Text(
    //             'language'.tr().toString(),
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               fontSize: MediaQuery.of(context).size.height * 0.03,
    //               letterSpacing: 4.0,
    //               color: Colors.yellow[800].withOpacity(0.8),
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: 40.0),
    //         DropdownButton<String>(
    //           value: dropDownValue,
    //           //ako će ovako, onda triba mapirat se načine bilo kog jezika va en, hr, de, itd... da se slaže s locale i onda to mapirat va toLocale
    //           //mapirano jeste ali jebe
    //           // items: <String>['Language', '${'hr'.tr().toString()}', '${'en'.tr().toString()}', '${'fr'.tr().toString()}', '${'de'.tr().toString()}', '${'it'.tr().toString()}', '${'es'.tr().toString()}']
    //           //     .map<DropdownMenuItem<String>>((String value) {
    //           //   return DropdownMenuItem<String>(
    //           //     value: value,
    //           //     child: Text(value),
    //           //   );
    //           // }).toList(),
    //           items: <String>[
    //             '-',
    //             'Hrvatski',
    //             'English',
    //             'Français',
    //             'Deutsch',
    //             'Italiano',
    //             'Español'
    //           ].map<DropdownMenuItem<String>>((String value) {
    //             return DropdownMenuItem<String>(
    //               value: value,
    //               child: Padding(
    //                 padding: EdgeInsets.all(8.0),
    //                 child: Text(
    //                   value,
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     letterSpacing: 4.0,
    //                     color: Colors.grey.withOpacity(0.9),
    //                     fontSize: MediaQuery.of(context).size.height * 0.025,
    //                   ),
    //                 ),
    //               ),
    //             );
    //           }).toList(),
    //           onChanged: (String newValue) {
    //             checkSP();
    //             setState(() {
    //               if (newValue != '-')
    //                 // EasyLocalization.of(context).locale = Locale(toShort["$newValue"].toString(), toLocale[toShort["$newValue"].toString()].toString());
    //                 EasyLocalization.of(context).locale = Locale(
    //                     toShort["$newValue"].toString(),
    //                     toLocale[toShort["$newValue"]].toString());
    //               dropDownValue = newValue;
    //               //tu dodat one voices in specific languages i guess (tribat će razradit s obzirun kako je za sad postavno)
    //               lang = newValue;
    //               // print(lang);
    //             });
    //           },
    //         ),
    //         SizedBox(height: 60.0),
    //         IconButton(
    //           icon: Icon(Icons.clear),
    //           iconSize: MediaQuery.of(context).size.height * 0.05,
    //           color: Colors.yellow[800].withOpacity(0.7),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class LanugageItem extends StatefulWidget {
  final String language;
  LanugageItem({this.language});
  @override
  _LanugageItemState createState() => _LanugageItemState();
}

class _LanugageItemState extends State<LanugageItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 8,
          child: FittedBox(
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Text(
                  widget.language,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontSize: MediaQuery.of(context).size.height * 0.03,
                    letterSpacing: 3.0,
                    color: Colors.yellow[800].withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
