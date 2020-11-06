import '../game_brain.dart';
import 'custom_card.dart';

class ActionCard extends CustomCard {
  ActionCard(String name, String color, String price, String type,
      String description, String color2, Function effect)
      : super(name, color, price, type, description, color2);
  bool active = false;

  @override
  GameBrain effect(GameBrain gameBrain) {
    switch (name) {
      case "Tahsilat":
        gameBrain.setActiveCard(name);
        break;
      case "Doğum Günü Kartı":
        gameBrain.setActiveCard(name);
        break;
      case "Değiş Tokuş":
        gameBrain.setActiveCard(name);
        break;
      case "Haciz":
        gameBrain.setActiveCard(name);
        break;
      case "Tekrar Çek":
        if (gameBrain.turn == 1) {
          gameBrain.player1.addCard(gameBrain.pullCard());
          gameBrain.player1.addCard(gameBrain.pullCard());
        } else {
          gameBrain.player2.addCard(gameBrain.pullCard());
          gameBrain.player2.addCard(gameBrain.pullCard());
        }
        break;
      case "Tapu Devri":
        gameBrain.setActiveCard(name);
        break;
      case "BlueGreen Kira":
        gameBrain.setActiveCard(name);
        break;
      case "BrownLightBlue Kira":
        gameBrain.setActiveCard(name);
        break;
      case "RedYellow Kira":
        gameBrain.setActiveCard(name);
        break;
      case "OrangePurple Kira":
        gameBrain.setActiveCard(name);
        break;
      case "Rainbow Kira":
        gameBrain.setActiveCard(name);
        break;
      case "İki kat kira al":
        gameBrain.setActiveCard(name);
        break;
      default:
      //
    }
    return gameBrain;
  }
}
