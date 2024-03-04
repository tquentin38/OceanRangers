import 'package:ocean_rangers/core/game_file.dart';
import 'package:ocean_rangers/core/stats/stats.dart';

class QuestsManager {
  List<QuestHolder> quests = [];
  QuestsManager();

  updateQuests() {
    quests = [];
    for (Quests rt in Quests.values) {
      if (rt.type == QuestTypes.deep) {
        quests.add(QuestHolder(
            rt, GameFile().statsManager.get(StatsTypes.deepestPoint)));
      }
    }
  }

  List<QuestHolder> getQuests(bool completed) {
    List<QuestHolder> returnQuests = [];
    for (QuestHolder questHolder in quests) {
      if (questHolder.isFinished == completed) {
        returnQuests.add(questHolder);
      }
    }
    return returnQuests;
  }
}

class QuestHolder {
  Quests quest;
  bool isFinished = false;
  double value;

  QuestHolder(this.quest, this.value) {
    if (value >= quest.value) {
      isFinished = true;
    }
  }

  String getName() {
    return quest.name;
  }

  String getDescription() {
    return quest.description;
  }
}

enum Quests implements Comparable<Quests> {
  deep_1(
      identifier: 1,
      name: "Starting",
      description: "Let's start to explore the nearst part of the ocean ",
      objective: "Reach 50m deep",
      type: QuestTypes.deep,
      value: 50),
  deep_2(
      identifier: 2,
      name: "One hundred",
      description: "Reach the one hundred meter goal. It will be great ! ",
      objective: "Reach 100m deep",
      type: QuestTypes.deep,
      value: 100),
  deep_3(
      identifier: 3,
      name: "Mesopelagic",
      description:
          "Enter the Mesopelagic ocean zone. Ocean will be less friendly here !",
      objective: "Reach 200m deep",
      type: QuestTypes.deep,
      value: 200),
  deep_4(
      identifier: 4,
      name: "Further",
      description: "The light will start to fade here ...",
      objective: "Reach 300m deep",
      type: QuestTypes.deep,
      value: 300),
  deep_5(
      identifier: 5,
      name: "More further",
      description: "Wow, it's half of the one thousand !",
      objective: "Reach 500m deep",
      type: QuestTypes.deep,
      value: 500),
  deep_6(
      identifier: 6,
      name: "Bathypelagic",
      description: "Reach the Bathypelagic ocean zone",
      objective: "Reach 1000m deep",
      type: QuestTypes.deep,
      value: 1000),
  deep_7(
      identifier: 7,
      name: "What ???",
      description:
          "You will be near the bootom of the ocean, but it is a scary zone ! And our robot need to be completly optimized.",
      objective: "Reach 1500m deep",
      type: QuestTypes.deep,
      value: 1500),
  ;

  const Quests(
      {required this.identifier,
      required this.name,
      required this.description,
      required this.objective,
      required this.type,
      required this.value});

  final int identifier;
  final String name;
  final String description;
  final String objective;
  final QuestTypes type;
  final double value;

  @override
  int compareTo(Quests other) => identifier - other.identifier;
}

enum QuestTypes implements Comparable<QuestTypes> {
  deep(
    identifier: 1,
    name: "Deep",
  ),
  ;

  const QuestTypes({required this.identifier, required this.name});

  final int identifier;
  final String name;

  @override
  int compareTo(QuestTypes other) => identifier - other.identifier;
}
