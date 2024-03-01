import 'package:challenge2024/core/building/building.dart';
import 'package:challenge2024/core/people/people_manager.dart';
import 'package:challenge2024/core/quests/quests_manager.dart';
import 'package:challenge2024/core/ressources/ressource.dart';
import 'package:challenge2024/core/robot/robot.dart';
import 'package:challenge2024/core/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'restapi/communication.dart';

class GameFile {
  static final GameFile _instance = GameFile._internal();

  //Load all information about the game
  int containerSize = 40;
  int boatContainerSize = 2000;
  bool seenIntro = false;

  Robot robot = Robot();
  Building building = Building();
  RessourcesManager ressourcesManager = RessourcesManager();
  PeopleManager peopleManager = PeopleManager();
  QuestsManager questsManager = QuestsManager();
  StatsManager statsManager = StatsManager();
  DateTime nextRobotAvaiable = DateTime.now();
  String? uuid;
  String? token;
  String? pseudo;
  int idAlliance = -1;
  String allianceName = "";
  String allianceJoinedDate = "";
  bool isIntroPassed = false;

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory GameFile() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  GameFile._internal() {
    // initialization logic
    initUUID();
  }

  void newGameFile() {}

  Future<void> setNextRobotAvaiable(DateTime date) async {
    nextRobotAvaiable = date;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("nextRobotAvaiable", date.toIso8601String());
  }

  Future<void> loadGameFile() async {
    await ressourcesManager.loadSave();
    await statsManager.loadSave();
    await robot.loadSave();
    await building.loadSave();
  }

  void synchronize() {
    syncStatsWithWeb();
  }

  void setIntroPassed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isIntroPassed", true);
    isIntroPassed = true;
  }

  Future<void> initUUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString("UUID");
    token = prefs.getString("token");
    pseudo = prefs.getString("pseudo");
    bool? isIntro = prefs.getBool("isIntroPassed");
    int? idAlli = prefs.getInt("idAlliance");
    String? alliName = prefs.getString("allianceName");
    String? nextRobot = prefs.getString("nextRobotAvaiable");
    if (idAlli != null) {
      idAlliance = idAlli;
    }
    if (alliName != null) {
      allianceName = alliName;
    }
    if (isIntro != null) {
      isIntroPassed = true;
    } else {
      isIntroPassed = false;
    }
    if (nextRobot != null) {
      nextRobotAvaiable = DateTime.parse(nextRobot);
    }
    debugPrint("UUID after getString: $uuid");
    //if uuid is null, create a uuid
    if (uuid == null) {
      uuid = await createUUID();
      newGameFile();
      if (uuid != null) {
        await prefs.setString("UUID", uuid!);
        await prefs.setString("pseudo", pseudo!);
        await prefs.setString("token", token!);
      }
    } else {
      await loadGameFile();
    }
    debugPrint("UUID: $uuid");
  }

  void changePseudo(String newPseudo) async {
    pseudo = newPseudo;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("pseudo", pseudo!);
    syncPseudoWeb();
  }

  void saveAllianceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("idAlliance", idAlliance);
    await prefs.setString("allianceName", allianceName);
  }

  void initBuilding() {}

  void initPeople() {}

  void loadSave() {}

  int getContainerSize() {
    return containerSize;
  }
}
