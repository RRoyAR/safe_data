import 'package:flutter/material.dart';
import 'package:safe_data/AppLocalizations.dart';
import 'package:safe_data/components/PasswordTextField.dart';
import 'package:safe_data/encrtypt_handlers/Encryptor.dart';
import 'package:safe_data/utils/QRCodeHandler.dart';
import 'package:safe_data/utils/Styles.dart';

class CreateQRCodeForm extends StatefulWidget 
{
	@override
	State<StatefulWidget> createState() 
	{
		return _CreateQRCodeForm();
	}
}

class _CreateQRCodeForm extends State<CreateQRCodeForm> 
{
	String password;
	Widget qrCode = Placeholder(color: Styles.backgroundColor,);
	static const IconData visible = Icons.visibility;
	static const IconData notVisible = Icons.visibility_off;
	IconData showPasswordState = visible;

	void createQRCode(BuildContext context)
	{
		bool isValidKey = Encryptor.isValidKey(password);
		print(isValidKey);
		setState(() {
			qrCode = QRCodeHandler.quickQRCodeCreator(password);
		});
	}

	void setPassword(iPassword)
	{
		if(iPassword.length > 32)
		{
			showDialog(context: context, builder: (BuildContext dialogContext){
				return AlertDialog(
					title: Text(AppLocalizations.of(context).translate("error")),
					content: Text(AppLocalizations.of(context).translate("encryption_errorText") + " " +
							AppLocalizations.of(context).translate("password_to_long")),
				);
			});
		}

		setState(() {
			password = iPassword;
		});
	}

	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			backgroundColor: Styles.backgroundColor,
			appBar: AppBar(
				title: Text(AppLocalizations.of(context).translate("qr_create")),
			),
			body: Form(
				child: Container(
					padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
					child: ListView(
						children: <Widget>[
							PasswordTextField(setPassword),
							Container(
								padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
								alignment: Alignment.bottomRight,
								child: FlatButton(
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(28.0),
									),
									child: Text(AppLocalizations.of(context).translate("create"), style: Styles.textStyle,),
									onPressed: (
										password != null && password != ""
										) ? (){createQRCode(context);} : null,
									color: Colors.blue,
									disabledColor: Colors.blueGrey,
									textColor: Colors.white,
									padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
								)
							),
							Container(
								padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
								child: qrCode
							)
						],
					),
				) 
			),
		);
	}
}
