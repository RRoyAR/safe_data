import 'dart:io';

import 'package:safe_data/encrtypt_handlers/EncryptionData.dart';
import 'package:safe_data/encrtypt_handlers/Encryptor.dart';
import 'dart:convert';


import 'package:flutter_test/flutter_test.dart';

void main()
{
	testWidgets('Encryption Test', (WidgetTester tester) async {
		String myKey = "aaaaaaaaaaaaaaaaaaaæģx()!aaaaaaaa";
		print(Encryptor.isValidKey(myKey));
		EncryptionData data = Encryptor.encrypt(myKey, "hello world", myKey);
		String decryptedData = Encryptor.decryptData(myKey, data);

		print(decryptedData);

		List<int> enc = utf8.encode(myKey);
		print(myKey.length);
		print(enc);
		print(enc.length);
		print(utf8.decode(enc));
	});

	testWidgets('Dynamic', (WidgetTester tester) async {
		var dir = new Directory('lang');
		List contents = dir.listSync();
		for (var fileOrDir in contents) 
		{
			if (fileOrDir is File) 
			{
				String fileName = fileOrDir.path.replaceAll("\\", "/");
				String parentDirPath = fileOrDir.parent.path.replaceAll("\\", "/");
				fileName = fileName.replaceAll(parentDirPath, "");
				fileName = fileName.replaceAll("/", "");
				fileName = fileName.replaceAll(".json", "");
				print(fileName);
			} 
			else if (fileOrDir is Directory) 
			{
				print(fileOrDir.path);
			}
		}
	});
}
