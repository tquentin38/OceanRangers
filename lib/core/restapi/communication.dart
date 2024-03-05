import 'dart:convert';
import 'dart:math';
import 'package:ocean_rangers/core/game_file.dart';
import 'package:ocean_rangers/core/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> createUUID() async {
  //force no cache on web
  int rdm = Random().nextInt(999999);
  String url =
      "https://devforever.fr/projectOcean/back/session.php?createSession=$rdm";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response : ${response.statusCode}");
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    GameFile().pseudo = responseData["pseudo"];
    GameFile().token = responseData["token"];
    return responseData["uuid"];
  } else {
    return null;
  }
}

Future<String?> updateWallet() async {
  //force no cache on web
  int rdm = Random().nextInt(999999);
  String url =
      "https://devforever.fr/projectOcean/back/session.php?updateSession=$rdm&UUID=${GameFile().uuid}";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response : ${response.statusCode}");
  return null;
}

void syncStatsWithWeb() async {
  GameFile gameFile = GameFile();
  String jsonStats = "";
  for (StatsHolder statsHolder in gameFile.statsManager.statistics) {
    if (jsonStats.isNotEmpty) {
      jsonStats += ",";
    }
    jsonStats += "\"${statsHolder.type.identifier}\":\"${statsHolder.value}\"";
  }
  String url =
      "https://devforever.fr/projectOcean/back/session.php?setStats&UUID=${gameFile.uuid}&stats={$jsonStats}";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response : ${response.statusCode}");
  updateWallet();
}

void syncPseudoWeb() async {
  GameFile gameFile = GameFile();
  String url =
      "https://devforever.fr/projectOcean/back/session.php?setPseudo&UUID=${gameFile.uuid}&pseudo=${gameFile.pseudo}";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response : ${response.statusCode}");
  updateWallet();
}

void syncProfileIdWeb() async {
  int rdm = Random().nextInt(999999);
  GameFile gameFile = GameFile();
  String url =
      "https://devforever.fr/projectOcean/back/session.php?setProfileId=$rdm&UUID=${gameFile.uuid}&profileId=${gameFile.profileId}";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response : ${response.statusCode}");
  updateWallet();
}

class Alliance {
  int id;
  String name;
  String description;
  bool isOpen;
  int numberOfMember;
  int trashPoints;
  late String longDescription;
  late bool long;
  bool isHover = false;

  Alliance(this.id, this.name, this.description, this.isOpen,
      this.numberOfMember, this.trashPoints) {
    longDescription = description;
    if (description.length > 75) {
      long = true;
      description = "${description.substring(0, 75)}...";
    }
  }
}

Future<bool> getCurrentAlliance() async {
  //force no cache on web
  int rdm = Random().nextInt(999999);
  String url =
      "https://devforever.fr/projectOcean/back/teams.php?getTeam=$rdm&UUID=${GameFile().uuid}";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response.statusCode : ${response.statusCode}");
  if (response.statusCode == 200) {
    //debugPrint(response.body);
    var responseData = json.decode(response.body);
    if ((responseData["success"]).toString() == "1") {
      GameFile().idAlliance = int.parse(responseData["teamId"]);
      GameFile().allianceName = responseData["name"];
      GameFile().allianceJoinedDate = responseData["joinedDate"].toString();
      GameFile().saveAllianceId();
      return true;
    }
  }
  return false;
}

Future<bool> joinAlliance(int allianceId) async {
  //force no cache on web
  int rdm = Random().nextInt(999999);
  String url =
      "https://devforever.fr/projectOcean/back/teams.php?joinTeams=$rdm&UUID=${GameFile().uuid}&teamId=$allianceId";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response.statusCode : ${response.statusCode}");
  if (response.statusCode == 200) {
    updateWallet();
    return getCurrentAlliance();
  }
  return false;
}

Future<List<Alliance>> getAllianceWeb() async {
  //force no cache on web
  int rdm = Random().nextInt(999999);
  String url =
      "https://devforever.fr/projectOcean/back/teams.php?getTeams=$rdm";
  debugPrint("url : $url");
  final response = await http.get(Uri.parse(url));
  debugPrint("response.statusCode : ${response.statusCode}");
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    //debugPrint(
    //    "responseData : $responseData | succes : '${responseData["success"]}' - ${(responseData["success"]).toString() == "1"} ");
    if ((responseData["success"]).toString() == "1") {
      List<Alliance> al = [];
      //debugPrint("TEST rd : '${responseData["datas"]}' ");
      Map<String, dynamic> mp = responseData["datas"] as Map<String, dynamic>;
      mp.forEach((k, v) {
        //print("Key : $k, Value : $v");
        al.add(Alliance(
            int.parse(v["id"]),
            v["name"],
            v["description"],
            int.parse(v["isOpen"]) == 1,
            int.parse(v["number"]),
            int.parse(v["trashPoints"])));
      });
      return al;
    }
  } else {
    return [];
  }
  return [];
}
