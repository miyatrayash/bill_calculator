import 'dart:convert';

import 'package:bill_calculator/models/Item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileHandler {
  static Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<void> importData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true
    );

    String data = "";
    if (result != null && result.files.isNotEmpty) {
      PlatformFile?  file = result.files.first;
      if(file.bytes != null) {
         data = String.fromCharCodes(file.bytes!);
      }
    }

    await writeData(ItemList.fromJson(jsonDecode(data)));
  }

  static Future<void> writeData(ItemList itemList) async {
      final dirPath = await _getDirPath();

      final myFile = File('$dirPath/data.json');
      print(itemList);
      myFile.writeAsStringSync(jsonEncode(itemList));
  }

  static Future<ItemList> readData() async {
    final dirPath = await _getDirPath();


    var myFile = File('$dirPath/data.json');
    if(!myFile.existsSync()) {
      await myFile.writeAsString("");
    }
    String? data = await myFile.readAsString();

    if(data == null || data.isEmpty || jsonDecode(data) == null) {
      return ItemList([]);
    }
    return ItemList.fromJson(jsonDecode(data));

  }
}