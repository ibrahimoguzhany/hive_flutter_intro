import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  setUp(() async {
    Hive.init('database');
  });

  test("Name Box Create and put", () async {
    final box = await Hive.openBox<String>("ioy");

    for (var i = 0; i < 100; i++) {
      await box.add("oguz $i");
    }
    expect(box.values.first, "oguz");
  });

  test("Name Box Create and Put", () async {
    final themaBox = await Hive.openBox<bool>("theme");
    await themaBox.put("theme", true);

    expect(themaBox.get("theme"), true);
  });

  test("Name Box Add List", () async {
    final box = await Hive.openBox("hwa");
    await box.clear();
    List<String> items = List.generate(100, (index) => "$index");
    await box.addAll(items);

    expect(box.values.first, "0");
  });

  test("Name Box Put Items", () async {
    final box = await Hive.openBox("demos");
    List<MapEntry<String, String>> items = List.generate(
        100, (index) => MapEntry('$index - $index', 'oguz $index'));

    await box.putAll(Map.fromEntries(items));
    expect(box.get("99 - 99"), "oguz 99");
  });
}

class DemoModel {
  final int id;
  final String name;

  DemoModel({required this.id, required this.name});
}
