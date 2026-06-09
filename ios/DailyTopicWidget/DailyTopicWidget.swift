import WidgetKit
import SwiftUI

struct DailyTopicEntry: TimelineEntry {
    let date: Date
    let title: String
    let description: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DailyTopicEntry {
        DailyTopicEntry(date: Date(), title: "Sujet du jour", description: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyTopicEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyTopicEntry>) -> Void) {
        let entry = readEntry()
        let next = Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func readEntry() -> DailyTopicEntry {
        let prefs = UserDefaults(suiteName: "group.islamic.law.reference")
        let title = prefs?.string(forKey: "daily_topic_title") ?? "Sujet du jour"
        let desc = prefs?.string(forKey: "daily_topic_desc") ?? ""
        return DailyTopicEntry(date: Date(), title: title, description: desc)
    }
}

struct DailyTopicWidgetView: View {
    var entry: DailyTopicEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.orange)
                Text("Sujet du jour")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            Text(entry.title)
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(2)
            if !entry.description.isEmpty {
                Text(entry.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
    }
}

struct DailyTopicWidget: Widget {
    let kind: String = "DailyTopicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyTopicWidgetView(entry: entry)
        }
        .configurationDisplayName("Sujet du jour")
        .description("Affiche le sujet fiqh du jour.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct DailyTopicWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyTopicWidget()
    }
}
