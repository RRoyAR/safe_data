import 'package:flutter/material.dart';
import 'package:safe_data/components/my_flutter_app_icons.dart';
import 'package:safe_data/AppLocalizations.dart';
import 'package:safe_data/utils/Styles.dart';
import '../components/CiphersList.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends StatelessWidget 
{
    @override
    Widget build(BuildContext context)
    {
		return Scaffold(
			backgroundColor: Styles.backgroundColor,
			appBar: AppBar(
        		title: Text(AppLocalizations.of(context).translate("application_title")),
     		),
			body: CiphersList(),
			floatingActionButton: SpeedDial(
				backgroundColor: Colors.green[300],
				overlayColor: Colors.grey,
				animatedIcon: AnimatedIcons.menu_close,
				curve: Curves.ease
				,
				children: [
					SpeedDialChild(
						child: Icon(Icons.lock_outline),
						onTap: () {Navigator.pushNamed(context, "/encryptForm");},
						backgroundColor: Colors.green,
						label: "Encrypt New Data"
					),
					SpeedDialChild(
						child: Icon(CustomIcons.qrcode),
						onTap: () {Navigator.pushNamed(context, "/createqrcode");},
						label: "Create QR Code"
					)
				],
			),
		);
	}
}
