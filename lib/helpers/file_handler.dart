import 'dart:convert';
import 'dart:typed_data';

import 'package:bill_calculator/models/Item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

// class FileHandler {
//   static Future<String> _getDirPath() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return dir.path;
//   }
//
//   static Future<bool> exportData(ItemList itemList) async {
//
//
//
//     if(await Permission.storage.request().isGranted && await Permission.manageExternalStorage.request().isGranted )
//     {
//       var myFile = File('/storage/emulated/0/Download/items.json');
//       await myFile.writeAsString(jsonEncode(itemList));
//       return true;
//     }
//     return false;
//   }
//   static Future<String> importData() async {
//
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//           type: FileType.custom,
//           allowedExtensions: ['json'],
//           withData: true
//       );
//
//       String data = "";
//       if (result != null && result.files.isNotEmpty) {
//         PlatformFile? file = result.files.first;
//         Uint8List? bytes = file.bytes;
//         if (bytes != null) {
//           data = String.fromCharCodes(bytes);
//         }
//       }
//     print(jsonDecode(data));
//       await writeData(ItemList.fromJson(jsonDecode(data)));
//     } catch (e) {
//       return e.toString();
//     }
//     return "Data Imported Successfully";
//   }
//
//   static Future<void> writeData(ItemList itemList) async {
//       final dirPath = await _getDirPath();
//
//       final myFile = File('$dirPath/data.json');
//       print(jsonEncode(itemList));
//       await myFile.writeAsString(jsonEncode(itemList));
//   }
//
//   static Future<ItemList> readData() async {
//     final dirPath = await _getDirPath();
//
//
//     var myFile = File('$dirPath/data.json');
//     if(!myFile.existsSync()) {
//       await myFile.writeAsString("");
//     }
//     String data = await myFile.readAsString();
//
//     if(data.isEmpty || jsonDecode(data) == null) {
//       return ItemList([]);
//     }
//     return ItemList.fromJson(jsonDecode(data));
//
//   }
// }