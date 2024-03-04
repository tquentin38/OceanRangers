import 'package:ocean_rangers/core/building/building_caracteristic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Building {
  double speedFactor = 1;
  List<BuildingCaracteritic> buildingCaracteristics = [];

  Building() {
    initCaracteristics();
  }

  void initCaracteristics() {
    for (BuildingCaracteritics rcs in BuildingCaracteritics.values) {
      buildingCaracteristics.add(BuildingCaracteritic(rcs, 1));
    }
  }

  Future<void> loadSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (BuildingCaracteritic res in buildingCaracteristics) {
      int? savedValue = prefs.getInt("build_${res.type.identifier}");
      if (savedValue != null) {
        res.level = savedValue;
      }
    }
  }

  Future<void> saveData(BuildingCaracteritic res) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("build_${res.type.identifier}", res.level);
  }

  Future<void> saveDatas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (BuildingCaracteritic res in buildingCaracteristics) {
      await prefs.setInt("build_${res.type.identifier}", res.level);
    }
  }

  BuildingCaracteritic? getCaracteristicFromEnum(
      BuildingCaracteritics caracteritics) {
    for (BuildingCaracteritic caract in buildingCaracteristics) {
      if (caract.type == caracteritics) {
        return caract;
      }
    }
    return null;
  }

  double getValue(BuildingCaracteritics caracteritics) {
    BuildingCaracteritic? rc = getCaracteristicFromEnum(caracteritics);
    if (rc == null) return 0;
    return rc.getValue();
  }
}
