import 'package:flutter/material.dart';
import 'package:ocean_rangers/actors/water_enemy.dart';
import 'package:ocean_rangers/objects/fish.dart';
import 'package:ocean_rangers/objects/trash.dart';
import 'package:ocean_rangers/ocean_game.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

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
                      const Text("Fish"),
                      for (FishTypeHolder fth in getFishTypes(deep))
                        Text(
                            "${fth.fishType.name}: ${fth.percent.toStringAsFixed(3)}"),
                    ],
                  ),
                  Column(children: [
                    const Text("Trash"),
                    for (TrashTypeHolder fth in getTrashTypes(deep))
                      Text(
                          "${fth.trashType.name}: ${fth.percent.toStringAsFixed(3)}"),
                  ]),
                  Column(
                    children: [
                      const Text("Enemy"),
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
