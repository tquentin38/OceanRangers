import 'package:shared_preferences/shared_preferences.dart';

class RessourcesManager {
  List<Ressource> ressources = [];
  RessourcesManager() {
    for (RessourcesTypes rt in RessourcesTypes.values) {
      ressources.add(Ressource(rt, value: 200));
    }
  }

  Future<void> loadSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (Ressource res in ressources) {
      int? savedValue = prefs.getInt("ress_${res.type.identifier}");
      if (savedValue != null) {
        res.value = savedValue;
      }
    }
  }

  Future<void> saveData(Ressource res) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("ress_${res.type.identifier}", res.value);
  }

  Future<void> saveDatas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (Ressource res in ressources) {
      await prefs.setInt("ress_${res.type.identifier}", res.value);
    }
  }

  bool consume(RessourcesTypes ressource, int value) {
    for (Ressource res in ressources) {
      if (res.type == ressource) {
        if (res.consume(value)) {
          saveData(res);
          return true;
        }
      }
    }
    return false;
  }

  void add(RessourcesTypes ressource, int value) {
    for (Ressource res in ressources) {
      if (res.type == ressource) {
        res.add(value);
        saveData(res);
      }
    }
  }

  bool has(RessourcesTypes ressource, int value) {
    for (Ressource res in ressources) {
      if (res.type == ressource) {
        return res.has(value);
      }
    }
    return false;
  }

  int get(RessourcesTypes ressource) {
    for (Ressource res in ressources) {
      if (res.type == ressource) {
        return res.value;
      }
    }
    return 0;
  }
}

class Ressource {
  final RessourcesTypes type;
  int value = 0;

  Ressource(this.type, {this.value = 0});

  String getName() {
    return type.name;
  }

  void add(int nb) {
    value += nb;
  }

  bool has(int nb) {
    //debugPrint("Check has( $nb of ${type.name} ) (value owned : $value) ");
    return value >= nb;
  }

  bool consume(int nb) {
    //we check for the currency
    if (!has(nb)) {
      return false;
    }
    value -= nb;
    return true;
  }
}

class RessourceHolder {
  final RessourcesTypes type;
  final int value;
  const RessourceHolder(this.type, this.value);
}

enum RessourcesTypes implements Comparable<RessourcesTypes> {
  wood(
    identifier: 1,
    name: "Wood",
  ),
  platic(
    identifier: 2,
    name: "Plastic",
  ),
  iron(
    identifier: 3,
    name: "Iron",
  ),
  /*gold(
    identifier: 4,
    name: "Or",
  )*/
  ;

  const RessourcesTypes({required this.identifier, required this.name});

  final int identifier;
  final String name;

  @override
  int compareTo(RessourcesTypes other) => identifier - other.identifier;
}
