import 'package:ocean_rangers/core/game_file.dart';
import 'package:ocean_rangers/core/ressources/ressource.dart';

class RobotCaracteritic {
  int level;
  final RobotCaracteritics type;

  RobotCaracteritic(this.type, this.level);

  double getValue() {
    return type.valueForLevel[level - 1];
  }

  String getName() {
    return type.name;
  }

  int getLevelMax() {
    return type.levelMax;
  }

  int getLevel() {
    return level;
  }

  void upgrade() {
    if (isUpgradable()) {
      for (RessourceHolder rc in type.cost[level - 1]) {
        GameFile().ressourcesManager.consume(rc.type, rc.value);
      }
      level++;
    }
  }

  bool isUpgradable() {
    if (level == type.levelMax) {
      return false;
    }
    if (type.cost[level - 1].isEmpty) {
      return false;
    }
    for (RessourceHolder rc in type.cost[level - 1]) {
      if (!GameFile().ressourcesManager.has(rc.type, rc.value)) {
        return false;
      }
    }
    return true;
  }

  String getNeededForUpgrade() {
    if (level == type.levelMax) {
      return "Level max !";
    }
    String ressources = "";
    for (RessourceHolder rc in type.cost[level - 1]) {
      ressources += " ${rc.type.name}:${rc.value}";
    }
    return "Next level : $ressources";
  }

  String getDescription() {
    String base = type.description;
    for (int i = 1; i <= type.levelMax; i++) {
      if (level == i) {
        base = base.replaceAll("!!$i!!", "(current)");
      } else {
        base = base.replaceAll("!!$i!!", "");
      }
    }
    return base;
  }
}

enum RobotCaracteritics implements Comparable<RobotCaracteritics> {
  life(
      identifier: 0,
      name: "Life",
      description:
          "Make the robot more robust, it will have more life.\n1: +0% !!1!!\n2: +20% !!2!!\n3: +40% !!3!!\n4: +60% !!4!!\n5: +100% !!5!!\n6: +150% !!6!!\n7: +200% !!7!!\n8: +250% !!8!!\n9: +300% !!9!!",
      levelMax: 9,
      valueForLevel: [
        1,
        1.2,
        1.4,
        1.6,
        2,
        2.5,
        3,
        3.5,
        4
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.iron, 50)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 150),
          RessourceHolder(RessourcesTypes.iron, 75)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.iron, 200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.iron, 250)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 700),
          RessourceHolder(RessourcesTypes.wood, 100),
          RessourceHolder(RessourcesTypes.iron, 350)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1000),
          RessourceHolder(RessourcesTypes.wood, 300),
          RessourceHolder(RessourcesTypes.iron, 500)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1500),
          RessourceHolder(RessourcesTypes.wood, 500),
          RessourceHolder(RessourcesTypes.iron, 750)
        ],
      ]),
  speed(
      identifier: 1,
      name: "Speed",
      description:
          "Are you not fast enough? well, it's something for you! Upgrade your max speed.\n1: +0% !!1!!\n2: +20% !!2!!\n3: +40% !!3!!\n4: +60% !!4!!\n5: +100% !!5!!\n6: +150% !!6!!\n7: +200% !!7!!",
      levelMax: 7,
      valueForLevel: [
        1,
        1.2,
        1.4,
        1.6,
        2,
        2.5,
        3
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 300),
          RessourceHolder(RessourcesTypes.iron, 300)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.wood, 500),
          RessourceHolder(RessourcesTypes.iron, 50)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 800),
          RessourceHolder(RessourcesTypes.wood, 800),
          RessourceHolder(RessourcesTypes.iron, 800)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1200),
          RessourceHolder(RessourcesTypes.wood, 1200),
          RessourceHolder(RessourcesTypes.iron, 1200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1500),
          RessourceHolder(RessourcesTypes.wood, 1500),
          RessourceHolder(RessourcesTypes.iron, 1550)
        ],
      ]),
  acceleration(
      identifier: 2,
      name: "Acceleration",
      description:
          "Add some agility with upgraded acceleration! Upgrade your acceleration.\n1: +0% !!1!!\n2: +10% !!2!!\n3: +20% !!3!!\n4: +30% !!4!!\n5: +40% !!5!!\n6: +50% !!6!!\n7: +75% !!7!!\n8: +100% !!8!!",
      levelMax: 8,
      valueForLevel: [
        1,
        1.1,
        1.2,
        1.3,
        1.4,
        1.5,
        1.75,
        2
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 110),
          RessourceHolder(RessourcesTypes.iron, 200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 125),
          RessourceHolder(RessourcesTypes.iron, 300)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 150),
          RessourceHolder(RessourcesTypes.iron, 400)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 750),
          RessourceHolder(RessourcesTypes.wood, 250),
          RessourceHolder(RessourcesTypes.iron, 750)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1200),
          RessourceHolder(RessourcesTypes.wood, 500),
          RessourceHolder(RessourcesTypes.iron, 1200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1500),
          RessourceHolder(RessourcesTypes.wood, 750),
          RessourceHolder(RessourcesTypes.iron, 1500)
        ],
      ]),
  batteryPack(
      identifier: 3,
      name: "Battery Pack",
      description:
          "More stored electricity! Upgrade your battery to have more time in the mission.\n1: +0% !!1!!\n2: +10% !!2!!\n3: +20% !!3!!\n4: +30% !!4!!\n5: +40% !!5!!\n6: +50% !!6!!\n7: +60% !!7!!\n8: +70% !!8!!\n9: +80% !!9!!\n10: +100% !!10!!",
      levelMax: 10,
      valueForLevel: [
        1,
        1.1,
        1.2,
        1.3,
        1.4,
        1.5,
        1.6,
        1.7,
        1.8,
        2
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 150),
          RessourceHolder(RessourcesTypes.iron, 250)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.iron, 400)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 250),
          RessourceHolder(RessourcesTypes.iron, 500)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.iron, 750)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.iron, 1000)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.iron, 1200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 600),
          RessourceHolder(RessourcesTypes.iron, 1500)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 700),
          RessourceHolder(RessourcesTypes.iron, 2000)
        ],
      ]),
  motorEfficiency(
      identifier: 4,
      name: "Best motor (electrical save) [Recommanded]",
      description:
          "Better efficiency is always a good thing! Mouvement consumes less electricity.\n1: -0% !!1!!\n2: -10% !!2!!\n3: -20% !!3!!\n4: -40% !!4!!\n5: -50% !!5!!\n6: -60% !!6!!",
      levelMax: 6,
      valueForLevel: [
        1,
        0.9,
        0.8,
        0.6,
        0.5,
        0.4
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 100),
          RessourceHolder(RessourcesTypes.iron, 300)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 300),
          RessourceHolder(RessourcesTypes.iron, 400)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 750),
          RessourceHolder(RessourcesTypes.wood, 500),
          RessourceHolder(RessourcesTypes.iron, 750)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1200),
          RessourceHolder(RessourcesTypes.wood, 1000),
          RessourceHolder(RessourcesTypes.iron, 1200)
        ],
      ]),
  stockageSize(
      identifier: 5,
      name: "Stockage size",
      description:
          "Miniaturize all the components on board to free space! Your robot has more space.\n1: +0% !!1!!\n2: +20% !!2!!\n3: +40% !!3!!\n4: +60% !!4!!\n5: +80% !!5!!\n6: +100% !!6!!\n7: +150% !!7!!\n8: +200% !!8!!\n9: +300% !!9!!\n10: +400% !!10!!",
      levelMax: 10,
      valueForLevel: [
        1,
        1.2,
        1.4,
        1.6,
        1.8,
        2,
        2.5,
        3,
        4,
        5
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 150),
          RessourceHolder(RessourcesTypes.iron, 200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 200),
          RessourceHolder(RessourcesTypes.iron, 300)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 250),
          RessourceHolder(RessourcesTypes.iron, 400)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.wood, 300),
          RessourceHolder(RessourcesTypes.iron, 500)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 750),
          RessourceHolder(RessourcesTypes.wood, 350),
          RessourceHolder(RessourcesTypes.iron, 750)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1000),
          RessourceHolder(RessourcesTypes.wood, 400),
          RessourceHolder(RessourcesTypes.iron, 1000)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1500),
          RessourceHolder(RessourcesTypes.wood, 450),
          RessourceHolder(RessourcesTypes.iron, 150)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 2000),
          RessourceHolder(RessourcesTypes.wood, 500),
          RessourceHolder(RessourcesTypes.iron, 2000)
        ],
      ]),
  stabilisator(
      identifier: 6,
      name: "Counter the gravity !",
      description:
          "With some autonomous algorithm, we can stop gravity! Stabilize the robot and reduce the gravity factor.\n1: -0% !!1!!\n2: -20% !!2!!\n3: -40% !!3!!\n4: -60% !!4!!\n5: -80% !!5!!\n6: -100% !!6!!",
      levelMax: 6,
      valueForLevel: [
        1,
        0.8,
        0.6,
        0.4,
        0.2,
        0
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 150),
          RessourceHolder(RessourcesTypes.iron, 200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.iron, 500)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.iron, 600)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.iron, 750)
        ],
      ]),
  stockageResistance(
      identifier: 7,
      name: "Stockage resistance",
      description:
          "With better material, our shield will protect our resources! You get more resources if the robot fainth.\n1: +0% !!1!!\n2: +20% !!2!!\n3: +40% !!3!!\n4: +60% !!4!!\n5: +80% !!5!!\n6: +100% !!6!!\n7: +150% !!7!!\n8: +200% !!8!!",
      levelMax: 8,
      valueForLevel: [
        1,
        1.2,
        1.4,
        1.6,
        1.8,
        2,
        2.5,
        3
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
          RessourceHolder(RessourcesTypes.iron, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 200),
          RessourceHolder(RessourcesTypes.iron, 200)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 300),
          RessourceHolder(RessourcesTypes.iron, 300)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 400),
          RessourceHolder(RessourcesTypes.iron, 400)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 600),
          RessourceHolder(RessourcesTypes.wood, 600),
          RessourceHolder(RessourcesTypes.iron, 600)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 800),
          RessourceHolder(RessourcesTypes.wood, 800),
          RessourceHolder(RessourcesTypes.iron, 800)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 1200),
          RessourceHolder(RessourcesTypes.wood, 1200),
          RessourceHolder(RessourcesTypes.iron, 1200)
        ],
      ]);

  const RobotCaracteritics(
      {required this.identifier,
      required this.name,
      required this.description,
      required this.levelMax,
      required this.valueForLevel,
      required this.cost});

  final int identifier;
  final String name;
  final String description;
  final int levelMax;
  final List<double> valueForLevel;
  final List<List<RessourceHolder>> cost;

  @override
  int compareTo(RobotCaracteritics other) => identifier - other.identifier;
}
