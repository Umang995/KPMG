import 'package:dreamcast/theme/ui_helper.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as Dio;
import 'dart:async';

class MyDownloadFile{
  final _dio= Dio.Dio();

  Future<void> download({imageUrl}) async {
    final isPermissionStatusGranted =
    await _requestPermission(Permission.storage);

    if(!isPermissionStatusGranted){
      await _requestPermission(Permission.storage);
    }

    String? filePath = await _getDownloadDirectory();
    final savePath = path.join('${filePath??""}/image.png');
    await _startDownload(savePath,imageUrl);
  }

  Future<void> downloadForIos({imageUrl}) async {
    print(imageUrl);
    final isPermissionStatusGranted =
    await _requestPermission(Permission.storage);

    if(!isPermissionStatusGranted){
      await _requestPermission(Permission.storage);
    }
    final dir = await _getDownloadDirectoryIos();
    print(dir);
    final hasExisted = dir?.existsSync() ?? false;
    if (!hasExisted) {
      await dir?.create();
    }
    if (dir != null) {
      final savePath = path.join('${dir.path}/image.png');
      await _startDownload(savePath, imageUrl);
    } else {
      print("please check permission");
    }
  }


  Future<void> _startDownload(String savePath, String file) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    try {
      final response = await _dio.download(
        file,
        savePath,
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      if (result['isSuccess']) {
        OpenFile.open(result['filePath']);
      } else {
        UiHelper.showSuccessMsg(null, "${result['error']}");
      }
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      //await _showNotification(result);
    }
  }

  Future<String?> _getDownloadDirectory() async {
    try {
      String directory = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      return directory;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Directory?> _getDownloadDirectoryIos() async {
    try {
      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory();
      return directory;
    } catch (e) {
      return await getExternalStorageDirectory();
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}