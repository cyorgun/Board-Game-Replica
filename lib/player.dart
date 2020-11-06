import 'package:baboli_deal/card_types/custom_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Player {
  List<CustomCard> moneyCards = List();
  List<List<CustomCard>> bench = List();
  List<CustomCard> hand = List();
  int moveNumber = 3;
  List<CustomCard> graveyard = List();

  BuildContext context;

  void removeCard(int no) {
    hand.removeAt(no);
  }

  String totalMoney() {
    int totalPrice = 0;
    for (CustomCard cc in moneyCards) {
      totalPrice += int.parse(cc.price);
    }
    return totalPrice.toString();
  }

  void decreaseMoveNumber() {
    moveNumber--;
  }

  void refillMoveNumber() {
    moveNumber = 3;
  }

  List<CustomCard> returnHand() {
    return hand;
  }

  List<List<CustomCard>> returnBench() {
    return bench;
  }

  void removeFromBench(int i) {
    bench.removeAt(i);
  }

  void removeFromStackedBench(int i, int k) {
    bench[i].removeAt(k);
    if (bench[i].length == 0) {
      bench.removeAt(i);
    }
  }

  void removeFromMoneyCards(int i) {
    moneyCards.removeAt(i);
  }

  void removeFromHand(int i) {
    hand.removeAt(i);
  }

  List<CustomCard> returnMoneyCards() {
    return moneyCards;
  }

  void addCard(CustomCard card) {
    hand.add(card);
  }

  //from hand
  //should be renamed as playfromhand
  void addToBenchOrMoneyCards(int no) {
    int coloredSetNo = isThereThisColorInBench(hand[no]);
    if (hand[no].type == "money") {
      moneyCards.add(hand[no]);
      removeCard(no);
    } else if (hand[no].type == "action") {
      graveyard.add(hand[no]);
      removeCard(no);
    } else if (coloredSetNo != -1) {
      bench[coloredSetNo].add(hand[no]);
      removeCard(no);
    } else {
      List<CustomCard> tempList = [hand[no]];
      bench.add(tempList);
      removeCard(no);
    }
  }

  //
  void directlyAddCardToBench(CustomCard card) {
    int coloredSetNo = isThereThisColorInBench(card);
    if (card.type == "money") {
      moneyCards.add(card);
    } else if (card.type == "action") {
      graveyard.add(card);
    } else if (coloredSetNo != -1) {
      bench[coloredSetNo].add(card);
    } else {
      List<CustomCard> tempList = [card];
      bench.add(tempList);
    }
  }

  void directlyAddMultipleCardsToBench(List<CustomCard> cardList) {
    bench.add(cardList);
  }

  void directlyAddCardToMoneyCards(CustomCard card) {
    //stacke koyman gerekiyo mu check et + money bölümüne mi koyacaksın vs. bunun yerine üstteki fonksiyonda her şeyi handle edebilirsin.
    moneyCards.add(card);
  }

  List<CustomCard> getCardFromBench(int no) {
    return bench[no];
  }

  CustomCard getCardFromMoneyCards(int no) {
    return moneyCards[no];
  }

  int isThereThisColorInBench(CustomCard cc) {
    String color = cc.type == 'wild' ? cc.description : cc.color;
    for (int i = 0; i < bench.length; i++) {
      if (cc.type == "property" || cc.type == "wild") {
        if (bench[i][0].type == 'property') {
          if (color == bench[i][0].color) {
            return i;
          }
        } else if (bench[i][0].type == 'wild') {
          if (color == bench[i][0].description) {
            return i;
          }
        }
      }
    }
    return -1;
  }
}
