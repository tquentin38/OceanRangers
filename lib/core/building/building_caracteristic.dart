import 'package:challenge2024/core/game_file.dart';
import 'package:challenge2024/core/ressources/ressource.dart';

class BuildingCaracteritic {
  int level;
  final BuildingCaracteritics type;

  BuildingCaracteritic(this.type, this.level);

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
        GameFile().building.saveData(this);
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

enum BuildingCaracteritics implements Comparable<BuildingCaracteritics> {
  recycleur(identifier: 1, name: "Recycler", levelMax: 6, valueForLevel: [
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
  boatStockage(
      identifier: 2,
      name: "Boat stockage",
      levelMax: 6,
      valueForLevel: [
        1,
        1.2,
        1.4,
        1.6,
        2,
        2.5
      ],
      cost: [
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
  repairStation(
      identifier: 3,
      name: "Repair station",
      levelMax: 6,
      valueForLevel: [
        1,
        0.9,
        0.8,
        0.7,
        0.6,
        0.5
      ],
      cost: [
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
  roboticArm(identifier: 4, name: "Robotic arm", levelMax: 6, valueForLevel: [
    0,
    50,
    100,
    150,
    200,
    250
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
  ]);

  const BuildingCaracteritics(
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
  int compareTo(BuildingCaracteritics other) => identifier - other.identifier;
}
