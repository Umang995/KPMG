import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class FileManager {
  FileManager._privateConstructor();
  static final FileManager instance = FileManager._privateConstructor();

  // Get the documents directory path
  Future<String> get getDocumentsDirectoryPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Save file to local storage
  Future<String> saveFile(String fileName, List<int> fileBytes) async {
    final directory = await getDocumentsDirectoryPath;
    final filePath = '$directory/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(fileBytes);
    return filePath;
  }

  Future<Uint8List?> getFileBytes(String fileName) async {
    try {
      final directoryPath = await getDocumentsDirectoryPath;
      final filePath = '$directoryPath/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        return await file.readAsBytes();
      } else {
        print('File not found at: $filePath');
        return null;
      }
    } catch (e) {
      print('Error reading file: $e');
      throw Exception('Error reading file: $e');
    }
  }

  // Check if file exists in documents directory
  Future<bool> checkIfFileExists(String fileName) async {
    try {
      final directoryPath = await getDocumentsDirectoryPath;
      final filePath = '$directoryPath/$fileName';
      final file = File(filePath);

      return await file.exists();
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }

  // Delete a file from the documents directory
  Future<void> deleteFile(String fileName) async {
    try {
      final directoryPath = await getDocumentsDirectoryPath;
      final filePath = '$directoryPath/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        print('File deleted at: $filePath');
      } else {
        print('File not found at: $filePath');
      }
    } catch (e) {
      print('Error deleting file: $e');
      throw Exception('Error deleting file: $e');
    }
  }

  Future<void> deleteFile1(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('File deleted at: $filePath');
      } else {
        print('File not found at: $filePath');
      }
    } catch (e) {
      print('Error deleting file: $e');
      throw Exception('Error deleting file: $e');
    }
  }

  // Get the path of a saved file
  Future<String> getFilePath(String fileName) async {
    final directoryPath = await getDocumentsDirectoryPath;
    return '$directoryPath/$fileName';
  }

  String getFileExtension(String url) {
    if (url.contains(".pdf")) {
      return ".pdf";
    }
    return ".png";
  }
}
