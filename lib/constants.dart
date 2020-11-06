//name, color, price
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<List<String>> kPropertyCards = [
  ["Yeniköy", "blue", "4", "0"],
  ["Tarabya", "blue", "4", "1"],
  ["Kasımpaşa", "brown", "1", "2"],
  ["Dolapdere", "brown", "1", "3"],
  ["Elektrik İdaresi", "light_green", "2", "4"],
  ["Sular İdaresi", "light_green", "2", "5"],
  ["Mecidiyeköy", "orange", "2", "6"],
  ["Şişli", "orange", "2", "7"],
  ["Harbiye", "orange", "2", "8"],
  ["Maçka", "yellow", "3", "9"],
  [
    "Teşvikiye",
    "yellow",
    "3",
  ],
  ["Nişantaşı", "yellow", "3"],
  ["Sirkeci", "light_blue", "1"],
  ["Karaköy", "light_blue", "1"],
  ["Sultanahmet", "light_blue", "1"],
  ["Levent", "green", "4"],
  ["Etiler", "green", "4"],
  ["Bebek", "green", "4"],
  ["Bostancı", "red", "3"],
  ["Erenköy", "red", "3"],
  ["Caddebostan", "red", "3"],
  ["Beyoğlu", "purple", "2"],
  ["Beşiktaş", "purple", "2"],
  ["Taksim", "purple", "2"],
  ["Haydarpaşa", "black", "2"],
  ["Kadıköy İskelesi", "black", "2"],
  ["Kabataş Vapur", "black", "2"],
  ["Sirkeci Tren", "black", "2"],
];

//name, color, price
const List<List<String>> kMoneyCards = [
  ["1M", "pale_yellow", "1"],
  ["1M", "pale_yellow", "1"],
  ["1M", "pale_yellow", "1"],
  ["1M", "pale_yellow", "1"],
  ["1M", "pale_yellow", "1"],
  ["1M", "pale_yellow", "1"],
  ["10M", "dark_yellow", "10"],
  ["2M", "pale_brown", "2"],
  ["2M", "pale_brown", "2"],
  ["2M", "pale_brown", "2"],
  ["2M", "pale_brown", "2"],
  ["2M", "pale_brown", "2"],
  ["3M", "gray", "3"],
  ["3M", "gray", "3"],
  ["3M", "gray", "3"],
  ["4M", "blue", "4"],
  ["4M", "blue", "4"],
  ["4M", "blue", "4"],
  ["5M", "purple", "5"],
  ["5M", "purple", "5"],
];

//name, color, price, description
const List<List<String>> kActionCards = [
  ["Haciz", "purple", "5", "adamın setini çor"],
  ["Haciz", "purple", "5", "adamın setini çor"],
  ["Tahsilat", "pale_green", "3", "İstediğin bir oyuncudan 5m al"],
  ["Tahsilat", "pale_green", "3", "İstediğin bir oyuncudan 5m al"],
  ["Tahsilat", "pale_green", "3", "İstediğin bir oyuncudan 5m al"],
  [
    "İki kat kira al",
    "pale_yellow",
    "1",
    "İstediğin bir oyuncudan 2 kat kira al"
  ],
  [
    "İki kat kira al",
    "pale_yellow",
    "1",
    "İstediğin bir oyuncudan 2 kat kira al"
  ],
  [
    "Değiş Tokuş",
    "pale_yellow",
    "3",
    "Bir oyuncunun tapu senedini al, kendinden bir tane ver"
  ],
  [
    "Değiş Tokuş",
    "pale_yellow",
    "3",
    "Bir oyuncunun tapu senedini al, kendinden bir tane ver"
  ],
  [
    "Değiş Tokuş",
    "pale_yellow",
    "3",
    "Bir oyuncunun tapu senedini al, kendinden bir tane ver"
  ],
  ["Doğum Günü Kartı", "pale_orange", "2", "Doğum günün. Herkesten 2m al"],
  ["Doğum Günü Kartı", "pale_orange", "2", "Doğum günün. Herkesten 2m al"],
  ["Doğum Günü Kartı", "pale_orange", "2", "Doğum günün. Herkesten 2m al"],
  [
    "Reddet",
    "dark_blue",
    "4",
    "Sana karşı oynanmış bir aksiyon kartını reddet",
  ],
  [
    "Reddet",
    "dark_blue",
    "4",
    "Sana karşı oynanmış bir aksiyon kartını reddet",
  ],
  [
    "Reddet",
    "dark_blue",
    "4",
    "Sana karşı oynanmış bir aksiyon kartını reddet",
  ],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  ["Tekrar Çek", "pale_yellow", "1", "2 kart çek"],
  [
    "Tapu Devri",
    "pale_green",
    "3",
    "Bir oyuncunun tam set olmayan bir tapu kartına el koy"
  ],
  [
    "Tapu Devri",
    "pale_green",
    "3",
    "Bir oyuncunun tam set olmayan bir tapu kartına el koy"
  ],
  [
    "Tapu Devri",
    "pale_green",
    "3",
    "Bir oyuncunun tam set olmayan bir tapu kartına el koy"
  ],
  ["BlueGreen Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["BlueGreen Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["BrownLightBlue Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["BrownLightBlue Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["RedYellow Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["RedYellow Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["OrangePurple Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["OrangePurple Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["Rainbow Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["Rainbow Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
  ["Rainbow Kira", "pale_yellow", "1", "Her oyuncudan kira al"],
];

//isim
const List<String> kJokerCards = [
  "Joker",
  "Joker",
];

//color, color2, price
const List<List<String>> kDoublePropertyCards = [
  ["Çift Tapu Kartı", "blue", "green", "4"],
  ["Çift Tapu Kartı", "light_blue", "brown", "1"],
  ["Çift Tapu Kartı", "purple", "orange", "2"],
  ["Çift Tapu Kartı", "purple", "orange", "2"],
  ["Çift Tapu Kartı", "green", "black", "4"],
  ["Çift Tapu Kartı", "light_blue", "black", "4"],
  ["Çift Tapu Kartı", "light_green", "black", "2"],
  ["Çift Tapu Kartı", "yellow", "red", "3"],
  ["Çift Tapu Kartı", "yellow", "red", "3"],
];

//name, color, price
const List<List<String>> kHouseCards = [
  ["ev", "pale_green", "3"],
  ["ev", "pale_green", "3"],
  ["ev", "pale_green", "3"],
];

//isim, renk, para, description
const List<List<String>> kHotelCards = [
  ["otel", "blue", "4"],
  ["otel", "blue", "4"],
  ["otel", "blue", "4"],
];

const Map<String, Map<int, int>> kRents = {
  'red': {1: 2, 2: 3, 3: 6},
  'green': {1: 2, 2: 4, 3: 7},
  'yellow': {1: 2, 2: 4, 3: 6},
  'light_blue': {1: 1, 2: 2, 3: 3},
  'purple': {1: 1, 2: 2, 3: 4},
  'orange': {1: 1, 2: 3, 3: 5},
  'black': {1: 1, 2: 2, 3: 3, 4: 4},
  'brown': {1: 1, 2: 2},
  'light_green': {1: 1, 2: 2},
  'blue': {1: 3, 2: 8},
};

const Map<String, Color> kColors = {
  'red': Colors.red,
  'green': Colors.green,
  'gray': Colors.grey,
  'pale_green': Colors.lightGreen,
  'yellow': Colors.yellow,
  'pale_yellow': Colors.amberAccent,
  'dark_yellow': Colors.amber,
  'dark_blue': Colors.indigo,
  'light_blue': Colors.blueGrey,
  'purple': Colors.purple,
  'orange': Colors.orange,
  'pale_orange': Colors.orangeAccent,
  'black': Colors.black,
  'brown': Colors.deepOrangeAccent,
  'pale_brown': Colors.brown,
  'light_green': Colors.lightGreenAccent,
  'blue': Colors.blue,
};

const TextStyle kTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 11,
);
