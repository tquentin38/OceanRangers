import 'package:ocean_rangers/core/game_file.dart';
import 'package:ocean_rangers/core/ressources/ressource.dart';

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
    return level;
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

enum BuildingCaracteritics implements Comparable<BuildingCaracteritics> {
  recycleur(
      identifier: 1,
      name: "Recycler",
      description:
          "Allow to receive more resources from trash collected in the ocean. For each level, your boost will be upgraded.\n1:+0% !!1!!\n2:+20% !!2!!\n3:+40% !!3!!\n4:+60% !!4!!\n5:+100% !!5!!\n6:+200% !!6!!",
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
  boatStockage(
      identifier: 2,
      name: "Boat stockage",
      description:
          "Sometime, we simply need more storage space. Make some optimization on the ship to make space.\n1:+0% !!1!!\n2:+20% !!2!!\n3:+40% !!3!!\n4:+60% !!4!!\n5:+100% !!5!!\n6:+150% !!6!!",
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
      description:
          "With better tool, the repairs can be quicker ! Reduce the time to repair the endommaged robot.\n1:-0% !!1!!\n2:-10% !!2!!\n3:-20% !!3!!\n4:-30% !!4!!\n5:-40% !!5!!\n6:-50% !!6!!",
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
  roboticArm(
      identifier: 4,
      name: "Robotic arm",
      description:
          "A free hand to help you go back with the robot. Allow you to go to ship farther from the boat.\n1:0m !!1!!\n2:50m !!2!!\n3:100m !!3!!\n4:150m !!4!!\n5:200m !!5!!\n6:250m !!6!!",
      levelMax: 6,
      valueForLevel: [
        0,
        50,
        100,
        150,
        200,
        250
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
      ]);

  const BuildingCaracteritics(
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
  int compareTo(BuildingCaracteritics other) => identifier - other.identifier;
}
