import 'package:flutter/material.dart';
import 'package:safe_data/AppLocalizations.dart';
import 'package:safe_data/components/PasswordTextField.dart';
import 'package:safe_data/encrtypt_handlers/EncryptionData.dart';
import 'package:safe_data/encrtypt_handlers/Encryptor.dart';
import 'package:safe_data/file_handlers/CiphersFileHandler.dart';
import 'package:safe_data/utils/Styles.dart';

class EncryptForm extends StatefulWidget 
{
	@override
	State<StatefulWidget> createState() 
	{
		return _EncryptForm();
	}
}

class _EncryptForm extends State<EncryptForm> 
{
	String plainText;
	String displayName;
	String password;
	bool hasError = false;
	static const IconData visible = Icons.visibility;
	static const IconData notVisible = Icons.visibility_off;
	IconData showPasswordState = visible;
	TextEditingController passwordTextController;

	void submit(BuildContext context)
	{
		try
		{
			EncryptionData data = Encryptor.encrypt(password, plainText, displayName);
			CiphersFileHandler.writeNewEncryptionData(data).then((value){
				Navigator.pop(context);
			}).catchError((onError){
				encryptionFailed(onError);
			});
		}
		catch(err)
		{
			encryptionFailed(err);
		}
	}

	void encryptionFailed(error)
	{
		showDialog(context: context, builder: (BuildContext dialogContext){
			return AlertDialog(
				title: Text(AppLocalizations.of(context).translate("error")),
				content: Text(AppLocalizations.of(context).translate("encryption_errorText")),
			);
		});
	}

	void onPasswordChanged(value)
	{
		setState(() {
			password = value;
		});
	}
	
	void onSecretChanged(value)
	{
		setState(() {
			plainText = value;
		});
	}

	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			backgroundColor: Styles.backgroundColor,
			appBar: AppBar(
				title: Text(AppLocalizations.of(context).translate("encrypt_data")),
			),
			body: Form(
				child: Container(
					padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
					child: ListView(
						children: <Widget>[
							TextField(
								decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("encryption_name"), labelStyle: Styles.textStyle),
								onChanged: (value){setState(() {
									displayName = value;
								});},
								autofocus: true,
								style: Styles.textStyle,
							),
							PasswordTextField(onSecretChanged, label: "encryption_text",),
							PasswordTextField(onPasswordChanged, hasQRPrefixButton: true),
							Container(
								padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
								alignment: Alignment.bottomRight,
								child: FlatButton(
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(28.0),
									),
									child: Text(AppLocalizations.of(context).translate("encrypt"), style: Styles.textStyle,),
									onPressed: (
										plainText != null && plainText != "" &&
										displayName != null && displayName != "" &&
										password != null && password != ""
										) ? (){submit(context);} : null,
									color: Colors.blue,
									disabledColor: Colors.blueGrey,
									textColor: Colors.white,
									padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
								)
							),
						],
					)
				)
			),
		);
	}	
}
