import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_data/AppLocalizations.dart';
import 'package:safe_data/components/PasswordTextField.dart';
import 'package:safe_data/encrtypt_handlers/EncryptionData.dart';
import 'package:safe_data/encrtypt_handlers/Encryptor.dart';
import 'package:safe_data/utils/Styles.dart';

import '../file_handlers/CiphersFileHandler.dart';

class CiphersList extends StatefulWidget
{
    _CiphersListState createState() => _CiphersListState();
}

class _CiphersListState extends State<CiphersList>
{
	List<Widget> ciphersDisplayNamesTiles = List<Widget>();
	List<String> displayNames = List<String>();
	Map<String, dynamic> encryptedData = Map<String, dynamic>();

	_CiphersListState()
	{
		CiphersFileHandler.observables.addListener(setNames);
		CiphersFileHandler.getEncryptionsData().then((iEncryptedData){
			Map<String, dynamic> currentCiphers = iEncryptedData;
			if(currentCiphers == null)
			{
				currentCiphers = {};
			}

			setState(() {
				encryptedData = currentCiphers;
				displayNames = currentCiphers.keys.toList();
			});
		});
	}

	@override
    void dispose() 
    {
        super.dispose();
        CiphersFileHandler.observables.removeListener(setNames);
    }

    void setNames(List<String> idisplayNames)
    {
		CiphersFileHandler.getEncryptionsData().then((iEncryptedData){
			setState(() {
				displayNames = idisplayNames; 
				encryptedData = iEncryptedData;
			});
		});
    }

	ListTile getCipherTile(BuildContext context, String currentDisplayName)
	{
		return ListTile(
			contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
			trailing: IconButton(
				icon: Icon(Icons.delete_forever),
				color: Colors.red,
				onPressed: (){
					showDialog(context: context, builder:(context) => AlertDialog(
						backgroundColor: Styles.backgroundColor,
						title: Text(AppLocalizations.of(context).translate("are_you_sure"), style: Styles.textStyle),
						content: Text(AppLocalizations.of(context).translate("deleteting") + " '" + currentDisplayName + "'", style: Styles.textStyle),
						actions: <Widget>[
							FlatButton(
								child: Text(AppLocalizations.of(context).translate("ok"), style: Styles.textStyle),
								onPressed: (){
									CiphersFileHandler.deleteEncryptionDataByName(currentDisplayName);
									Navigator.of(context).pop();
								},
							)
						],
					));
				},
			),
			title: Text(currentDisplayName, style: Styles.textStyle),
			onTap: (){
				EncryptionData encryptionData = EncryptionData.fromJson(encryptedData[currentDisplayName]);
				String pass = "";
				showDialog(context: context, builder:(context) => AlertDialog(
					backgroundColor: Styles.backgroundColor,
					content: PasswordTextField((value) => pass = value, hasQRPrefixButton: true),
					actions: <Widget>[
						FlatButton(
							child: Text(AppLocalizations.of(context).translate("ok"), style: Styles.textStyle),
							onPressed: () {
								String plaintext = "Error";
								try
								{
									plaintext = Encryptor.decryptData(pass, encryptionData);
								}
								on ArgumentError catch(error)
								{
									plaintext = AppLocalizations.of(context).translate("decryption_error");
								}

								Navigator.of(context).pop();
								showDialog(context: context, builder:(context) => AlertDialog(
									backgroundColor: Styles.backgroundColor,
									title: Text(AppLocalizations.of(context).translate("encryption_result_title"), style: Styles.textStyle),
									content: TextField(
										controller: TextEditingController(text: plaintext), 
										readOnly: true, 
										style: Styles.textStyle,
										decoration: InputDecoration(
											suffixIcon: IconButton(
												icon: Icon(Icons.content_copy, color: Colors.white,), 
												onPressed: (){
													Clipboard.setData(ClipboardData(text: plaintext));
												}
											)
										),
									),
								));
							},
						),
					],
				));
			},
		);
	}

	Widget itemBuilder(BuildContext context, int index)
	{
		return getCipherTile(context, displayNames[index]);
	}

	@override
	Widget build(BuildContext context) 
	{
		double deviderStartIdent = 20;
		const double deviderEndIdent = 20;
		return ListView.separated(
			itemBuilder: itemBuilder, 
			separatorBuilder: (BuildContext context, int index) => Divider(
				color: Colors.white,
				indent: deviderStartIdent,
				endIndent: deviderEndIdent,
				height: 0,
			), 
			itemCount: displayNames.length
		);
	}
}
