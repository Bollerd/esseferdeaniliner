//
//  ConfigDataCore.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 09.12.2024.
//

import SwiftUI

class MenuDataBase: Codable, Identifiable {
    let id = UUID()
    let dishItemID: Int
    let dishName, dishLine, foodCategory: String
    let decription: String?
    let priceInt: Double
    let priceIntCur: String
    let priceEXT: Double?
    var additiveAllergen: String?
    let nutritionalInfo: String
    let menuDate: String
    let dishImage: String?
    
    var additiveAndAllergen: String {
        get {
            return additiveAllergen ?? ""
        }
    }
    
    var co2Footprint: String {
        get {
            let parts = nutritionalInfo.components(separatedBy: "|")
            var returnValue = ""
            for part in parts {
                let trimmed = part.trimmingCharacters(in: .whitespaces)
                if trimmed.prefix(3) == "CO2" {
                    returnValue = String(trimmed.suffix(trimmed.count - 3))
                }
            }
            return returnValue
        }
    }
    
    var hasGluten: Bool {
        return containsAdditive(["30", "51", "52", "53", "54"])
    }
    
    var hasNuts: Bool {
        return containsAdditive(["37", "61", "62", "63", "64", "65", "66", "67", "68", "34"])
    }
    
    var hasSoya: Bool {
        return containsAdditive(["35"])
    }
    
    var hasSweeteners: Bool {
        return containsAdditive(["4", "4a", "4b"])
    }
    
    private func containsAdditive(_ additives: [String]) -> Bool {
        return additives.contains { additiveAndAllergen.contains($0) }
    }

    enum CodingKeys: String, CodingKey {
        case dishItemID, dishName, dishLine, foodCategory, decription, priceInt, priceIntCur, dishImage
        case priceEXT = "priceExt"
        case additiveAllergen, nutritionalInfo, menuDate
    }
    
    // Der 'required' Initialisierer für das Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dishItemID = try container.decode(Int.self, forKey: .dishItemID)
        self.dishName = try container.decode(String.self, forKey: .dishName)
        self.dishLine = try container.decode(String.self, forKey: .dishLine)
        self.foodCategory = try container.decode(String.self, forKey: .foodCategory)
        self.decription = try? container.decode(String.self, forKey: .decription)
        self.priceInt = try container.decode(Double.self, forKey: .priceInt)
        self.priceIntCur = try container.decode(String.self, forKey: .priceIntCur)
        self.priceEXT = try? container.decode(Double.self, forKey: .priceEXT)
        self.additiveAllergen = try? container.decode(String.self, forKey: .additiveAllergen)
        self.nutritionalInfo = try container.decode(String.self, forKey: .nutritionalInfo)
        self.menuDate = try container.decode(String.self, forKey: .menuDate)
        self.dishImage = try container.decode(String.self, forKey: .dishImage)
    }
    
    // Standard Initialisierer
    init(dishItemID: Int, dishName: String, dishLine: String, foodCategory: String, decription: String?, priceInt: Double, priceIntCur: String, priceEXT: Double?, additiveAllergen: String?, nutritionalInfo: String, menuDate: String, dishImage: String?) {
        self.dishItemID = dishItemID
        self.dishName = dishName
        self.dishLine = dishLine
        self.foodCategory = foodCategory
        self.decription = decription
        self.priceInt = priceInt
        self.priceIntCur = priceIntCur
        self.priceEXT = priceEXT
        self.additiveAllergen = additiveAllergen
        self.nutritionalInfo = nutritionalInfo
        self.menuDate = menuDate
        self.dishImage = dishImage
    }
}

class MenuDataCore: MenuDataBase {
    
    // Benutzerdefinierter Initialisierer
    init() {
        super.init(dishItemID: 1,
                   dishName: "Currywurst mit Pommes",
                   dishLine: "",
                   foodCategory: "S",
                   decription: "Fresh fruit with worms",
                   priceInt: 5.0,
                   priceIntCur: "",
                   priceEXT: 8.5,
                   additiveAllergen: "30, 32, 51",
                   nutritionalInfo: "Ernährungsinfo |CO22300",
                   menuDate: "",
                   dishImage: nil
        )
    }
    
    // 'required' init(from:) muss hier auch implementiert werden
    required init(from decoder: Decoder) throws {
        // Der Initialisierer der Basisklasse wird aufgerufen
        try super.init(from: decoder)
    }
}

// MARK: - ConfigDatum
struct ConfigDatum: Codable {
    let key, value: String
    let checkFlag: Int
    let type: TypeEnum
    let lang: Lang
    
    init() {
        key = ""
        value = ""
        checkFlag = 0
        type = .vege
        lang = .de
    }
}

enum Lang: String, Codable {
    case de = "de"
    case en = "en"
}

enum TypeEnum: String, Codable {
    case additives = "additives"
    case allergens = "allergens"
    case meatTypes = "meatTypes"
    case vege = "vege"
}

typealias ConfigData = [ConfigDatum]

// MARK: - CafeteriaDatum
struct CafeteriaDatum: Codable, Identifiable {
    let id = UUID()
    let cafeteriaID, cafeteriaName, cafeteriaNameDe, additionalInfoEn: String
    let additionalInfoDe, cafeteriaImage, cafeteriaLocation, cafeteriaOpeningHour: String
    let cafeteriaClosingHour, mapImage: String
    let noOfRatedUsers, avgRating: Int?
    let isDeleted: String
    let cafeteriaShowWeeklyMenu: Bool
    let popularTimings: [PopularTiming]
    
    enum CodingKeys: String, CodingKey {
        case cafeteriaID = "cafeteriaId"
        case cafeteriaName, cafeteriaNameDe
        case additionalInfoEn = "additionalInfo_en"
        case additionalInfoDe = "additionalInfo_de"
        case cafeteriaImage, cafeteriaLocation, cafeteriaOpeningHour, cafeteriaClosingHour, mapImage, noOfRatedUsers, avgRating, isDeleted, cafeteriaShowWeeklyMenu, popularTimings
    }
    
    init() {
        self.cafeteriaID = ""
        self.cafeteriaName = ""
        self.cafeteriaNameDe = ""
        self.additionalInfoEn = ""
        self.additionalInfoDe = ""
        self.cafeteriaImage = ""
        self.cafeteriaLocation = ""
        self.cafeteriaOpeningHour = ""
        self.cafeteriaClosingHour = ""
        self.mapImage = ""
        self.noOfRatedUsers = 0
        self.avgRating = 0
        self.isDeleted = ""
        self.cafeteriaShowWeeklyMenu = false
        self.popularTimings = [PopularTiming()]
    }
}

// MARK: - PopularTiming
struct PopularTiming: Codable {
    let popularTime: String
    let occPercenatge: Int
    
    init() {
        self.popularTime = ""
        self.occPercenatge = 0
    }
}

typealias CafeteriaData = [CafeteriaDatum]
