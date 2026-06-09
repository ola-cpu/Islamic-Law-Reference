import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/experience_level.dart';
import '../router/app_router.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../services/hijri_calendar.dart';
import '../services/backup_service.dart';
import '../services/encrypted_sync_service.dart';
import '../data/school_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final hijri = HijriDate.fromGregorian(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(l10n.hijriDate),
            subtitle: Text(hijri.formatted()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.languageSetting),
            subtitle: Text(_languageLabel(l10n, userProvider.locale.languageCode)),
          ),
          ...['en', 'fr', 'ar', 'ru', 'zh'].map((code) {
            return RadioListTile<Locale>(
              title: Text(_languageLabel(l10n, code)),
              value: Locale(code),
              groupValue: userProvider.locale,
              onChanged: (locale) {
                if (locale != null) userProvider.setLocale(locale);
              },
            );
          }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(l10n.myMadhhab),
            subtitle: Text(l10n.myMadhhabDesc),
          ),
          RadioListTile<String?>(
            title: Text(l10n.noSchoolPreference),
            value: null,
            groupValue: userProvider.preferredSchool,
            onChanged: (v) => userProvider.setPreferredSchool(v),
          ),
          ...SchoolSlugs.all.map((slug) => RadioListTile<String?>(
                title: Text(_schoolLabel(l10n, slug)),
                value: slug,
                groupValue: userProvider.preferredSchool,
                onChanged: (v) => userProvider.setPreferredSchool(v),
              )),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: Text(l10n.dailyReminder),
            subtitle: Text(l10n.dailyReminderDesc),
            value: userProvider.dailyReminderEnabled,
            onChanged: (v) => userProvider.setDailyReminderEnabled(v),
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: Text(l10n.homeWidget),
            subtitle: Text(l10n.homeWidgetDescIos),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(l10n.backupData),
            subtitle: Text(l10n.backupDataDesc),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(l10n.exportBackup),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final json = BackupService.buildBackupJson(userProvider);
              await SharePlus.instance.share(ShareParams(
                text: json,
                subject: l10n.exportBackup,
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(l10n.importBackup),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _importBackup(context, userProvider, l10n),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(l10n.encryptedSync),
            subtitle: Text(l10n.encryptedSyncDesc),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: Text(l10n.exportEncryptedBackup),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportEncrypted(context, userProvider, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: Text(l10n.importEncryptedBackup),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _importEncrypted(context, userProvider, l10n),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.themeSetting),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeSystem),
            value: ThemeMode.system,
            groupValue: userProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) userProvider.setThemeMode(mode);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeLight),
            value: ThemeMode.light,
            groupValue: userProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) userProvider.setThemeMode(mode);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeDark),
            value: ThemeMode.dark,
            groupValue: userProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) userProvider.setThemeMode(mode);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.speed),
            title: Text(l10n.liteMode),
            subtitle: Text(l10n.liteModeDesc),
            value: userProvider.liteMode,
            onChanged: userProvider.setLiteMode,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.filter_alt),
            title: Text(l10n.globalMadhhabFilter),
            subtitle: Text(l10n.globalMadhhabFilterDesc),
            value: userProvider.globalMadhhhabFilter,
            onChanged: userProvider.preferredSchool == null ? null : userProvider.setGlobalMadhhhabFilter,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(l10n.experienceLevel),
            subtitle: Text(l10n.experienceLevelDesc),
          ),
          RadioListTile<ExperienceLevel>(
            title: Text(l10n.beginnerMode),
            subtitle: Text(l10n.beginnerModeDesc),
            value: ExperienceLevel.beginner,
            groupValue: userProvider.experienceLevel,
            onChanged: (v) {
              if (v != null) userProvider.setExperienceLevel(v);
            },
          ),
          RadioListTile<ExperienceLevel>(
            title: Text(l10n.studentMode),
            subtitle: Text(l10n.studentModeDesc),
            value: ExperienceLevel.student,
            groupValue: userProvider.experienceLevel,
            onChanged: (v) {
              if (v != null) userProvider.setExperienceLevel(v);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: Text(l10n.methodology),
            subtitle: Text(l10n.methodologyShort),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.methodology),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            subtitle: Text(l10n.appVersion('1.0.0')),
          ),
        ],
      ),
    );
  }

  Future<String?> _askPassphrase(BuildContext context, AppLocalizations l10n, {required bool confirm}) async {
    final controller = TextEditingController();
    final confirmController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.enterPassphrase),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.passphrase),
            ),
            if (confirm) ...[
              const SizedBox(height: 8),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(labelText: l10n.confirmPassphrase),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              if (controller.text.length < 8) return;
              if (confirm && controller.text != confirmController.text) return;
              Navigator.pop(ctx, controller.text);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _exportEncrypted(BuildContext context, UserProvider user, AppLocalizations l10n) async {
    final passphrase = await _askPassphrase(context, l10n, confirm: true);
    if (passphrase == null || !context.mounted) return;
    try {
      final json = BackupService.buildBackupJson(user);
      final encrypted = EncryptedSyncService.encrypt(json, passphrase);
      await SharePlus.instance.share(ShareParams(text: encrypted, subject: l10n.exportEncryptedBackup));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.encryptedSyncFailed)));
      }
    }
  }

  Future<void> _importEncrypted(BuildContext context, UserProvider user, AppLocalizations l10n) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt', 'enc'],
      withData: true,
    );
    if (result == null || result.files.isEmpty || !context.mounted) return;
    final bytes = result.files.first.bytes;
    if (bytes == null) return;
    final passphrase = await _askPassphrase(context, l10n, confirm: false);
    if (passphrase == null || !context.mounted) return;
    try {
      final raw = utf8.decode(bytes);
      final json = EncryptedSyncService.decrypt(raw, passphrase);
      final backupResult = await BackupService.restoreFromJson(json, user);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(backupResult.ok ? l10n.backupRestored : (backupResult.error ?? l10n.backupFailed))),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.encryptedSyncFailed)));
      }
    }
  }

  Future<void> _importBackup(
    BuildContext context,
    UserProvider user,
    AppLocalizations l10n,
  ) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final bytes = result.files.first.bytes;
    if (bytes == null) return;

    final raw = utf8.decode(bytes);
    final backupResult = await BackupService.restoreFromJson(raw, user);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(backupResult.ok ? l10n.backupRestored : (backupResult.error ?? l10n.backupFailed)),
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case 'en':
        return l10n.languageEn;
      case 'fr':
        return l10n.languageFr;
      case 'ar':
        return l10n.languageAr;
      case 'ru':
        return l10n.languageRu;
      case 'zh':
        return l10n.languageZh;
      default:
        return code;
    }
  }

  String _schoolLabel(AppLocalizations l10n, String slug) {
    switch (slug) {
      case SchoolSlugs.hanafi:
        return l10n.schoolHanafi;
      case SchoolSlugs.maliki:
        return l10n.schoolMaliki;
      case SchoolSlugs.shafii:
        return l10n.schoolShafii;
      case SchoolSlugs.hanbali:
        return l10n.schoolHanbali;
      case SchoolSlugs.jafari:
        return l10n.schoolJafari;
      default:
        return slug;
    }
  }
}
