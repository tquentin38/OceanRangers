import 'package:shared_preferences/shared_preferences.dart';

class KeyboardManager {
  double speedFactor = 1;
  List<KeyCaracteritic> keyCaracteristics = [];

  KeyboardManager() {
    initCaracteristics();
  }

  void initCaracteristics() {
    for (KeyCaracteritics rcs in KeyCaracteritics.values) {
      keyCaracteristics.add(KeyCaracteritic(rcs, rcs.defaultValue, this));
    }
  }

  Future<void> loadSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (KeyCaracteritic res in keyCaracteristics) {
      String? savedValue = prefs.getString("key_${res.type.identifier}");
      if (savedValue != null) {
        res.value = savedValue;
      }
    }
  }

  Future<void> saveData(KeyCaracteritic res) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("key_${res.type.identifier}", res.value);
  }

  Future<void> saveDatas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (KeyCaracteritic res in keyCaracteristics) {
      await prefs.setString("key_${res.type.identifier}", res.value);
    }
  }

  KeyCaracteritic? getCaracteristicFromEnum(KeyCaracteritics caracteritics) {
    for (KeyCaracteritic caract in keyCaracteristics) {
      if (caract.type == caracteritics) {
        return caract;
      }
    }
    return null;
  }

  String getValue(KeyCaracteritics caracteritics) {
    KeyCaracteritic? rc = getCaracteristicFromEnum(caracteritics);
    if (rc == null) return "";
    return rc.value;
  }
}

class KeyCaracteritic {
  String value;
  final KeyCaracteritics type;
  final KeyboardManager manager;

  KeyCaracteritic(this.type, this.value, this.manager);

  void setValue(String newValue) {
    value = newValue;
    manager.saveData(this);
  }

  String getValue() {
    return value;
  }

  String getDescription() {
    return "${type.name} (default: ${type.defaultValue})";
  }
}

enum KeyCaracteritics implements Comparable<KeyCaracteritics> {
  goUp(identifier: 1, name: "Go up", defaultValue: "Z"),
  goDown(identifier: 2, name: "Go down", defaultValue: "S"),
  goRight(identifier: 3, name: "Go right", defaultValue: "D"),
  goLeft(identifier: 4, name: "Go left", defaultValue: "Q"),
  info(identifier: 5, name: "Open info", defaultValue: "I"),
  ;

  const KeyCaracteritics(
      {required this.identifier,
      required this.name,
      required this.defaultValue});

  final int identifier;
  final String name;
  final String defaultValue;

  @override
  int compareTo(KeyCaracteritics other) => identifier - other.identifier;
}
