import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/locales/locales.dart';
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/shared_preferences_helper.dart';
import 'package:your_chef/core/widgets/tiles/custom_list_tile.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String? _savedLocale;

  @override
  void initState() {
    _loadLocale();
    super.initState();
  }

  void _loadLocale() async {
    _savedLocale =
        SharedPreferencesHelper.get<String>(SharedPrefsKeys.language);
  }

  Future<void> _saveLocale() async {
    await SharedPreferencesHelper.set<String>(
        SharedPrefsKeys.language, _savedLocale!);
  }

  Future<void> _removeLocale() async {
    _savedLocale = null;
    await SharedPreferencesHelper.remove(SharedPrefsKeys.language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppStrings.languages.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12).r,
        children: [
          CustomListTile(
            leading: _buildLanguageIcon(),
            subtitle: Text(
              context.deviceLocale.languageCode
                  .replaceFirst(
                      context.deviceLocale.languageCode.characters.first,
                      context.deviceLocale.languageCode.characters.first
                          .toUpperCase())
                  .toString(),
              style: TextStyle(
                fontSize: 12.sp,
                color: context.theme.iconTheme.color?.withOpacity(0.5),
              ),
            ),
            title: Text(AppStrings.system.tr()),
            trailing: _savedLocale == null ? const Icon(Icons.check) : null,
            onTap: () async {
              await context.resetLocale();

              await _removeLocale();
              if (!context.mounted) return;
              await context.deleteSaveLocale();
              setState(() {});
            },
          ),
          10.height,
          const Divider(),
          10.height,
          CustomListTile(
            leading: _buildLanguageIcon(countryCode: 'US'),
            title: const Text(AppStrings.english),
            trailing:
                _savedLocale == AppLocales.en ? const Icon(Icons.check) : null,
            onTap: () async {
              await context.setLocale(const Locale(AppLocales.en));
              _savedLocale = AppLocales.en;
              await _saveLocale();
              setState(() {});
            },
          ),
          10.height,
          CustomListTile(
            leading: _buildLanguageIcon(countryCode: 'EG'),
            title: const Text(AppStrings.arabic),
            trailing:
                _savedLocale == AppLocales.ar ? const Icon(Icons.check) : null,
            onTap: () async {
              await context.setLocale(const Locale(AppLocales.ar));
              _savedLocale = AppLocales.ar;
              await _saveLocale();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageIcon({String? countryCode}) {
    if (countryCode == null) return const Icon(HugeIcons.strokeRoundedInternet);
    return CountryFlag.fromCountryCode(
      countryCode,
      width: 24.w,
      height: 24.h,
      shape: const Circle(),
    );
  }
}
