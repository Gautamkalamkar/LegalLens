import 'package:hive_ce/hive.dart';

class HiveService {
  List<Map<dynamic, dynamic>> loadKey(
      String keyName, dynamic key, Box<dynamic> box) {
    final data = box.get(keyName, defaultValue: <Map>[]);
    if (data is List) {
      return key = data.cast<Map<dynamic, dynamic>>(); // Safely cast the data
    } else {
      return []; // Fallback to an empty list if the data is invalid
    }
  }

  bool isDuplicate(String name, dynamic key) {
    return key.any((key) => key['name'] == name);
  }

  void deletekey(int index, dynamic key, Box<dynamic> box, String keyName) {
    key.removeAt(index);
    box.put(keyName, key);
  }

  String retrieveTextFromHive(
      Box<dynamic> box, String pdfPath, String keyName) {
    List<dynamic> keys = box.get(keyName);

    // Find the contract with the matching pdfPath
    final key = keys.firstWhere(
      (key) => key['path'] == pdfPath,
      orElse: () => {},
    );

    // Retrieve the text from the contract
    return key['text'] ?? 'No text found';
  }
}
