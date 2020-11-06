import 'package:baboli_deal/card_types/custom_card.dart';
import 'package:baboli_deal/game_brain.dart';

class JokerCard extends CustomCard {
  JokerCard(String name, String color, String price, String type,
      String description, String color2)
      : super(name, color, price, type, description, color2);

  @override
  GameBrain effect(GameBrain gameBrain) {
    // TODO: implement effect
    return super.effect(gameBrain);
  }
}
