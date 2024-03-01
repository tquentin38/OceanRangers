import 'package:shared_preferences/shared_preferences.dart';

class StatsManager {
  List<StatsHolder> statistics = [];
  StatsManager() {
    for (StatsTypes rt in StatsTypes.values) {
      statistics.add(StatsHolder(rt, 0));
    }
  }

  Future<void> loadSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (StatsHolder res in statistics) {
      double? savedValue = prefs.getDouble("stats_${res.type.identifier}");
      if (savedValue != null) {
        res.value = savedValue;
      }
    }
  }

  Future<void> saveDatas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (StatsHolder sta in statistics) {
      await prefs.setDouble("stats_${sta.type.identifier}", sta.value);
    }
  }

  Future<void> saveData(StatsHolder sta) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("stats_${sta.type.identifier}", sta.value);
  }

  void add(StatsTypes stats, double value) {
    for (StatsHolder sta in statistics) {
      if (sta.type == stats) {
        sta.value += value;
        saveData(sta);
      }
    }
  }

  void set(StatsTypes stats, double value) {
    for (StatsHolder sta in statistics) {
      if (sta.type == stats) {
        sta.value = value;
        saveData(sta);
      }
    }
  }

  double get(StatsTypes stats) {
    for (StatsHolder sta in statistics) {
      if (sta.type == stats) {
        return sta.value;
      }
    }
    return 0;
  }
}

class StatsHolder {
  StatsTypes type;
  double value;
  StatsHolder(this.type, this.value);
}

enum StatsTypes implements Comparable<StatsTypes> {
  deepestPoint(
    identifier: 1,
    name: "Deepest point (m)",
  ),
  trashCollected(
    identifier: 2,
    name: "Trash collected",
  ),
  powerConsumed(
    identifier: 3,
    name: "Power consumed (kWh)",
  );

  const StatsTypes({required this.identifier, required this.name});

  final int identifier;
  final String name;

  @override
  int compareTo(StatsTypes other) => identifier - other.identifier;
}
