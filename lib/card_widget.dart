import 'package:baboli_deal/constants.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CardWidget extends StatelessWidget {
  final String name, color, price, type, description, color2;
  final int playerNo;
  final Function onTap;
  final int wildCardPosition = 1;
  CardWidget(this.name, this.color, this.price, this.type, this.description,
      this.color2, this.playerNo, this.onTap);

  List<Text> createPropertyRents(String mColor) {
    List<Text> temp = new List();
    for (int i = 1; i < kRents[mColor].length + 1; i++) {
      if (mColor == "black") {
        temp.add(Text(
          kRents[mColor][i].toString(),
          style: kTextStyle.copyWith(color: Colors.white),
        ));
      } else {
        temp.add(Text(
          kRents[mColor][i].toString(),
          style: kTextStyle,
        ));
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'property':
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: RotatedBox(
              quarterTurns: playerNo == 2 ? 2 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                color: kColors[color],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style:
                              kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          price,
                          style: kTextStyle.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: createPropertyRents(color),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      case 'money':
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: RotatedBox(
              quarterTurns: playerNo == 2 ? 2 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                color: kColors[color],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style:
                              kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          price,
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      case 'action':
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: RotatedBox(
              quarterTurns: playerNo == 2 ? 2 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                color: kColors[color],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 5,
                          child: AutoSizeText(
                            name,
                            maxLines: 2,
                            style: kTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: AutoSizeText(
                            price,
                            maxLines: 1,
                            style: kTextStyle,
                          ),
                        ),
                      ],
                    ),
                    AutoSizeText(
                      description,
                      maxLines: 7,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      case 'joker':
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: RotatedBox(
              quarterTurns: playerNo == 2 ? 2 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                color: Colors.pinkAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      name,
                      style: kTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case 'wild':
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: RotatedBox(
              quarterTurns: description != color2 ? 0 : 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: kColors[color],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: kTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            price,
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(children: [
                        Expanded(
                          child: Container(
                            color: kColors[color],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: createPropertyRents(color),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: kColors[color2],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: createPropertyRents(color2),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      color: kColors[color2],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RotatedBox(
                            quarterTurns: 2,
                            child: Text(
                              price,
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 2,
                            child: Text(
                              name,
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case 'house':
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: RotatedBox(
              quarterTurns: playerNo == 2 ? 2 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                color: kColors[color],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style:
                              kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          price,
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox()
                  ],
                ),
              ),
            ),
          ),
        );
      case 'hotel':
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: RotatedBox(
              quarterTurns: playerNo == 2 ? 2 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                color: kColors[color],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style:
                              kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          price,
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox()
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              color: Colors.black,
            ),
          ),
        );
    }
  }
}
