import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:home_widget/home_widget.dart';
import '../models/topic.dart';

class WidgetService {
  static const _titleKey = 'daily_topic_title';
  static const _descKey = 'daily_topic_desc';
  static const _idKey = 'daily_topic_id';
  static const _androidWidgetName = 'DailyTopicWidget';

  static Future<void> updateDailyTopic(Topic topic) async {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      await HomeWidget.setAppGroupId('group.islamic.law.reference');
      await HomeWidget.saveWidgetData<String>(_titleKey, topic.title);
      await HomeWidget.saveWidgetData<String>(_descKey, topic.description);
      await HomeWidget.saveWidgetData<int>(_idKey, topic.id ?? 0);
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
        iOSName: 'DailyTopicWidget',
      );
    } catch (_) {
      // Widget non configuré sur cette plateforme — ignorer silencieusement.
    }
  }
}
