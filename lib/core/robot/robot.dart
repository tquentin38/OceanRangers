import 'package:challenge2024/core/robot/robot_caracterisitc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Robot {
  double speedFactor = 1;
  List<RobotCaracteritic> robotCaracteristics = [];

  Robot() {
    initCaracteristics();
  }

  void initCaracteristics() {
    for (RobotCaracteritics rcs in RobotCaracteritics.values) {
      robotCaracteristics.add(RobotCaracteritic(rcs, 1));
    }
  }

  Future<void> loadSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (RobotCaracteritic res in robotCaracteristics) {
      int? savedValue = prefs.getInt("robot_${res.type.identifier}");
      if (savedValue != null) {
        res.level = savedValue;
      }
    }
  }

  Future<void> saveData(RobotCaracteritic res) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("robot_${res.type.identifier}", res.level);
  }

  Future<void> saveDatas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (RobotCaracteritic res in robotCaracteristics) {
      await prefs.setInt("robot_${res.type.identifier}", res.level);
    }
  }

  RobotCaracteritic? getCaracteristicFromEnum(
      RobotCaracteritics caracteritics) {
    for (RobotCaracteritic caract in robotCaracteristics) {
      if (caract.type == caracteritics) {
        return caract;
      }
    }
    return null;
  }

  double getValue(RobotCaracteritics caracteritics) {
    RobotCaracteritic? rc = getCaracteristicFromEnum(caracteritics);
    if (rc == null) return 0;
    return rc.getValue();
  }
}
