import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_manager/focus_entity.dart';
import 'package:focus_manager/focus_mult_array.dart';

void main() {
  runApp(const RxRoot(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int eixoX = 0;
  int eixoY = 0;
  int i = 0;
  int j = 0;
  Map<int, Map<int, FocusEntity>> matriz = {};

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);

    for (var i = 0; i < 10; i++) {
      Map<int, FocusEntity> list = {};
      for (var j = 0; j < 10; j++) {
        FocusEntity focusEntity = FocusEntity(
          id: i,
          name: 'Focus $i',
          description: 'Focus $i description',
          image: 'https://picsum.photos/200/300?random=$i',
          background: 'https://picsum.photos/200/300?random=$i',
          color: '0xFF0000',
        );
        list[j] = focusEntity;
      }
      matriz.addAll({i: list});
    }
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      print("Key down: $key");
      if (key == 'Arrow Up') {
        if (eixoY > 0) {
          setState(() {
            eixoY--;
          });
        }
      } else if (key == 'Arrow Down') {
        if (eixoY < 9) {
          setState(() {
            eixoY++;
          });
        }
      } else if (key == 'Arrow Left') {
        if (eixoX > 0) {
          setState(() {
            eixoX--;
          });
        }
      } else if (key == 'Arrow Right') {
        if (eixoX < 9) {
          setState(() {
            eixoX++;
          });
        }
      }
    } else if (event is KeyUpEvent) {
      print("Key up: $key");
    } else if (event is KeyRepeatEvent) {
      print("Key repeat: $key");
    }

    return false;
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  _selectItem(int i, int j) {
    print('i: $i, j: $j');
    setState(() {
      eixoX = i;
      eixoY = j;
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.select(() => matriz.value);

    // Map<int, Map<int, FocusEntity>> items = matriz.value.matriz;
    Map<int, Map<int, FocusEntity>> items = matriz;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: items.isEmpty
              ? const CircularProgressIndicator()
              : Wrap(
                  direction: Axis.horizontal,
                  children: items.entries
                      .map((e) => Wrap(
                            direction: Axis.vertical,
                            children: e.value.entries
                                .map((j) => InkWell(
                                      onTap: () => _selectItem(e.key, j.key),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                e.key == eixoX && j.key == eixoY
                                                    ? Colors.red
                                                    : Colors.black,
                                            width: 5,
                                          ),
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: Image.network(j.value.image),
                                      ),
                                    ))
                                .toList(),
                          ))
                      .toList(),
                ),
        ),
      ),
    );
  }
}
