bool compareUint8List<int>(
  List<int> a,
  List<int> b,
) {
  var aLength = a.length;
  var bLength = b.length;
  var minLength = aLength < bLength ? aLength : bLength;
  for (var i = 0; i < minLength; i++) {
    var result = a[i] == b[i];
    if (!result) return result;
  }
  return aLength - bLength == 0;
}

int compareLists<T extends Comparable<T>>(List<T> a, List<T> b) {
  var aLength = a.length;
  var bLength = b.length;
  var minLength = aLength < bLength ? aLength : bLength;
  for (var i = 0; i < minLength; i++) {
    var result = a[i].compareTo(b[i]);
    if (result != 0) return result;
  }
  return aLength - bLength;
}
