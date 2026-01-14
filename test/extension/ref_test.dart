import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/foundation/ref.dart';
import 'package:kaeru/extensions/ref_list.dart';
import 'package:kaeru/extensions/ref_map.dart';
import 'package:kaeru/extensions/ref_set.dart';

void main() {
  group("RefListExt", () {
    test("add, remove, clear and notification", () async {
      final ref = Ref<List<int>>([]);

      int notifyCount = 0;
      ref.addListener(() => notifyCount++);

      ref.add(1);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([1]));
      expect(notifyCount, equals(1));

      ref.addAll([2, 3]);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([1, 2, 3]));
      expect(notifyCount, equals(2));

      ref.remove(2);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([1, 3]));
      expect(notifyCount, equals(3));

      ref.clear();
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([]));
      expect(notifyCount, equals(4));
    });

    test("operator [] and []=", () async {
      final ref = Ref<List<String>>(["a", "b"]);
      int notify = 0;
      ref.addListener(() => notify++);

      expect(ref[0], "a");

      ref[1] = "x";
      await Future.delayed(Duration.zero);

      expect(ref.value, equals(["a", "x"]));
      expect(notify, equals(1));
    });

    test("insert, insertAll, removeAt, removeLast", () async {
      final ref = Ref<List<int>>([1, 2, 3]);
      int notify = 0;
      ref.addListener(() => notify++);

      ref.insert(1, 9);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([1, 9, 2, 3]));

      ref.insertAll(2, [7, 8]);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([1, 9, 7, 8, 2, 3]));

      ref.removeAt(3);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([1, 9, 7, 2, 3]));

      ref.removeLast();
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([1, 9, 7, 2]));

      expect(notify, equals(4));
    });

    test("mapInPlace & reverseInPlace", () async {
      final ref = Ref<List<int>>([1, 2, 3]);
      int notify = 0;
      ref.addListener(() => notify++);

      ref.mapInPlace((e) => e * 10);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([10, 20, 30]));

      ref.reverse();
      await Future.delayed(Duration.zero);
      expect(ref.value, equals([30, 20, 10]));

      expect(notify, equals(2));
    });
  });

  // ----------------------------------------------------------------------

  group("RefMapExt", () {
    test("map set, remove and notify", () async {
      final ref = Ref<Map<String, int>>({});
      int notify = 0;

      ref.addListener(() => notify++);

      ref["a"] = 1;
      await Future.delayed(Duration.zero);
      expect(ref["a"], 1);
      expect(notify, equals(1));

      ref["b"] = 2;
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({"a": 1, "b": 2}));
      expect(notify, equals(2));

      ref.remove("a");
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({"b": 2}));
      expect(notify, equals(3));
    });

    test("putIfAbsent & addAll", () async {
      final ref = Ref<Map<String, int>>({"a": 1});
      int notify = 0;
      ref.addListener(() => notify++);

      ref.putIfAbsent("b", () => 2);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({"a": 1, "b": 2}));

      ref.addAll({"c": 3});
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({"a": 1, "b": 2, "c": 3}));

      expect(notify, equals(2));
    });

    test("updateValue, updateAllValues, toggle", () async {
      final ref = Ref<Map<String, int>>({"x": 1});
      int notify = 0;
      ref.addListener(() => notify++);

      ref.updateValue("x", (old) => old + 10);
      await Future.delayed(Duration.zero);
      expect(ref.value["x"], 11);

      ref.updateAllValues((k, v) => v * 2);
      await Future.delayed(Duration.zero);
      expect(ref.value["x"], 22);

      ref.toggle("y", () => 99);
      await Future.delayed(Duration.zero);
      expect(ref.value.containsKey("y"), true);

      ref.toggle("y", () => 0);
      await Future.delayed(Duration.zero);
      expect(ref.value.containsKey("y"), false);

      expect(notify, equals(4));
    });
  });

  // ----------------------------------------------------------------------

  group("RefSetExt", () {
    test("add, remove, toggle and notify", () async {
      final ref = Ref<Set<int>>({});
      int notify = 0;

      ref.addListener(() => notify++);

      ref.add(1);
      await Future.delayed(Duration.zero);
      expect(ref.value.contains(1), true);

      ref.addAll([2, 3]);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({1, 2, 3}));

      ref.remove(2);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({1, 3}));

      ref.toggle(3);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({1}));

      ref.toggle(3);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({1, 3}));

      expect(notify, equals(5));
    });

    test("removeWhere & retainWhere & mapInPlace", () async {
      final ref = Ref<Set<int>>({1, 2, 3, 4});
      int notify = 0;

      ref.addListener(() => notify++);

      ref.removeWhere((e) => e.isEven);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({1, 3}));

      ref.retainWhere((e) => e == 3);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({3}));

      ref.mapInPlace((e) => e * 10);
      await Future.delayed(Duration.zero);
      expect(ref.value, equals({30}));

      expect(notify, equals(3));
    });
  });
}
