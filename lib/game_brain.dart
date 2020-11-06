import 'package:audioplayers/audio_cache.dart';
import 'package:baboli_deal/card_types/action_card.dart';
import 'package:baboli_deal/card_types/double_property_card.dart';
import 'package:baboli_deal/card_types/house_or_hotel_card.dart';
import 'package:baboli_deal/card_types/joker_card.dart';
import 'package:baboli_deal/card_types/property_card.dart';
import 'package:baboli_deal/card_types/money_card.dart';

import 'package:baboli_deal/constants.dart';
import 'package:baboli_deal/player.dart';

import 'card_types/custom_card.dart';

import 'dart:math';

import 'package:custom_dialog/custom_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GameBrain {
  Player player1 = new Player();
  Player player2 = new Player();
  List<CustomCard> deck = List();
  int turn = 1;
  String activeCard = "";

  int swapState = 0; // 0:nothing, 1:kendi kartını verdin
  bool cardDisposition = false;

  BuildContext context;

  int rentToBeTaken;
  int rentState = 0; // 0:nothing, 1:hangi stackten kira isteyeceğini seçtin

  final VoidCallback onRejectDialogAppear;

  GameBrain(this.onRejectDialogAppear) {
    createDeck();

    int i = 0;
    while (i < 5) {
      player1.addCard(pullCard());
      player2.addCard(pullCard());
      i++;
    }
  }

  List<List<CustomCard>> returnBench(int playerNo) {
    List<List<CustomCard>> cardList = new List();
    if (playerNo == 1) {
      cardList = player1.returnBench();
    } else {
      cardList = player2.returnBench();
    }
    return cardList;
  }

  List<CustomCard> returnMoneyCards(int playerNo) {
    List<CustomCard> cardList = new List();
    if (playerNo == 1) {
      cardList = player1.returnMoneyCards();
    } else {
      cardList = player2.returnMoneyCards();
    }
    return cardList;
  }

  List<CustomCard> returnHand(int playerNo) {
    List<CustomCard> cardList = new List();
    if (playerNo == 1) {
      cardList = player1.returnHand();
    } else {
      cardList = player2.returnHand();
    }
    return cardList;
  }

  bool modifyHand(int player, int no) {
    bool ifWon = false;
    if (player == 1) {
      player1.addToBenchOrMoneyCards(no);
      ifWon = checkIfWon(player1, player);
    } else {
      player2.addToBenchOrMoneyCards(no);
      ifWon = checkIfWon(player2, player);
    }
    return ifWon;
  }

  bool checkIfWon(Player player, int playerNo) {
    int totalSets = 0;
    List<List<CustomCard>> list = player.returnBench();
    for (int i = 0; i < list.length; i++) {
      String color = list[i][0].color;
      int requiredPropertyNumber = kRents[color].length;
      if (list[i].length == requiredPropertyNumber) {
        totalSets++;
      }
    }
    if (totalSets >= 3) {
      AudioCache().play("won.mp3");
      wonDialog(playerNo);
      return true;
    } else {
      return false;
    }
  }

  void wonDialog(int playerNo) {
    showDialog(
      context: context,
      builder: (context) => RotatedBox(
        quarterTurns: playerNo == 1 ? 0 : 2,
        child: CustomDialog(
          content: Text(
            'You won!',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20.0,
                color: Colors.black87),
          ),
          title: Text(
            'Game Over',
            style: TextStyle(color: Colors.black87),
          ),
          firstColor: Color(0xFF3CCF57),
          secondColor: Colors.white,
          headerIcon: Icon(
            Icons.monetization_on,
            size: 120.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void createDeck() {
    //name, color, price, type, description
    for (int i = 0; i < kActionCards.length; i++) {
      deck.add(new ActionCard(kActionCards[i][0], kActionCards[i][1],
          kActionCards[i][2], "action", kActionCards[i][3], "", () {}));
    }
    for (int i = 0; i < kDoublePropertyCards.length; i++) {
      deck.add(new DoublePropertyCard(
          kDoublePropertyCards[i][0],
          kDoublePropertyCards[i][1],
          kDoublePropertyCards[i][3],
          "wild",
          kDoublePropertyCards[i][1],
          kDoublePropertyCards[i][2]));
    }
    for (int i = 0; i < kMoneyCards.length; i++) {
      deck.add(new MoneyCard(kMoneyCards[i][0], kMoneyCards[i][1],
          kMoneyCards[i][2], "money", "", ""));
    }
    for (int i = 0; i < kPropertyCards.length; i++) {
      deck.add(new PropertyCard(kPropertyCards[i][0], kPropertyCards[i][1],
          kPropertyCards[i][2], "property", "", ""));
    }
    for (int i = 0; i < kHouseCards.length; i++) {
      deck.add(new HouseOrHotelCard(kHouseCards[i][0], kHouseCards[i][1],
          kHouseCards[i][2], "house", "", ""));
    }
    for (int i = 0; i < kHotelCards.length; i++) {
      deck.add(new HouseOrHotelCard(kHotelCards[i][0], kHotelCards[i][1],
          kHotelCards[i][2], "hotel", "", ""));
    }
    for (int i = 0; i < kJokerCards.length; i++) {
      deck.add(new JokerCard(kJokerCards[i][0], kJokerCards[i][1],
          kJokerCards[i][2], "joker", "", ""));
    }
  }

  CustomCard pullCard() {
    // TODO : graveyardda da yoksa napıcaz?
    List<CustomCard> emptyList = new List();
    if (deck.length == 0) {
      deck = player1.graveyard + player2.graveyard;
      player1.graveyard = emptyList;
      player2.graveyard = emptyList;
    }

    var rng = new Random();
    int chosenNumber = rng.nextInt(deck.length);
    CustomCard chosenCard = deck[chosenNumber];
    deck.removeAt(chosenNumber);

    return chosenCard;
  }

  void finishTurn(int player) {
    final audioPlayer = AudioCache();
    if (activeCard != "") {
      return;
    }
    if (turn == 1 && player == 1) {
      //7 karttan fazla var mı check et
      if (player1.hand.length > 7) {
        cardDisposition = true;
        return;
      }
      //
      audioPlayer.play("end_turn.mp3");
      turn = 2;
      player2.refillMoveNumber();
      if (player2.hand.length != 0) {
        player1.addCard(pullCard());
        player1.addCard(pullCard());
      } else {
        player1.addCard(pullCard());
        player1.addCard(pullCard());
        player1.addCard(pullCard());
        player1.addCard(pullCard());
        player1.addCard(pullCard());
      }
    } else if (turn == 2 && player == 2) {
      //7 karttan fazla var mı check et
      if (player2.hand.length > 7) {
        cardDisposition = true;
        return;
      }
      //
      audioPlayer.play("end_turn.mp3");
      turn = 1;
      player1.refillMoveNumber();
      if (player1.hand.length != 0) {
        player2.addCard(pullCard());
        player2.addCard(pullCard());
      } else {
        player2.addCard(pullCard());
        player2.addCard(pullCard());
        player2.addCard(pullCard());
        player2.addCard(pullCard());
        player2.addCard(pullCard());
      }
    }
  }

  void movePasses(int playerNo) {
    if (playerNo == 1) {
      player1.decreaseMoveNumber();
      if (player1.moveNumber == 0) {
        finishTurn(1);
      }
    } else {
      player2.decreaseMoveNumber();
      if (player2.moveNumber == 0) {
        finishTurn(2);
      }
    }
  }

  void setActiveCard(String s) {
    activeCard = s;
  }

  void calculateRent(List<CustomCard> cardList) {
    int stackNo = cardList.length;
    String color = cardList[0].type == "property"
        ? cardList[0].color
        : cardList[0].description;
    rentToBeTaken = kRents[color][stackNo];
  }

  Future createDialog(Player player) async {
    int playerNo = turn == 1 ? 2 : 0;
    await showDialog(
        context: context,
        builder: (BuildContext context) => RotatedBox(
            quarterTurns: playerNo, child: refuseCardAlertDialog(player)),
        barrierDismissible: false);
  }

  CupertinoAlertDialog refuseCardAlertDialog(Player player) {
    return CupertinoAlertDialog(
      title: Text("Ret?"),
      content: Text("Reddet kartın varsa kullanmak istiyor musun?"),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Hayır"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Evet"),
          onPressed: () {
            int i = 0;
            for (CustomCard cc in player.hand) {
              int num = i;
              if (cc.name == "Reddet") {
                player.removeFromHand(num);
                activeCard = "";
                break;
              }
              i++;
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void activateCardEffect(int i, int playerNo, bool isStacked, int p1benchState,
      int p2benchState, int k) async {
    bool isMyCard = playerNo == turn;
    switch (activeCard) {
      case "Tapu Devri":
        if (isMyCard) {
          break;
        }
        int secondParameter = k;
        if (playerNo == 1) {
          bool condition = player1.getCardFromBench(i)[0].type == "wild"
              ? player1.getCardFromBench(i)[0].description == "black"
              : player1.getCardFromBench(i)[0].color == "black";
          if (condition) {
            if (player1.getCardFromBench(i).length == 4) {
              break;
            }
          } else if (player1.getCardFromBench(i).length == 3) {
            break;
          }
          if (player1.getCardFromBench(i)[k].type != "property" &&
              player1.getCardFromBench(i)[k].type != "wild") {
            break;
          }
          await createDialog(player2);
          if (activeCard == "") {
            break;
          }
          //player2ye ekle
          player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
          //player1den çıkar
          isStacked == true
              ? player1.removeFromStackedBench(i, k)
              : player1.removeFromBench(i);

          activeCard = "";
        } else {
          bool condition = player2.getCardFromBench(i)[0].type == "wild"
              ? player2.getCardFromBench(i)[0].description == "black"
              : player2.getCardFromBench(i)[0].color == "black";
          if (condition) {
            if (player2.getCardFromBench(i).length == 4) {
              break;
            }
          } else if (player2.getCardFromBench(i).length == 3) {
            break;
          }
          if (player2.getCardFromBench(i)[k].type != "property" &&
              player2.getCardFromBench(i)[k].type != "wild") {
            break;
          }
          await createDialog(player1);
          if (activeCard == "") {
            break;
          }
          //player1e ekle
          player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
          //player2den çıkar
          isStacked == true
              ? player2.removeFromBench(i)
              : player2.removeFromStackedBench(i, k);

          activeCard = "";
        }
        break;
      case "Haciz":
        if (isMyCard) {
          break;
        }
        if (isStacked) {
          if (playerNo == 1) {
            bool condition = player1.getCardFromBench(i)[0].type == "wild"
                ? player1.getCardFromBench(i)[0].description == "black"
                : player1.getCardFromBench(i)[0].color == "black";
            if (condition) {
              if (player1.getCardFromBench(i).length < 4) {
                break;
              }
            } else if (player1.getCardFromBench(i)[0].type == "property" ||
                player1.getCardFromBench(i)[0].type == "wild") {
              if (player1.getCardFromBench(i).length < 3) {
                break;
              }
            } else {
              break;
            }
            await createDialog(player2);
            if (activeCard == "") {
              break;
            }
            //player1den çıkar
            player1.removeFromBench(i);
            //player2ye ekle
            player2
                .directlyAddMultipleCardsToBench(player1.getCardFromBench(i));

            activeCard = "";
          } else {
            bool condition = player2.getCardFromBench(i)[0].type == "wild"
                ? player2.getCardFromBench(i)[0].description == "black"
                : player2.getCardFromBench(i)[0].color == "black";
            if (condition) {
              if (player2.getCardFromBench(i).length < 4) {
                break;
              }
            } else if (player2.getCardFromBench(i)[0].type == "property" ||
                player2.getCardFromBench(i)[0].type == "wild") {
              if (player2.getCardFromBench(i).length < 3) {
                break;
              }
            } else {
              break;
            }
            await createDialog(player1);
            if (activeCard == "") {
              break;
            }
            //player2den çıkar
            player2.removeFromBench(i);
            //player1e ekle
            player1
                .directlyAddMultipleCardsToBench(player2.getCardFromBench(i));

            activeCard = "";
          }
        }
        break;
      case "Değiş Tokuş":
        if (isMyCard) {
          if (swapState == 1) {
            break;
          }
          if (playerNo == 1) {
            if (player1.getCardFromBench(i)[0].type != "property" &&
                player1.getCardFromBench(i)[0].type != "wild" &&
                player1.getCardFromBench(i)[0].type != "joker") {
              break;
            }
            await createDialog(player2);
            if (activeCard == "") {
              break;
            }
            player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
            isStacked == true
                ? player1.removeFromStackedBench(i, k)
                : player1.removeFromBench(i);
          } else {
            if (player2.getCardFromBench(i)[0].type != "property" &&
                player2.getCardFromBench(i)[0].type != "wild" &&
                player2.getCardFromBench(i)[0].type != "joker") {
              break;
            }
            await createDialog(player1);
            if (activeCard == "") {
              break;
            }
            player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
            isStacked == true
                ? player2.removeFromStackedBench(i, k)
                : player2.removeFromBench(i);
          }
          swapState = 1;
          break;
        }
        if (!isMyCard && swapState == 1) {
          if (!isStacked) {
            if (playerNo == 1) {
              player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
              isStacked == true
                  ? player1.removeFromStackedBench(i, k)
                  : player1.removeFromBench(i);
              activeCard = "";

              swapState = 0;
            } else {
              player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
              isStacked == true
                  ? player2.removeFromStackedBench(i, k)
                  : player2.removeFromBench(i);
              //player1e ekle
              activeCard = "";
              swapState = 0;
            }
          }
        }
        break;
      case "Tahsilat":
        if (!isMyCard) {
          rentToBeTaken = 5;
          if (playerNo == 1) {
            if (p1benchState == 0) {
              rentToBeTaken -= int.parse(player1.getCardFromBench(i)[0].price);
              player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
              isStacked == true
                  ? player1.removeFromStackedBench(i, k)
                  : player1.removeFromBench(i);
            } else {
              rentToBeTaken -=
                  int.parse(player1.getCardFromMoneyCards(i).price);
              player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
              isStacked == true
                  ? player1.removeFromStackedBench(i, k)
                  : player1.removeFromBench(i);
            }
            if (rentToBeTaken <= 0) {
              activeCard = "";
              rentToBeTaken = 0;
            }
          } else {
            if (p2benchState == 0) {
              rentToBeTaken -= int.parse(player2.getCardFromBench(i)[0].price);
              player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
              isStacked == true
                  ? player2.removeFromStackedBench(i, k)
                  : player2.removeFromBench(i);
            } else {
              rentToBeTaken -=
                  int.parse(player2.getCardFromMoneyCards(i).price);
              player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
              isStacked == true
                  ? player2.removeFromStackedBench(i, k)
                  : player2.removeFromBench(i);
            }
            if (rentToBeTaken <= 0) {
              activeCard = "";
              rentToBeTaken = 0;
            }
          }
        }
        break;
      case "Doğum Günü Kartı":
        if (!isMyCard) {
          rentToBeTaken = 2;
          if (playerNo == 1) {
            if (p1benchState == 0) {
              rentToBeTaken -= int.parse(player1.getCardFromBench(i)[0].price);
              player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
              isStacked == true
                  ? player1.removeFromStackedBench(i, k)
                  : player1.removeFromBench(i);
            } else {
              rentToBeTaken -=
                  int.parse(player1.getCardFromMoneyCards(i).price);
              player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
              isStacked == true
                  ? player1.removeFromStackedBench(i, k)
                  : player1.removeFromBench(i);
            }
            if (rentToBeTaken <= 0) {
              activeCard = "";
              rentToBeTaken = 0;
            }
          } else {
            if (p2benchState == 0) {
              rentToBeTaken -= int.parse(player2.getCardFromBench(i)[0].price);
              player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
              isStacked == true
                  ? player2.removeFromStackedBench(i, k)
                  : player2.removeFromBench(i);
            } else {
              rentToBeTaken -=
                  int.parse(player2.getCardFromMoneyCards(i).price);
              player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
              isStacked == true
                  ? player2.removeFromStackedBench(i, k)
                  : player2.removeFromBench(i);
            }
            if (rentToBeTaken <= 0) {
              activeCard = "";
              rentToBeTaken = 0;
            }
          }
        }
        break;
      //if one of the rent cards or iki kat kira
      default:
        int multiplier = activeCard == "İki kat kira al" ? 2 : 1;
        if (isMyCard) {
          if (rentState == 1) {
            break;
          }
          if (playerNo == 1) {
            List<String> allowedColors = new List();
            allowedColors = fillAllowedColor(allowedColors, activeCard);
            for (int x = 0; x < allowedColors.length; x++) {
              String color = player1.getCardFromBench(i)[0].type == "property"
                  ? player1.getCardFromBench(i)[0].color
                  : player1.getCardFromBench(i)[0].description;
              if (color == allowedColors[x]) {
                x = allowedColors.length - 1;
              } else if (x == allowedColors.length - 1) {
                return;
              }
            }

            if (player1.getCardFromBench(i)[0].type == "property" ||
                player1.getCardFromBench(i)[0].type == "wild") {
              await createDialog(player2);
              if (activeCard == "") {
                break;
              }
              calculateRent(player1.getCardFromBench(i));
              rentToBeTaken *= multiplier;
              rentState = 1;
            }
          } else {
            List<String> allowedColors = new List();
            allowedColors = fillAllowedColor(allowedColors, activeCard);
            for (int x = 0; x < allowedColors.length; x++) {
              String color = player2.getCardFromBench(i)[0].type == "property"
                  ? player2.getCardFromBench(i)[0].color
                  : player2.getCardFromBench(i)[0].description;
              if (color == allowedColors[x]) {
                x = allowedColors.length - 1;
              } else if (x == allowedColors.length - 1) {
                return;
              }
            }

            if (player2.getCardFromBench(i)[0].type == "property" ||
                player2.getCardFromBench(i)[0].type == "wild") {
              await createDialog(player1);
              if (activeCard == "") {
                break;
              }
              calculateRent(player2.getCardFromBench(i));
              rentToBeTaken *= multiplier;
              rentState = 1;
            }
          }
        }
        if (!isMyCard && rentState == 1) {
          if (playerNo == 1) {
            if (p1benchState == 0) {
              rentToBeTaken -= int.parse(player1.getCardFromBench(i)[0].price);
              player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
              isStacked == true
                  ? player1.removeFromStackedBench(i, k)
                  : player1.removeFromBench(i);
            } else {
              rentToBeTaken -=
                  int.parse(player1.getCardFromMoneyCards(i).price);
              player2.directlyAddCardToBench(player1.getCardFromBench(i)[k]);
              isStacked == true
                  ? player1.removeFromStackedBench(i, k)
                  : player1.removeFromBench(i);
            }
            if (rentToBeTaken <= 0) {
              activeCard = "";
              rentState = 0;
              rentToBeTaken = 0;
            }
          } else {
            if (p2benchState == 0) {
              rentToBeTaken -= int.parse(player2.getCardFromBench(i)[0].price);
              player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
              isStacked == true
                  ? player2.removeFromStackedBench(i, k)
                  : player2.removeFromBench(i);
            } else {
              rentToBeTaken -=
                  int.parse(player2.getCardFromMoneyCards(i).price);
              player1.directlyAddCardToBench(player2.getCardFromBench(i)[k]);
              isStacked == true
                  ? player2.removeFromStackedBench(i, k)
                  : player2.removeFromBench(i);
            }
            if (rentToBeTaken <= 0) {
              activeCard = "";
              rentState = 0;
              rentToBeTaken = 0;
            }
          }
        }
    }
    if (activeCard == "") {
      if (player1.moveNumber <= 0 || player2.moveNumber <= 0) {
        finishTurn(playerNo);
      }
    }
    onRejectDialogAppear();
  }

  List<String> fillAllowedColor(List<String> allowedColors, String activeCard) {
    switch (activeCard) {
      case "Rainbow Kira":
        allowedColors.add("blue");
        allowedColors.add("green");
        allowedColors.add("brown");
        allowedColors.add("light_blue");
        allowedColors.add("red");
        allowedColors.add("yellow");
        allowedColors.add("orange");
        allowedColors.add("purple");
        allowedColors.add("black");
        allowedColors.add("light_green");
        break;
      case "BlueGreen Kira":
        allowedColors.add("blue");
        allowedColors.add("green");
        break;
      case "BrownLightBlue Kira":
        allowedColors.add("brown");
        allowedColors.add("light_blue");
        break;
      case "RedYellow Kira":
        allowedColors.add("red");
        allowedColors.add("yellow");
        break;
      case "OrangePurple Kira":
        allowedColors.add("orange");
        allowedColors.add("purple");
        break;
      default:
    }
    return allowedColors;
  }

  void dump(int playerNo, int no) {
    if (playerNo == 1) {
      player1.graveyard.add(player1.hand[no]);
      player1.removeCard(no);
    } else {
      player2.graveyard.add(player2.hand[no]);
      player2.removeCard(no);
    }
  }
}
