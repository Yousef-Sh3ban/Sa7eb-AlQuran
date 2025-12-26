import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/colors_schemes.dart' as app_color_schemes;
import '../../../core/services/app_settings_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../main.dart' as main_app;

/// Settings Screen placeholder with theme, sound, and about sections.
class SettingsScreenPlaceholder extends StatefulWidget {
  const SettingsScreenPlaceholder({super.key});

  @override
  State<SettingsScreenPlaceholder> createState() => _SettingsScreenPlaceholderState();
}

class _SettingsScreenPlaceholderState extends State<SettingsScreenPlaceholder> {
  final AppSettingsService _settingsService = AppSettingsService.instance;
  final SoundService _soundService = SoundService.instance;

  bool _soundEnabled = true;
  double _fontSize = 1.0;
  bool _loadingSettings = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsService.init();
    final soundEnabled = _settingsService.getSoundEnabled();
    final fontSize = _settingsService.getFontSize();
    _soundService.setEnabled(soundEnabled);
    if (!mounted) return;
    setState(() {
      _soundEnabled = soundEnabled;
      _fontSize = fontSize;
      _loadingSettings = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: _loadingSettings
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorScheme.primary, colorScheme.secondary],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.settings,
                            size: 40,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'الإعدادات',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SettingsSection(
                    title: 'المظهر',
                    icon: Icons.palette,
                    children: [
                      _SettingsTile(
                        title: 'الوضع الداكن',
                        subtitle: isDarkMode ? 'مفعّل' : 'غير مفعّل',
                        leading: Icon(
                          isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: colorScheme.primary,
                        ),
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            main_app.MyApp.of(context)
                                ?.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ),
                      const _ColorSchemeSelector(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsSection(
                    title: 'الصوت والخط',
                    icon: Icons.hearing,
                    children: [
                      _SettingsTile(
                        title: 'تفعيل الأصوات',
                        subtitle: _soundEnabled ? 'مفعّل' : 'غير مفعّل',
                        leading: Icon(Icons.volume_up, color: colorScheme.primary),
                        trailing: Switch(
                          value: _soundEnabled,
                          onChanged: (value) async {
                            setState(() => _soundEnabled = value);
                            _soundService.setEnabled(value);
                            await _settingsService.setSoundEnabled(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'حجم الخط',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text('${(_fontSize * 100).round()}%'),
                              ],
                            ),
                            Slider(
                              value: _fontSize,
                              min: 0.8,
                              max: 1.5,
                              divisions: 14,
                              label: '${(_fontSize * 100).round()}%',
                              onChanged: (value) => setState(() => _fontSize = value),
                              onChangeEnd: (value) async {
                                await _settingsService.setFontSize(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsSection(
                    title: 'حول التطبيق',
                    icon: Icons.info,
                    children: [
                      _SettingsTile(
                        title: 'الإصدار',
                        subtitle: '1.0.0',
                        leading: Icon(Icons.apps, color: colorScheme.primary),
                      ),
                      _SettingsTile(
                        title: 'المطور',
                        subtitle: 'صاحب القرآن',
                        leading: Icon(Icons.code, color: colorScheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle:
          subtitle != null ? Text(subtitle!, style: textTheme.bodySmall) : null,
      leading: leading,
      trailing: trailing,
    );
  }
}

class _ColorSchemeSelector extends StatelessWidget {
  const _ColorSchemeSelector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر لون التطبيق',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(9, (index) => _ColorOption(index: index)),
          ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = app_color_schemes.ColorSchemes.getSchemeByIndex(index);
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = colorScheme.primary.value == scheme.primary.value;

    return InkWell(
      onTap: () => main_app.MyApp.of(context)?.setColorScheme(index),
      borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              scheme.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
