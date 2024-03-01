import 'package:challenge2024/core/game_file.dart';
import 'package:challenge2024/core/ressources/ressource.dart';

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
    return this.level;
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
}

enum RobotCaracteritics implements Comparable<RobotCaracteritics> {
  life(identifier: 0, name: "Life", levelMax: 6, valueForLevel: [
    1,
    1.2,
    1.4,
    1.6,
    2,
    2.5
  ], cost: [
    [
      RessourceHolder(RessourcesTypes.platic, 100),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 200),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 300),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 400),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 500),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
  ]),
  speed(identifier: 1, name: "Vitesse", levelMax: 6, valueForLevel: [
    1,
    1.2,
    1.4,
    1.6,
    2,
    2.5
  ], cost: [
    [
      RessourceHolder(RessourcesTypes.platic, 100),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 200),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 300),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 400),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 500),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
  ]),
  acceleration(
      identifier: 2,
      name: "Acceleration",
      levelMax: 6,
      valueForLevel: [
        1,
        1.1,
        1.2,
        1.3,
        1.4,
        1.5
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
      ]),
  batteryPack(identifier: 3, name: "Battery Pack", levelMax: 6, valueForLevel: [
    1,
    1.1,
    1.2,
    1.3,
    1.4,
    1.5
  ], cost: [
    [
      RessourceHolder(RessourcesTypes.platic, 100),
      RessourceHolder(RessourcesTypes.wood, 100),
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 200),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 300),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 400),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
    [
      RessourceHolder(RessourcesTypes.platic, 500),
      RessourceHolder(RessourcesTypes.wood, 100)
    ],
  ]),
  motorEfficiency(
      identifier: 4,
      name: "Best motor (electrical save)",
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
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
      ]),
  stockageSize(
      identifier: 5,
      name: "Stockage size",
      levelMax: 6,
      valueForLevel: [
        1,
        1.2,
        1.4,
        1.6,
        1.8,
        2
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
      ]),
  stabilisator(
      identifier: 6,
      name: "Counter the gravity !",
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
          RessourceHolder(RessourcesTypes.wood, 100),
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
      ]),
  stockageResistance(
      identifier: 7,
      name: "Stockage resistance",
      levelMax: 6,
      valueForLevel: [
        1,
        1.2,
        1.4,
        1.6,
        1.8,
        2
      ],
      cost: [
        [
          RessourceHolder(RessourcesTypes.platic, 100),
          RessourceHolder(RessourcesTypes.wood, 100),
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 200),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 300),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 400),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
        [
          RessourceHolder(RessourcesTypes.platic, 500),
          RessourceHolder(RessourcesTypes.wood, 100)
        ],
      ]);

  const RobotCaracteritics(
      {required this.identifier,
      required this.name,
      required this.levelMax,
      required this.valueForLevel,
      required this.cost});

  final int identifier;
  final String name;
  final int levelMax;
  final List<double> valueForLevel;
  final List<List<RessourceHolder>> cost;

  @override
  int compareTo(RobotCaracteritics other) => identifier - other.identifier;
}
