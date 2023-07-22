part of astar;

class DirectionalAstarPath extends GenericPath<((int, int), PathBlock)> {}

class AstarPath extends GenericPath<(int, int)> {
  @override
  String toString() {
    return fold(
        "",
        (previousValue, element) =>
            "$previousValue => ${element.$1},${element.$2}");
  }

  DirectionalAstarPath toDirectional() {
    final result = DirectionalAstarPath();
    for (int i = 0; i < length; i++) {
      (int, int) coords = this[i];
      if (i == 0) {
        result.add((coords, PathBlock.none));
        continue;
      }
      if (i == length - 1) {
        result.add((coords, PathBlock.end));
        continue;
      }

      final prevCoords = this[i - 1];
      final nextCoords = this[i + 1];

      if (prevCoords.$1 == nextCoords.$1) {
        result.add((coords, PathBlock.vertical));
        continue;
      }
      if (prevCoords.$2 == nextCoords.$2) {
        result.add((coords, PathBlock.horizontal));
        continue;
      }

      var (nextX, nextY) =
          (prevCoords.$1 - coords.$1, prevCoords.$2 - coords.$2);
      var (prevX, prevY) =
          (nextCoords.$1 - coords.$1, nextCoords.$2 - coords.$2);

      String from = 'T';

      if (prevX == 0) {
        // from TB
        if (prevY == -1) {
          from = "T";
        } else {
          from = "B";
        }
      } else {
        // from LR
        if (prevX == -1) {
          from = "L";
        } else {
          from = "R";
        }
      }

      String to = "T";

      if (nextX == 0) {
        if (nextY == -1) {
          to = "T";
        } else {
          to = "B";
        }
      } else {
        if (nextX == -1) {
          to = "L";
        } else {
          to = "R";
        }
      }

      if (from + to == "LT" || to + from == "LT") {
        result.add((coords, PathBlock.lt));
        continue;
      }
      if (from + to == "LB" || to + from == "LB") {
        result.add((coords, PathBlock.lb));
        continue;
      }
      if (from + to == "RT" || to + from == "RT") {
        result.add((coords, PathBlock.rt));
        continue;
      }
      if (from + to == "RB" || to + from == "RB") {
        result.add((coords, PathBlock.rb));
        continue;
      }
      result.add((coords, PathBlock.err));
      continue;
    }
    return result;
  }
}

class GenericPath<T> implements List<T> {
  final List<T> _path = [];

  @override
  operator [](int x) => _path[x];

  @override
  bool any(bool Function(T element) test) => _path.any(test);
  @override
  List<R> cast<R>() => _path.cast<R>();

  @override
  bool contains(Object? element) => _path.contains(element);

  @override
  T elementAt(int index) => _path.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _path.every(test);

  @override
  Iterable<Z> expand<Z>(Iterable<Z> Function(T element) toElements) =>
      _path.expand(toElements);

  @override
  T get first => _path.first;

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _path.firstWhere(test, orElse: orElse);

  @override
  Z fold<Z>(Z initialValue, Z Function(Z previousValue, T element) combine) =>
      _path.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _path.followedBy(other);

  @override
  void forEach(void Function(T element) action) => _path.forEach(action);

  @override
  bool get isEmpty => _path.isEmpty;

  @override
  bool get isNotEmpty => _path.isNotEmpty;

  @override
  Iterator<T> get iterator => _path.iterator;

  @override
  String join([String separator = ""]) => _path.join(separator);

  @override
  T get last => _path.last;

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _path.lastWhere(test, orElse: orElse);

  @override
  int get length => _path.length;

  @override
  Iterable<Z> map<Z>(Z Function(T e) toElement) => _path.map(toElement);
  @override
  T reduce(T Function(T value, T element) combine) => _path.reduce(combine);

  @override
  T get single => _path.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _path.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _path.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _path.skipWhile(test);

  @override
  Iterable<T> take(int count) => _path.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _path.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _path.toList(growable: growable);

  @override
  Set<T> toSet() => _path.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => _path.where(test);

  @override
  Iterable<Z> whereType<Z>() => _path.whereType<Z>();

  @override
  List<T> operator +(List<T> other) => _path + other;

  @override
  void operator []=(int index, T value) => _path[index] = value;

  @override
  void add(T value) => _path.add(value);

  @override
  void addAll(Iterable<T> iterable) => _path.addAll(iterable);

  @override
  Map<int, T> asMap() => _path.asMap();

  @override
  void clear() => _path.clear();

  @override
  void fillRange(int start, int end, [T? fillValue]) =>
      _path.fillRange(start, end, fillValue);

  @override
  set first(T value) => _path.first = value;

  @override
  Iterable<T> getRange(int start, int end) => _path.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _path.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      _path.indexWhere(test, start);

  @override
  void insert(int index, T element) => _path.insert(index, element);

  @override
  void insertAll(int index, Iterable<T> iterable) =>
      _path.insertAll(index, iterable);

  @override
  set last(T value) => _path.last = value;

  @override
  int lastIndexOf(T element, [int? start]) => _path.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      _path.lastIndexWhere(test, start);

  @override
  set length(int newLength) => _path.length = newLength;

  @override
  bool remove(Object? value) => _path.remove(value);

  @override
  T removeAt(int index) => _path.removeAt(index);

  @override
  T removeLast() => _path.removeLast();

  @override
  void removeRange(int start, int end) => _path.removeRange(start, end);

  @override
  void removeWhere(bool Function(T element) test) => removeWhere(test);

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) =>
      _path.replaceRange(start, end, replacements);

  @override
  void retainWhere(bool Function(T element) test) => _path.retainWhere(test);

  @override
  Iterable<T> get reversed => _path.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) => setAll(index, iterable);

  @override
  void setRange(int start, int end, Iterable<T> iterable,
          [int skipCount = 0]) =>
      _path.setRange(start, end, iterable, skipCount);

  @override
  void shuffle([Random? random]) => _path.shuffle(random);

  @override
  void sort([int Function(T a, T b)? compare]) => _path.sort(compare);

  @override
  List<T> sublist(int start, [int? end]) => _path.sublist(start, end);
}
