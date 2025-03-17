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

  String retrieveTextFromHive(Box<dynamic> box, String pdfPath) {
    List<dynamic> contracts = box.get('contracts');

    // Find the contract with the matching pdfPath
    final contract = contracts.firstWhere(
      (contract) => contract['path'] == pdfPath,
      orElse: () => {},
    );

    // Retrieve the text from the contract
    return contract['text'] ?? 'No text found';
  }
}
