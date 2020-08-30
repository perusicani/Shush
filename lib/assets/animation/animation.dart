import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SpriteDemo extends StatefulWidget {
  final double data;

  SpriteDemo({this.data});

  @override
  _SpriteDemoState createState() => _SpriteDemoState();
}

class _SpriteDemoState extends State<SpriteDemo> {
  // double _width = 100;
  // double _height = 100;
  Timer timer;
  Random rand = Random();

  @override
  void initState() {
    /*
     * ovaj timer simulira yield iz bloca 
     * pa zato nece biti potreban ni set state, 
     * dovoljan je build sa novim dimenzijama
     * 
     * parametri s kojima se treba igrat:
     * - duration timera, odnosno koliko cesto se updatea <-- you stupid, update gre na yield fucker (alse jebe setState())
     * - duration animacije, odnosno kolik brzo ce se animirati u novi polozaj  <-- jako brzo
     * - curve parametar od animacije, stavis Curves. pa vidis sta sve ima i testiras
     * 
     * also, primeti (misliš, primijeti*) da mi podaci dolaze puno brze nego sta traje animacija,
     * time sam postigao da nije tliko (mmmhmmmmmm toliko*) jumpy animacija al sve se to da mijenjat i testirat kako ce izgledat
     * 
     * glhf you dumb cunt
     * 
     * Thanks lil bitch, you have been of zero help in total <3 -sad gamer girl
     * (also debilu mogal si komotno maknut materialpp i scaffold i sranja s obzirun da ovo gre va neki drugi screen)
     */

    // timer = Timer.periodic(
    //   Duration(milliseconds: 500),
    //   (timer) {
    //     // var valu = 100 + rand.nextInt(350).toDouble();
    //     var valu = 100 + widget.data ?? rand.nextInt(350).toDouble();
    //     update(valu, valu);
    //   },
    // );

    super.initState();
  }

  // void update(double height, double width) {
  //   setState(() {
  //     _height = height;
  //     _width = width;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.yellow[800].withOpacity(0.8),
                spreadRadius: 30,
                blurRadius: 20,
              ),
            ],
            shape: BoxShape.circle,
            color: Colors.yellow[800].withOpacity(0.0),
          ),
          // height: _height,
          // width: _width,
          height: widget.data * 1.5 + MediaQuery.of(context).size.height * 0.2,
          width: widget.data * 1.5 + MediaQuery.of(context).size.width * 0.2,
          child: Center(
            child: Text(
              "Šanko\nće\npobrat\nćepu",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
