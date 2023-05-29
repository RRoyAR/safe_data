import 'package:safe_data/encrtypt_handlers/EncryptionData.dart';
import 'package:safe_data/utils/ListChangeObservable.dart';
import 'JsonFileHandler.dart';

class CiphersFileHandler
{
	static const String ciphersFileName = "ciphers.json";
	static ListChangeObservable<String> observables = ListChangeObservable<String>();

	static Future<Map<String, dynamic>> getEncryptionsData() async
	{
		Map<String, dynamic> ciphers = await JsonFileHandler.readJsonFromFile(ciphersFileName);
		return ciphers;
	}

	static Future<void> writeNewEncryptionData(EncryptionData iData) async
	{
		Map<String, dynamic> iDataAsJson =  iData.toJson();
		Map<String, dynamic> currentCiphers = await getEncryptionsData();

		if(currentCiphers == null)
		{
			currentCiphers = {};
		}

		currentCiphers[iData.displayName] = iDataAsJson;

		await JsonFileHandler.writeJsonObjectToFile(ciphersFileName, currentCiphers);
		
		observables.notifyAll(await getAllDisplayNames());
	}

	static deleteEncryptionDataByName(String iDisplayName) async
	{
		Map<String, dynamic> currentCiphers = await getEncryptionsData();
		if(currentCiphers == null)
		{
			currentCiphers = {};
		}

		currentCiphers.remove(iDisplayName);
		await JsonFileHandler.writeJsonObjectToFile(ciphersFileName, currentCiphers);

		observables.notifyAll(await getAllDisplayNames());
	}

	static Future<List<String>> getAllDisplayNames() async
	{
		Map<String, dynamic> currentCiphers = await getEncryptionsData();
		if(currentCiphers == null) currentCiphers = {};
		return currentCiphers.keys.toList();
	}
}
