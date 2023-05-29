import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations
{
    final Locale locale;
    Map<String, String> _localizedStrings;

    AppLocalizations(this.locale);

    static AppLocalizations of(BuildContext context)
    {
        return Localizations.of<AppLocalizations>(context, AppLocalizations);
    }

    static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

	///Load Localized strings
    Future load() async
    {
        String jsonStringTranslations = await rootBundle.loadString("lang/${locale.languageCode}.json");
        Map<String, dynamic> jsonTransaltions = json.decode(jsonStringTranslations);

        _localizedStrings = jsonTransaltions.map((String key, dynamic value){
            return MapEntry(key, value.toString());
        });
    }

	/// Translate a string to locale string
    String translate(String key)
    {
        return _localizedStrings[key];
    }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations>
{
    const _AppLocalizationsDelegate();

    @override
    bool isSupported(Locale locale) {
        return ['en', 'he'].contains(locale.languageCode);
    }

    @override
    Future<AppLocalizations> load(Locale locale) async {
        AppLocalizations appLocalizations = AppLocalizations(locale);
        await appLocalizations.load();
        return appLocalizations;
    }

    @override
    bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
        return false;
    }
}

