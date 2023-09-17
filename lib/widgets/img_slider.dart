import 'package:flutter/material.dart';

final List<String> imgList = [
  'assets/banners/1.jpg',
  'assets/banners/2.jpg',
  'assets/banners/3.jpg',
  'assets/banners/4.jpg',
];

final List<Widget> imageSliders = imgList
    .map((e) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  e,
                  fit: BoxFit.cover,
                  width: 1000.0,
                  height: 1000.0,
                )
              ],
            ),
          ),
        ))
    .toList();
