import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'EncryptionData.dart';

class Encryptor
{
	static EncryptionData encrypt(String iKey, String iPlainText, String iDisplayName)
	{
		if(isValidKey(iKey) == false)
		{
			throw "Key to long";
		}

		const int ivBase = 16;
		int padding = 32 - _getUTF8Diff(iKey);

		final correctedKey = iKey.padRight(padding);
		final IV initializationVector = IV.fromLength(ivBase);
		final Key key = Key.fromUtf8(correctedKey);
		final Encrypter encrypter = Encrypter(AES(key));
		final Encrypted encrypted = encrypter.encrypt(iPlainText, iv: initializationVector);

		return EncryptionData(encrypted.base64, initializationVector.base64, iDisplayName);
	}

	static String decryptData(String iKey, EncryptionData iEncryptionData)
	{
		int padding = 32 - _getUTF8Diff(iKey);;

		final correctedKey = iKey.padRight(padding);
		final Key key = Key.fromUtf8(correctedKey);
		final Encrypter encrypter = Encrypter(AES(key));

		String decryptedData = "Invalid Key"; 
		try
		{
			decryptedData = encrypter.decrypt64(iEncryptionData.cipherText, iv: IV.fromBase64(iEncryptionData.initializationVector));
		}
		on ArgumentError catch(error)
		{
			print("Invalid MSG: " + error.message);
			throw error;
		}

		return decryptedData;
	}

	static bool isValidKey(String iKey)
	{
		int padding = 32 - _getUTF8Diff(iKey);

		final correctedKey = iKey.padRight(padding);
		final Key key = Key.fromUtf8(correctedKey);

		return key.bytes.length <= 32;
	}

	static int _getUTF8Diff(String iKey)
	{
		List<int> encodedKey = utf8.encode(iKey);
		return encodedKey.length - iKey.length;
	} 
}
