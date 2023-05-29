import 'package:flutter/material.dart';
import 'package:safe_data/AppLocalizations.dart';
import 'package:safe_data/components/my_flutter_app_icons.dart';
import 'package:safe_data/utils/QRCodeHandler.dart';
import 'package:safe_data/utils/Styles.dart';

class PasswordTextField extends StatefulWidget
{
	final bool hasQRPrefixButton;
	final Function onChange;
	final String label;

	PasswordTextField(this.onChange, {this.hasQRPrefixButton=false, this.label="encryption_password"});

	@override
	State<StatefulWidget> createState() 
	{
		return _PasswordTextField(onChange, hasQRPrefixButton, label);
	}

}

class _PasswordTextField extends State<PasswordTextField>
{
	static const IconData visible = Icons.visibility;
	static const IconData notVisible = Icons.visibility_off;
	IconData showPasswordState = notVisible;
	String label;

	TextEditingController passwordTextController;
	IconButton qrPrefixButton;
	Function onChange;

	_PasswordTextField(onChange, hasQRPrefixButton, label)
	{
		this.onChange = onChange;
		this.label = label;
		if(hasQRPrefixButton)
		{
			qrPrefixButton = IconButton(
				icon: Icon(CustomIcons.qrcode, color: Colors.white,),
				onPressed: onQRPrefixPressed
			);
		}
	}

	void onQRPrefixPressed()
	{
		QRCodeHandler.QRScanner().then((val){
			onChange(val);
			setState(() {
				passwordTextController = TextEditingController(text: val);
			});
		});
	}

	@override
	Widget build(BuildContext context) 
	{
		return TextField(
			decoration: InputDecoration(
				labelText: AppLocalizations.of(context).translate(this.label), 
				labelStyle: Styles.textStyle,
				suffixIcon: IconButton(
					icon: Icon(showPasswordState, color: Colors.white,),
					onPressed: (){
						setState(() {
							showPasswordState = showPasswordState == visible ? notVisible : visible;
						});
					},
				),
				prefixIcon: qrPrefixButton
			),
			controller: passwordTextController,
			onChanged: onChange,
			obscureText: showPasswordState == notVisible ? true : false,
			style: Styles.textStyle,
		);
	}
	
}
