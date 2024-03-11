import 'package:flame_audio/flame_audio.dart';
import 'package:ocean_rangers/core/building/building.dart';
import 'package:ocean_rangers/core/input/keyboard.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';
import 'package:ocean_rangers/core/quests/quests_manager.dart';
import 'package:ocean_rangers/core/ressources/ressource.dart';
import 'package:ocean_rangers/core/robot/robot.dart';
import 'package:ocean_rangers/core/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'restapi/communication.dart';

class GameFile {
  static final GameFile _instance = GameFile._internal();

  //Load all information about the game
  int containerSize = 40;
  int boatContainerSize = 2000;
  bool seenIntro = false;
  bool seenIntroOcean = false;

  Robot robot = Robot();
  Building building = Building();
  KeyboardManager keyboardManager = KeyboardManager();
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
  int profileId = 0;
  String goUp = "Z";
  double audioVolume = 100;
  AudioPlayer? introAudioPlayer;

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory GameFile() {
    return _instance;
  }

  AudioPlayer getAudioPlayer() {
    introAudioPlayer ??= AudioPlayer();
    return introAudioPlayer!;
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

  Future<void> setNewProfilId(int newId) async {
    profileId = newId;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("profilId", newId);
    syncProfileIdWeb();
  }

  Future<void> loadGameFile() async {
    await ressourcesManager.loadSave();
    await statsManager.loadSave();
    await robot.loadSave();
    await building.loadSave();
    await keyboardManager.loadSave();
  }

  void synchronize() {
    syncStatsWithWeb();
  }

  void setAudioVolume(double newVolume) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("audioVolume", newVolume);
    audioVolume = newVolume;
  }

  void setIntroPassed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isIntroPassed", true);
    isIntroPassed = true;
  }

  void setIntroOceanPassed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isIntroOceanPassed", true);
    seenIntroOcean = true;
  }

  Future<void> initUUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString("UUID");
    token = prefs.getString("token");
    pseudo = prefs.getString("pseudo");
    bool? isIntro = prefs.getBool("isIntroPassed");
    bool? isIntroOcean = prefs.getBool("isIntroOceanPassed");
    int? idAlli = prefs.getInt("idAlliance");
    String? alliName = prefs.getString("allianceName");
    String? nextRobot = prefs.getString("nextRobotAvaiable");
    double? audioVolumeSave = prefs.getDouble("audioVolume");
    if (audioVolumeSave != null) {
      audioVolume = audioVolumeSave;
    }
    if (idAlli != null) {
      idAlliance = idAlli;
    }
    if (alliName != null) {
      allianceName = alliName;
    }
    if (isIntro != null) {
      isIntroPassed = isIntro;
    } else {
      isIntroPassed = false;
    }
    if (isIntroOcean != null) {
      seenIntroOcean = isIntroOcean;
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
