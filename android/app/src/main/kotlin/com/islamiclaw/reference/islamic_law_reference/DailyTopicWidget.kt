package com.islamiclaw.reference.islamic_law_reference

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class DailyTopicWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val title = widgetData.getString("daily_topic_title", null) ?: "Sujet du jour"
        val desc = widgetData.getString("daily_topic_desc", "") ?: ""

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.daily_topic_widget).apply {
                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_desc, desc)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
