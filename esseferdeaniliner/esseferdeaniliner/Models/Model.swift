//
//  Model.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI
import AppIntents

struct MenuDataList: Identifiable {
    let id = UUID()
    var menuData: MenuDatas
    var date: String
    var dateUI: String
    var widgetData: String {
        get {
            var returnValue = ""
            
            if menuData.count == 0 {
                return returnValue
            }
            
            for menu in menuData {
                if returnValue == "" {
                    returnValue = menu.dishName
                } else {
                    returnValue += "\n" + menu.dishName
                }
            }
            
            return returnValue
        }
    }
}

struct SiriIntent: AppIntent {
    static let title: LocalizedStringResource = "Was gibt es heute in der Kantine?"
    
    func perform() async throws -> some ReturnsValue<String> & ProvidesDialog {//IntentResult & ReturnsValue<String> {//some ReturnsValue & ProvidesDialog {
        let model = Model()
        await model.readData()
        let siriResponse = model.getCanteenMenuForSiri()
        return .result(
            value: siriResponse,
            dialog: "\(siriResponse)"
        )
    }
}

struct AppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SiriIntent(),
            phrases: ["Was gibt es in der Kantine?",
                      "Was kann ich heute essen?"]
        )
    }
}

class Model: ObservableObject {
    @AppStorage("canteen") var canteen = "CAF8"
    @AppStorage("showAllergenes") var showAllergenes = false
    @AppStorage("noGluten") var noGluten = false
    @AppStorage("noNuts") var noNuts = false
    @AppStorage("noSoya") var noSoya = false
    @AppStorage("noSweeteners") var noSweeteners = false
    @AppStorage("notification") var sendNotification = false
    @Published var updateUI = false
    @Published var menu = MenuData()
    @Published var menus = [MenuData()]
    @Published var menusList = [MenuDataList(menuData: [MenuData()], date: "", dateUI: "")]
    @Published var canteenList: CafeteriaData = [CafeteriaDatum()]
    private var config: ConfigData = [ConfigDatum()]
    init() {
       // readAdditionalData()
        Task {
            await readAdditionalDataRemote()
            await readCanteenData()
        }
    }
    
    func readAdditionalData() {
        guard let fileUrlSConfig = Bundle.main.url(forResource: "basfgastroconfig", withExtension: "json") else {
            return
        }
        do {
            let contentConfig = try String(contentsOf: fileUrlSConfig)
            let config  = try JSONDecoder().decode(ConfigData.self, from: Data(contentConfig.utf8))
            self.config = config
        } catch {
            print(error)
        }
    }
    
    func readAdditionalDataRemote() async {
        guard let url = URL(string: "https://ios.dbweb.info/apps/basfgastroconfig.json") else {
            fatalError("Invalid url")
        }
        let urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error retrieving additioal data")
            }
            
            let config = try JSONDecoder().decode(ConfigData.self, from: data)
            self.config = config
           
        } catch {
            print(error)
        }
    }
    
    func getFormattedDate(date: Date, format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if Calendar.current.component(.month,  from: date) == 1 && Calendar.current.component(.day,  from: date) == 1 {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        return dateFormatter.string(from: date)
    }
    
    func dayAfter(date: Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date)!)!
    }
    
    func readCanteenData()  async {
        self.canteenList.removeAll(keepingCapacity: false)
        let locationUrls = ["https://gastronomy-app.basf.com/cafeteria/services/CafeteriasByLocation?location=DE%20-%20Ludwigshafen","https://gastronomy-app.basf.com/cafeteria/services/CafeteriasByLocation?location=DE%20-%20Lampertheim","https://gastronomy-app.basf.com/cafeteria/services/CafeteriasByLocation?location=DE%20-%20Limburgerhof"]
        for location in locationUrls {
            guard let url = URL(string: location) else {
                fatalError("Invalid url")
            }
            let urlRequest = URLRequest(url: url)
            do {
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    fatalError("Error retrieving canteen data")
                }
                
                let canteens = try JSONDecoder().decode(CafeteriaData.self, from: data)
                self.canteenList.append(contentsOf: canteens)
                DispatchQueue.main.async {
                    self.updateUI.toggle()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func readData()  async {
        var today = Date()
        self.menusList.removeAll(keepingCapacity: false)
        for i in 1...7 {
            let dateString = self.getFormattedDate(date: today, format: "dd/MM/yyyy")
            let dateStringUI = today.formatted(Date.FormatStyle().weekday(.wide)) + " " + self.getFormattedDate(date: today, format: "dd.MM.yyyy")
            guard let url = URL(string: "https://gastronomy-app.basf.com/cafeteria/services/MenuData?cafeteriaId=\(self.canteen)&date=\(dateString)&language=de") else {
                fatalError("Invalid url")
            }
            let urlRequest = URLRequest(url: url)
            do {
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    fatalError("Error retrieving menu data")
                }
                
                print(String(decoding: data, as: UTF8.self))
                let menus = try JSONDecoder().decode(MenuDatas.self, from: data)
                let menuListRow = MenuDataList(menuData: menus, date: dateString, dateUI: dateStringUI)
                if i == 1 {
                    self.menus = menus
                }
                self.menusList.append(menuListRow)
                DispatchQueue.main.async {
                    self.updateUI.toggle()
                }
            } catch {
                print(error)
            }
            today = self.dayAfter(date: today)
        }
    }
    
    func displayNextDay(current: String) -> Bool {
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd.MM.yyyy"

        // Convert String to Date
        let inputDate = dateFormatter.date(from: current) ?? Date()
        
        let calendar = Calendar.current 
        let date = Date()
        
        let hour = calendar.component(.hour, from: date)
        let dayToday = calendar.component(.day, from: date)
        let dayInput = calendar.component(.day, from: inputDate)
            
        if hour >= 14 && dayToday == dayInput {
            return true
        } else {
            return false
        }
    }
    
    func getCanteenName() -> String {
        for c in self.canteenList {
            if c.cafeteriaID == self.canteen {
                return c.cafeteriaName
            }
        }
        return ""
    }
    
    func getConfig(key: String, type: TypeEnum, lineBreak: Bool) -> String {
        var returnValue = ""
        let keys = key.components(separatedBy: ",")
        
        for k in keys {
            let cleanedKey = k.trimmingCharacters(in: .whitespaces)
            for c in config {
                if c.lang == Lang.de && c.type == type && c.key == cleanedKey {
                    if returnValue != "" {
                        if lineBreak == true {
                            returnValue += "\n"
                        } else {
                            returnValue += ", "
                        }
                    }
                    returnValue = returnValue + k + " = " + c.value
                }
            }
        }
        
        return returnValue
    }
    
    func getCanteenMenuForSiri() -> String {
        if menusList.count == 0 {
            return "Keine Daten gefunden"
        }
        
        var menu = menusList[0]
        
        if menusList.count > 1 && displayNextDay(current: menu.date) {
            menu = menusList[1]
        }
        
        var retVal = "Ich konnte für \(menu.dateUI) folgende Essen finden: "
        
        for i in 1...menu.menuData.count {
            let data = menu.menuData[i-1]
            
            let price = String.localizedStringWithFormat("%.2f %@", data.priceInt, "EUR")
            switch i {
            case 1:
                retVal += "\(data.dishName) für \(price)"
            case menu.menuData.count:
                retVal += " sowie \(data.dishName) für \(price)"
            default:
                retVal += ", \(data.dishName) für \(price)"
            }
        }
        
        return retVal
    }
}
