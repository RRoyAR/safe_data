import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';

class QRCodeHandler
{
	static QrImage quickQRCodeCreator(String data, {int correctionLevel = QrErrorCorrectLevel.H, 
													Color backgroundColor = Colors.white,
													Color foregroundColor = Colors.black
													})
	{
		return QrImage(
			data: data,
			version: QrVersions.auto,
			backgroundColor: backgroundColor,
			foregroundColor: foregroundColor,
			errorCorrectionLevel: correctionLevel,
		);
	}

	static Future<String> QRScanner() async
	{
		try
		{
			ScanResult scanResult = await BarcodeScanner.scan();
			return scanResult.rawContent;
		}
		on PlatformException catch(platformError)
		{
			if(platformError.code == BarcodeScanner.cameraAccessDenied)
			{
				print("permision for camera is needed");
			}
			else
			{
				print("Unknown error.");
			}
		}
		on FormatException catch(formatError)
		{
			print("Nothing scanned");
		}
		catch(error)
		{
			print("Unknown error.");
		}
	}
}
