import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_manager/focus_entity.dart';

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
  late FocusEntity focusSelected;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);

    for (var y = 0; y < 10; y++) {
      Map<int, FocusEntity> list = {};
      for (var x = 0; x < 10; x++) {
        FocusEntity focusEntity = FocusEntity(
          id: '${i.toString()}-${x.toString()}',
          name: 'Focus $i',
          description: 'Focus $i description',
          image: 'https://picsum.photos/200/300?random=$x$y',
          background: 'https://picsum.photos/200/300?random=$x$y',
          color: '0xFF0000',
        );
        list[x] = focusEntity;
      }
      matriz.addAll({y: list});
    }

    focusSelected = matriz[eixoX]![eixoY]!;
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      print("Key: $key");
      if (key == 'Arrow Up') {
        if (eixoY > 0) {
          eixoY--;
          _selectItem(eixoX, eixoY);
        }
      } else if (key == 'Arrow Down') {
        if (eixoY < matriz.length - 1) {
          eixoY++;
          _selectItem(eixoX, eixoY);
        }
      } else if (key == 'Arrow Left') {
        if (eixoX > 0) {
          eixoX--;
          _selectItem(eixoX, eixoY);
        }
      } else if (key == 'Arrow Right') {
        if (eixoX < matriz[eixoY]!.length - 1) {
          eixoX++;
          _selectItem(eixoX, eixoY);
        }
      } else if (key == 'Tab') {
        if (eixoX < matriz[eixoY]!.length - 1) {
          eixoX++;
          _selectItem(eixoX, eixoY);
        } else {
          eixoX = 0;
          eixoY++;
          _selectItem(eixoX, eixoY);
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

  _selectItem(int x, int y) {
    print('x: $x, y: $y');
    setState(() {
      focusSelected = matriz[x]![y]!;
      eixoX = x;
      eixoY = y;
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
              : Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 0,
                      child: Container(
                        width: 500,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              focusSelected.image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 0,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: items.entries
                            .map((x) => Wrap(
                                  direction: Axis.vertical,
                                  children: x.value.entries
                                      .map((y) => InkWell(
                                            onTap: () =>
                                                _selectItem(x.key, y.key),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: x.key == eixoX &&
                                                          y.key == eixoY
                                                      ? Colors.red
                                                      : Colors.black,
                                                  width: 5,
                                                ),
                                              ),
                                              width: 50,
                                              height: 50,
                                              child:
                                                  Image.network(y.value.image),
                                            ),
                                          ))
                                      .toList(),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
