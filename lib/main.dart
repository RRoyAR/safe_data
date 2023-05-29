import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safe_data/routes/CreateQRCodeForm.dart';
import 'package:safe_data/routes/EncryptForm.dart';

import 'routes/Home.dart';
import 'AppLocalizations.dart';

class SafeDataMain extends StatelessWidget 
{
    @override
    Widget build(BuildContext context)
    {
		return MaterialApp(
			title: "SafeApp",
			home: Home(),
			routes: <String, WidgetBuilder>{
                "/encryptForm": (BuildContext buildContext) => EncryptForm(),
                "/createqrcode": (BuildContext buildContext) => CreateQRCodeForm(),
            },
			theme: ThemeData(
                primaryColor: Colors.teal[200]
            ),
			localizationsDelegates: [
                AppLocalizations.delegate, //My translations
                GlobalMaterialLocalizations.delegate, //Predefined translations for items
                GlobalWidgetsLocalizations.delegate, //Predefined rtl or ltr depending on the chosen lang
                GlobalCupertinoLocalizations.delegate //For better lang translations on ios
            ],
			supportedLocales: [
                Locale('en', 'US'),
                Locale('he', 'IL'),
            ],
			localeResolutionCallback: (locale, supporterLocales){
                Locale validLocale = supporterLocales.first;
                for (var currentLocale in supporterLocales) 
                {
                    bool isSameLangCode = currentLocale.languageCode == locale.languageCode;
                    bool isSameCountryCode = currentLocale.countryCode == locale.countryCode;
                    if(isSameLangCode && isSameCountryCode)
                    {
                        validLocale = currentLocale;
                        break;
                    }
                }

                return validLocale;
            },
		);
	}
}

void main() => runApp(SafeDataMain());
