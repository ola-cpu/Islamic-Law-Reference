import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/topic.dart';
import '../models/law.dart';
import '../providers/user_provider.dart';
import '../data/guided_courses.dart';
import '../models/badge.dart';
import 'database_helper.dart';

class ExportService {
  static Future<String> buildLibraryExport({
    required UserProvider user,
    required String appTitle,
    required String favoritesLabel,
    required String notesLabel,
    required String noneLabel,
  }) async {
    final db = DatabaseHelper();
    final locale = user.locale;
    final buffer = StringBuffer()
      ..writeln('📚 $appTitle — Export')
      ..writeln('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}')
      ..writeln();

    buffer.writeln('=== $favoritesLabel ===');
    if (user.favorites.isEmpty) {
      buffer.writeln(noneLabel);
    } else {
      final topics = await db.getTopicsByIds(user.favorites, locale: locale);
      for (final id in user.favorites) {
        Topic? topic;
        for (final t in topics) {
          if (t.id == id) {
            topic = t;
            break;
          }
        }
        if (topic != null) {
          buffer.writeln('• ${topic.title}');
          buffer.writeln('  ${topic.description}');
        }
      }
    }

    buffer.writeln();
    buffer.writeln('=== $notesLabel ===');
    if (user.notes.isEmpty) {
      buffer.writeln(noneLabel);
    } else {
      for (final entry in user.notes.entries) {
        final topic = await db.getTopicById(entry.key, locale: locale);
        buffer.writeln('• ${topic?.title ?? 'Topic #${entry.key}'}');
        buffer.writeln('  ${entry.value}');
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  static Future<List<int>> buildLibraryPdfBytes({
    required UserProvider user,
    required String appTitle,
    required String favoritesLabel,
    required String notesLabel,
    required String noneLabel,
  }) async {
    final db = DatabaseHelper();
    final locale = user.locale;
    final fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final boldData = await rootBundle.load('assets/fonts/Amiri-Bold.ttf');
    final bold = pw.Font.ttf(boldData);

    final doc = pw.Document();
    final sections = <pw.Widget>[
      pw.Header(
        level: 0,
        child: pw.Text(appTitle, style: pw.TextStyle(font: bold, fontSize: 22)),
      ),
      pw.Text(
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700),
      ),
      pw.SizedBox(height: 16),
      pw.Text(favoritesLabel, style: pw.TextStyle(font: bold, fontSize: 16)),
      pw.SizedBox(height: 8),
    ];

    if (user.favorites.isEmpty) {
      sections.add(pw.Text(noneLabel, style: pw.TextStyle(font: font)));
    } else {
      final topics = await db.getTopicsByIds(user.favorites, locale: locale);
      for (final id in user.favorites) {
        final topic = topics.where((t) => t.id == id).firstOrNull;
        if (topic != null) {
          sections.addAll([
            pw.Text('• ${topic.title}', style: pw.TextStyle(font: bold, fontSize: 12)),
            pw.Text(topic.description, style: pw.TextStyle(font: font, fontSize: 11)),
            pw.SizedBox(height: 8),
          ]);
        }
      }
    }

    sections.addAll([
      pw.SizedBox(height: 12),
      pw.Text(notesLabel, style: pw.TextStyle(font: bold, fontSize: 16)),
      pw.SizedBox(height: 8),
    ]);

    if (user.notes.isEmpty) {
      sections.add(pw.Text(noneLabel, style: pw.TextStyle(font: font)));
    } else {
      for (final entry in user.notes.entries) {
        final topic = await db.getTopicById(entry.key, locale: locale);
        sections.addAll([
          pw.Text('• ${topic?.title ?? '#${entry.key}'}', style: pw.TextStyle(font: bold, fontSize: 12)),
          pw.Text(entry.value, style: pw.TextStyle(font: font, fontSize: 11)),
          pw.SizedBox(height: 8),
        ]);
      }
    }

    doc.addPage(pw.MultiPage(build: (context) => sections));
    return doc.save();
  }

  static Future<List<int>> buildCourseCertificateBytes({
    required GuidedCourse course,
    required Locale locale,
    required String certificateTitle,
    required String completedLabel,
    required String dateLabel,
  }) async {
    final fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final boldData = await rootBundle.load('assets/fonts/Amiri-Bold.ttf');
    final bold = pw.Font.ttf(boldData);
    final now = DateTime.now();
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(height: 40),
            pw.Text(certificateTitle, style: pw.TextStyle(font: bold, fontSize: 24)),
            pw.SizedBox(height: 24),
            pw.Text(course.title(locale), style: pw.TextStyle(font: bold, fontSize: 20)),
            pw.SizedBox(height: 16),
            pw.Text(completedLabel, style: pw.TextStyle(font: font, fontSize: 14)),
            pw.SizedBox(height: 32),
            pw.Text('$dateLabel ${now.day}/${now.month}/${now.year}', style: pw.TextStyle(font: font, fontSize: 12)),
          ],
        ),
      ),
    );
    return doc.save();
  }

  static Future<List<int>> buildComparisonPdfBytes({
    required Topic topic,
    required List<Law> laws,
    required Map<int, String> schoolNames,
    required String titleLabel,
    required String schoolsLabel,
  }) async {
    pw.Font font;
    pw.Font bold;
    try {
      final fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
      font = pw.Font.ttf(fontData);
      final boldData = await rootBundle.load('assets/fonts/Amiri-Bold.ttf');
      bold = pw.Font.ttf(boldData);
    } catch (_) {
      font = pw.Font.helvetica();
      bold = pw.Font.helveticaBold();
    }

    final doc = pw.Document();
    final blocks = <pw.Widget>[
      pw.Header(level: 0, child: pw.Text(titleLabel, style: pw.TextStyle(font: bold, fontSize: 20))),
      pw.Text(topic.title, style: pw.TextStyle(font: bold, fontSize: 16)),
      pw.SizedBox(height: 8),
      pw.Text(topic.description, style: pw.TextStyle(font: font, fontSize: 11)),
      pw.SizedBox(height: 16),
      pw.Text(schoolsLabel, style: pw.TextStyle(font: bold, fontSize: 14)),
      pw.SizedBox(height: 8),
    ];

    for (final law in laws) {
      final school = schoolNames[law.schoolId] ?? law.title;
      blocks.addAll([
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(school, style: pw.TextStyle(font: bold, fontSize: 12, color: PdfColors.blue800)),
              pw.SizedBox(height: 6),
              pw.Text(law.content, style: pw.TextStyle(font: font, fontSize: 10)),
            ],
          ),
        ),
      ]);
    }

    doc.addPage(pw.MultiPage(build: (context) => blocks));
    return doc.save();
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}

class DashboardStats {
  final int topicCount;
  final int topicsRead;
  final int favoritesCount;
  final int notesCount;
  final int badgesUnlocked;
  final int badgesTotal;
  final int coursesStarted;
  final int coursesCompleted;

  const DashboardStats({
    required this.topicCount,
    required this.topicsRead,
    required this.favoritesCount,
    required this.notesCount,
    required this.badgesUnlocked,
    required this.badgesTotal,
    required this.coursesStarted,
    required this.coursesCompleted,
  });

  double get explorationPercent =>
      topicCount == 0 ? 0 : (topicsRead / topicCount).clamp(0.0, 1.0);

  static Future<DashboardStats> load(UserProvider user) async {
    final db = DatabaseHelper();
    final topicCount = await db.getTopicCount();
    final progress = user.courseProgressMap;
    int completed = 0;
    int started = 0;
    for (final course in GuidedCourses.all) {
      final days = progress[course.id] ?? [];
      if (days.isNotEmpty) started++;
      if (days.length >= course.days.length) completed++;
    }
    return DashboardStats(
      topicCount: topicCount,
      topicsRead: user.uniqueTopicsRead,
      favoritesCount: user.favorites.length,
      notesCount: user.notes.length,
      badgesUnlocked: user.unlockedBadgeKeys.length,
      badgesTotal: BadgeCatalog.all.length,
      coursesStarted: started,
      coursesCompleted: completed,
    );
  }
}
