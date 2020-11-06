import 'package:audioplayers/audio_cache.dart';
import 'package:baboli_deal/card_widget.dart';
import 'package:baboli_deal/constants.dart';
import 'package:baboli_deal/game_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baboli_deal/card_types/custom_card.dart';
import 'player.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GameBrain gameBrain;
  int p1benchState = 0; //0:properties, 1:moneyCards
  int p2benchState = 0; //0:properties, 1:moneyCards

  List<Widget> createBenchWidgets(int playerNo) {
    int localBenchState;
    if (playerNo == 1) {
      localBenchState = p1benchState;
    } else {
      localBenchState = p2benchState;
    }

    List<Widget> widgetsList = List();
    if (localBenchState == 0) {
      List<List<CustomCard>> cardList = gameBrain.returnBench(playerNo);

      int i = 0;
      if (cardList != null) {
        for (List<CustomCard> cardStack in cardList) {
          int number = i;
          if (cardStack.length == 1) {
            CustomCard card = cardStack[0];
            widgetsList.add(new CardWidget(card.name, card.color, card.price,
                card.type, card.description, card.color2, playerNo, () async {
              if (card.type == "wild" &&
                  !gameBrain.cardDisposition &&
                  playerNo == gameBrain.turn &&
                  gameBrain.activeCard == "") {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => RotatedBox(
                          quarterTurns: playerNo == 1 ? 0 : 2,
                          child: wildCardAlertDialog(card),
                        ),
                    barrierDismissible: false);
                gameBrain.turn == 1
                    ? gameBrain.player1.removeFromBench(number)
                    : gameBrain.player2.removeFromBench(number);
                gameBrain.turn == 1
                    ? gameBrain.player1.directlyAddCardToBench(card)
                    : gameBrain.player2.directlyAddCardToBench(card);
                gameBrain.movePasses(playerNo);
              }
              setState(() {
                if (gameBrain.activeCard != "") {
                  gameBrain.activateCardEffect(
                      number, playerNo, false, p1benchState, p2benchState, 0);
                }
              });
            }));
          } else {
            List<Widget> columnTemp = List();
            for (int k = 0; k < cardStack.length; k++) {
              CustomCard card = cardStack[k];
              int number2 = k;
              columnTemp.add(new CardWidget(card.name, card.color, card.price,
                  card.type, card.description, card.color2, playerNo, () async {
                if (card.type == "wild" &&
                    !gameBrain.cardDisposition &&
                    playerNo == gameBrain.turn &&
                    gameBrain.activeCard == "") {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => RotatedBox(
                            quarterTurns: playerNo == 1 ? 0 : 2,
                            child: wildCardAlertDialog(card),
                          ),
                      barrierDismissible: false);
                  gameBrain.turn == 1
                      ? gameBrain.player1
                          .removeFromStackedBench(number, number2)
                      : gameBrain.player2
                          .removeFromStackedBench(number, number2);
                  gameBrain.turn == 1
                      ? gameBrain.player1.directlyAddCardToBench(card)
                      : gameBrain.player2.directlyAddCardToBench(card);
                  gameBrain.movePasses(playerNo);
                }
                setState(() {
                  if (gameBrain.activeCard != "") {
                    gameBrain.activateCardEffect(number, playerNo, true,
                        p1benchState, p2benchState, number2);
                  }
                });
              }));
            }
            widgetsList.add(Expanded(
              child: Column(
                children: columnTemp,
              ),
            ));
          }
          i++;
        }
      }
    } else {
      List<CustomCard> cardList = gameBrain.returnMoneyCards(playerNo);
      int i = 0;
      for (CustomCard card in cardList) {
        int number = i;
        widgetsList.add(new CardWidget(card.name, card.color, card.price,
            card.type, card.description, card.color2, playerNo, () {
          setState(() {
            if (playerNo != gameBrain.turn) {
              if (gameBrain.activeCard != "") {
                gameBrain.activateCardEffect(
                    number, playerNo, true, p1benchState, p2benchState, 0);
              }
            }
          });
        }));
        i++;
      }
    }
    //boyutla iligli
    if (widgetsList.length < 3) {
      widgetsList.add(Expanded(
        child: Container(),
      ));
      if (widgetsList.length < 3) {
        widgetsList.add(Expanded(
          child: Container(),
        ));
      }
    }
    return widgetsList;
  }

  @override
  void initState() {
    super.initState();
    gameBrain = new GameBrain(() {
      setState(() {});
    });
  }

  void restart() {
    setState(() {
      gameBrain = new GameBrain(() {
        setState(() {});
      });
      gameBrain.context = context;
      gameBrain.player1.context = context;
      gameBrain.player2.context = context;
    });
  }

  CupertinoAlertDialog wildCardAlertDialog(CustomCard card) {
    return CupertinoAlertDialog(
      title: Text("Renk Seçimi"),
      content: Text("Hangi renkte koymak istersin?"),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(card.color),
          onPressed: () {
            card.description = card.color;
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(card.color2),
          onPressed: () {
            card.description = card.color2;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  List<CardWidget> createHandWidgets(int playerNo) {
    List<CustomCard> cardList = gameBrain.returnHand(playerNo);
    List<CardWidget> cardWidgetsList = List();
    int i = 0;
    for (CustomCard card in cardList) {
      int number = i;
      String description = card.description;
      cardWidgetsList.add(new CardWidget(card.name, card.color, card.price,
          card.type, card.description, card.color2, playerNo, () async {
        if (card.type == "wild" &&
            !gameBrain.cardDisposition &&
            gameBrain.activeCard == "" &&
            playerNo == gameBrain.turn) {
          await showDialog(
              context: context,
              builder: (BuildContext context) => RotatedBox(
                    quarterTurns: playerNo == 1 ? 0 : 2,
                    child: wildCardAlertDialog(card),
                  ),
              barrierDismissible: false);
        }
        setState(() {
          bool condition = card.name == "İki kat kira al"
              ? true
              : gameBrain.activeCard == "";
          if (playerNo == gameBrain.turn && condition) {
            if (!gameBrain.cardDisposition) {
              if (card.name == "Reddet") {
                return;
              }
              AudioCache().play("play_card.mp3");
              gameBrain = card.effect(gameBrain);
              if (gameBrain.activeCard == "Tahsilat" ||
                  gameBrain.activeCard == "Doğum Günü Kartı") {
                createRejectDialog(
                    playerNo == 1 ? gameBrain.player2 : gameBrain.player1);
              }
              if (gameBrain.modifyHand(playerNo, number)) {
                restart();
              }
              gameBrain.movePasses(playerNo);
            } else {
              gameBrain.dump(playerNo, number);
              if (playerNo == 1) {
                if (gameBrain.player1.hand.length <= 7) {
                  gameBrain.cardDisposition = false;
                  gameBrain.finishTurn(playerNo);
                }
              } else {
                if (gameBrain.player2.hand.length <= 7) {
                  gameBrain.cardDisposition = false;
                  gameBrain.finishTurn(playerNo);
                }
              }
            }
          }
        });
      }));
      i++;
    }
    return cardWidgetsList;
  }

  CardWidget createGraveyardWidget(int playerNo) {
    CustomCard cc;
    try {
      cc = playerNo == 1
          ? gameBrain.player1.graveyard[gameBrain.player1.graveyard.length - 1]
          : gameBrain.player2.graveyard[gameBrain.player2.graveyard.length - 1];
    } catch (Exception) {
      return null;
    }
    return new CardWidget(cc.name, cc.color, cc.price, cc.type, cc.description,
        cc.color2, playerNo, () {});
  }

  @override
  Widget build(BuildContext context) {
    gameBrain.context = context;
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            //player2
            Expanded(
              child: Container(
                color: gameBrain.turn == 2 ? Colors.teal : Colors.black87,
                child: Row(
                  children: gameBrain.turn == 2
                      ? createHandWidgets(2)
                      : [Container()],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.teal,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.grey.withAlpha(150),
                          margin: EdgeInsets.all(15),
                          child: Row(
                            children: createBenchWidgets(2).length == 0
                                ? [Container()]
                                : createBenchWidgets(2),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              AudioCache().play("change_bench_state.mp3");
                              if (p2benchState == 0) {
                                p2benchState = 1;
                              } else {
                                p2benchState = 0;
                              }
                            });
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                p2benchState == 0
                                    ? "Para" +
                                        "(" +
                                        gameBrain.player2.totalMoney() +
                                        ")"
                                    : "Tapu",
                                style: kTextStyle.copyWith(fontSize: 15),
                              ),
                            ),
                            color: Colors.grey.withAlpha(150),
                            margin: EdgeInsets.all(15),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.teal,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            gameBrain.finishTurn(1);
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "PAS",
                              style: kTextStyle.copyWith(fontSize: 20),
                            ),
                          ),
                          margin: EdgeInsets.only(
                              right: 10, left: 10, top: 20, bottom: 20),
                          color: Colors.grey.withAlpha(200),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.grey.withAlpha(150),
                                child: createGraveyardWidget(1) != null
                                    ? createGraveyardWidget(1)
                                    : Container(),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.brown,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.grey.withAlpha(150),
                                child: createGraveyardWidget(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            gameBrain.finishTurn(2);
                          });
                        },
                        child: Container(
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: Center(
                              child: Text(
                                "PAS",
                                style: kTextStyle.copyWith(fontSize: 20),
                              ),
                            ),
                          ),
                          margin: EdgeInsets.only(
                              right: 10, left: 10, top: 20, bottom: 20),
                          color: Colors.grey.withAlpha(200),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.teal,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.grey.withAlpha(150),
                        margin: EdgeInsets.all(15),
                        child: Row(
                          children: createBenchWidgets(1).length == 0
                              ? [Container()]
                              : createBenchWidgets(1),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            AudioCache().play("change_bench_state.mp3");
                            if (p1benchState == 0) {
                              p1benchState = 1;
                            } else {
                              p1benchState = 0;
                            }
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              p1benchState == 0
                                  ? "Para" +
                                      "(" +
                                      gameBrain.player1.totalMoney() +
                                      ")"
                                  : "Tapu",
                              style: kTextStyle.copyWith(fontSize: 15),
                            ),
                          ),
                          color: Colors.grey.withAlpha(150),
                          margin: EdgeInsets.all(15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: gameBrain.turn == 1 ? Colors.teal : Colors.black87,
                child: Row(
                  children: gameBrain.turn == 1
                      ? createHandWidgets(1)
                      : [Container()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createRejectDialog(Player player) async {
    int playerNo = gameBrain.turn == 1 ? 2 : 0;
    await showDialog(
        context: context,
        builder: (BuildContext context) => RotatedBox(
            quarterTurns: playerNo == 1 ? 0 : 2,
            child: refuseCardAlertDialog(player)),
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
                gameBrain.activeCard = "";
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
}
