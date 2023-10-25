import 'package:focus_manager/focus_entity.dart';

class FocusMultArray {
  final Map<int, Map<int, FocusEntity>> matriz = {};

  FocusMultArray({matriz});

  createMock() {
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
        list.addEntries(
            {j: focusEntity} as Iterable<MapEntry<int, FocusEntity>>);
      }
      matriz.addEntries(
          {i: list} as Iterable<MapEntry<int, Map<int, FocusEntity>>>);
    }
  }
}
