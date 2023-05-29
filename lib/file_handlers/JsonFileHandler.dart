import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class JsonFileHandler
{
    static Future<File> getFile(String fileName) async
    {
		Directory dir = await getApplicationDocumentsDirectory();
		return File("${dir.path}/$fileName");
    }

    static Future<void> writeJsonObjectToFile(String fileName, Object jsonObject) async
    {
        File file = await getFile(fileName);
        String stringedJsonObject = json.encode(jsonObject);
		try
		{
			await file.writeAsString(stringedJsonObject);
		}
		catch(error)
		{
			print("Error: ");
			print(error);
		}
    }

    static Future<Map<String, dynamic>> readJsonFromFile(String fileName) async
    {
        File file = await getFile(fileName);
        Map<String, dynamic> jsonObject = Map<String, dynamic>();
        if(file.existsSync())
        {
			String jsonString = await file.readAsString();
			jsonObject = json.decode(jsonString);
        }

        return jsonObject;
    }
}
