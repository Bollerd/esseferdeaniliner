//
//  esseferdeanilinerwidget.swift
//  esseferdeanilinerwidget
//
//  Created by Dirk Boller on 01.09.23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), menuInfo: [MenuData()], menuDate: "Heute")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), menuInfo: [MenuData()], menuDate: "Heute")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let model = Model()
            var entry: SimpleEntry
            
            await model.readData()
            
            if model.menusList.count == 0 {
                entry = SimpleEntry(date: Date(), menuInfo: [MenuData()], menuDate: "Keine Daten gefunden")
            } else {
                if model.displayNextDay(current: model.menusList[0].date) == true && model.menusList.count > 1 {
                    entry = SimpleEntry(date: Date(), menuInfo: model.menusList[1].menuData, menuDate: model.menusList[1].dateUI)
                } else {
                    entry = SimpleEntry(date: Date(), menuInfo: model.menusList[0].menuData, menuDate: model.menusList[0].dateUI)
                }
            }
             
            let entryDate = Calendar.current.date(byAdding: .hour , value: 4, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(entryDate))
            
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let menuInfo: MenuDatas
    let menuDate: String
}

struct esseferdeanilinerwidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        GeometryReader { g in
            VStack {
                if entry.menuDate == "Keine Daten gefunden" {
                    Text("Keinen Speiseplan gefunden").font(.headline).padding()
                } else {
                    Text("\(entry.menuDate)").font(.callout)
                    //   Text("\(g.size.height, specifier: "%.0f") * \(g.size.width, specifier: "%.0f")").font(.footnote)
                    //   Text("Aktualisierung: \(entry.date, style: .time)").font(.footnote)
                    //    Text(entry.providerInfo).font(.footnote)
                    ForEach(entry.menuInfo) { menu in
                        if menu.dishLine != "SideDishes" {
                            HStack {
                                Text("\(menu.dishName)").font(.system(size: g.size.height >= g.size.width ? g.size.width * 0.068: g.size.width * 0.045))
                                Spacer()
                                Text("\(menu.priceInt, specifier: "%.2f")").font(.system(size: g.size.height >= g.size.width ? g.size.width * 0.06: g.size.width * 0.04))
                            }.padding(.horizontal,5)
                        }
                        
                    }
                }
               
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
        }
    }
}

struct esseferdeanilinerwidget: Widget {
    let kind: String = "esseferdeanilinerwidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            esseferdeanilinerwidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Esse fer de Aniliner")
        .description("Deine Kantine direkt auf dem Homescreen")
        .contentMarginsDisabled()
    }
}

struct esseferdeanilinerwidget_Previews: PreviewProvider {
    static var previews: some View {
        esseferdeanilinerwidgetEntryView(entry: SimpleEntry(date: Date(), menuInfo: [MenuData()], menuDate: "Heute"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
