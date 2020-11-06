import 'package:baboli_deal/game_brain.dart';

class CustomCard {
  String name, color, price, type, description, color2;
  CustomCard(this.name, this.color, this.price, this.type, this.description,
      this.color2);

  GameBrain effect(GameBrain gameBrain) {
    //just a template for childs
    return gameBrain;
  }
}
