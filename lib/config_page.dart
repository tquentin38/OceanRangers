import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rangers/actors/water_enemy.dart';
import 'package:ocean_rangers/managers/chunk.dart';
import 'package:ocean_rangers/managers/world_manager.dart';
import 'package:ocean_rangers/objects/fish.dart';
import 'package:ocean_rangers/objects/trash.dart';
import 'package:ocean_rangers/ocean_game.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class FishTypeHolder {
  final FishType fishType;
  final double percent;
  FishTypeHolder({required this.fishType, required this.percent});
}

class TrashTypeHolder {
  final TrashType trashType;
  final double percent;
  TrashTypeHolder({required this.trashType, required this.percent});
}

class EnemyTypeHolder {
  final WaterEnemyType waterEnemyType;
  final double percent;
  EnemyTypeHolder({required this.waterEnemyType, required this.percent});
}

List<FishTypeHolder> getFishTypes(double meter) {
  List<FishTypeHolder> list = [];
  for (FishType ft in FishType.values) {
    //if we are on the spawn plage
    if (ft.deepMax >= meter && meter >= ft.deepMin) {
      if (meter >= ft.deepPeak) {
        list.add(FishTypeHolder(
            fishType: ft,
            percent: 100 *
                (1 + (ft.deepPeak - meter) / (ft.deepMax - ft.deepPeak))));
      } else {
        list.add(FishTypeHolder(
            fishType: ft,
            percent: 100 *
                (1 - (ft.deepPeak - meter) / (ft.deepPeak - ft.deepMin))));
      }
    }
  }
  return list;
}

List<TrashTypeHolder> getTrashTypes(double meter) {
  List<TrashTypeHolder> list = [];
  for (TrashType tt in TrashType.values) {
    //if we are on the spawn plage
    if (tt.deepMax >= meter && meter >= tt.deepMin) {
      if (meter >= tt.deepPeak) {
        list.add(TrashTypeHolder(
            trashType: tt,
            percent: 100 *
                (1 + (tt.deepPeak - meter) / (tt.deepMax - tt.deepPeak))));
      } else {
        list.add(TrashTypeHolder(
            trashType: tt,
            percent: 100 *
                (1 - (tt.deepPeak - meter) / (tt.deepPeak - tt.deepMin))));
      }
    }
  }
  return list;
}

List<EnemyTypeHolder> getWaterEnemyTypes(double meter) {
  List<EnemyTypeHolder> list = [];
  for (WaterEnemyType tt in WaterEnemyType.values) {
    //if we are on the spawn plage
    if (tt.deepMax >= meter && meter >= tt.deepMin) {
      if (meter >= tt.deepPeak) {
        list.add(EnemyTypeHolder(
            waterEnemyType: tt,
            percent: 100 *
                (1 + (tt.deepPeak - meter) / (tt.deepMax - tt.deepPeak))));
      } else {
        list.add(EnemyTypeHolder(
            waterEnemyType: tt,
            percent: 100 *
                (1 - (tt.deepPeak - meter) / (tt.deepPeak - tt.deepMin))));
      }
    }
  }
  return list;
}

class _ConfigPageState extends State<ConfigPage> {
  double deep = 0;
  OceanGame oceanGame = OceanGame();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Slider(
                min: 0,
                max: 1500,
                value: deep,
                onChanged: (newVal) {
                  deep = newVal;
                  setState(() {});
                }),
            Text("deep: $deep"),
            Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      Text("Fish"),
                      for (FishTypeHolder fth in getFishTypes(deep))
                        Text(
                            "${fth.fishType.name}: ${fth.percent.toStringAsFixed(3)}"),
                    ],
                  ),
                  Column(children: [
                    Text("Trash"),
                    for (TrashTypeHolder fth in getTrashTypes(deep))
                      Text(
                          "${fth.trashType.name}: ${fth.percent.toStringAsFixed(3)}"),
                  ]),
                  Column(
                    children: [
                      Text("Enemy"),
                      for (EnemyTypeHolder fth in getWaterEnemyTypes(deep))
                        Text(
                            "${fth.waterEnemyType.name}: ${fth.percent.toStringAsFixed(3)}"),
                    ],
                  )
                ],
              ),
            )
          ])),
    ]));
  }
}
