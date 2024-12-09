//
//  ConfigData.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//
//  Generated Wrappercodings from quicktype.io

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI



// MARK: - generated Wrappercode from quicktype.io#
/*
class MenuData: Codable, Identifiable {
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
            if additiveAllergen == nil {
                return ""
            } else {
                return additiveAllergen!
            }
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
        get {
            if additiveAndAllergen.contains("30") || additiveAndAllergen.contains("51") || additiveAndAllergen.contains("52") || additiveAndAllergen.contains("53") || additiveAndAllergen.contains("54") {
                return true
            } else {
                return false
            }
            
        }
    }
    var hasNuts: Bool {
        get {
            if additiveAndAllergen.contains("37") || additiveAndAllergen.contains("61") || additiveAndAllergen.contains("62") || additiveAndAllergen.contains("63") || additiveAndAllergen.contains("64") || additiveAndAllergen.contains("65") || additiveAndAllergen.contains("66") || additiveAndAllergen.contains("67") || additiveAndAllergen.contains("68") || additiveAndAllergen.contains("34") {
                return true
            } else {
                return false
            }
        }
    }
    var hasSoya: Bool {
        get {
            if additiveAndAllergen.contains("35") {
                return true
            } else {
                return false
            }
        }
    }
    var hasSweeteners: Bool {
        get {
            if additiveAndAllergen.contains("4") || additiveAndAllergen.contains("4a") || additiveAndAllergen.contains("4b") {
                return true
            } else {
                return false
            }
        }
    }
    enum CodingKeys: String, CodingKey {
        case dishItemID, dishName, dishLine, foodCategory, decription, priceInt, priceIntCur
        case priceEXT = "priceExt"
        case additiveAllergen, nutritionalInfo, menuDate, dishImage
    }
    
    init() {
        dishItemID = 1
        dishName = "Currywurst mit Pommes"
        dishLine = ""
        foodCategory = "S"
        decription = "Fresh fruit with worms"
        priceInt = 5.0
        priceIntCur = ""
        priceEXT = 8.5
        additiveAllergen = "30, 32, 51"
        nutritionalInfo = "Ernährungsinfo |CO22300"
        menuDate = ""
        dishImage = nil
    }
    
    func getDishUIImage() -> UIImage {
        return UIImage(imageLiteralResourceName: "Pamo")
    }
    
    func getDishImage() async -> UIImage {
        var image = UIImage(imageLiteralResourceName: "Pamo")
        
        if dishImage == nil {
            return image
        }
        guard let url = URL(string: "https://cafeteriaassetsp.blob.core.windows.net/images/\(dishImage!)") else {
            fatalError("Invalid url")
        }
        let urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error retrieving canteen data")
            }
            
            let uiImage = UIImage(data: data)
            
            let currentFilter = CIFilter.pixellate()//crystallize()//comicEffect()//pixellate()
            //  let filterIntensity = 1.0
            let context = CIContext()
            let beginImage = CIImage(image: (uiImage ?? image)!)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            //   currentFilter.radius = 10
            currentFilter.scale = 5
            //  currentFilter.intensity = Float(filterIntensity)
            
            guard let outputImage = currentFilter.outputImage else { return image }
            
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                image = UIImage(cgImage: cgimg)
            } else {
                return image
            }
        } catch {
            print(error)
        }
        print("leaving getDishImage")
        return image
    }
}
*/
class MenuData: MenuDataBase {
    
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
    
    func getDishUIImage() -> UIImage {
        return UIImage(imageLiteralResourceName: "Pamo")
    }
    
    func getDishImage() async -> UIImage {
        var image = UIImage(imageLiteralResourceName: "Pamo")
        
        if dishImage == nil {
            return image
        }
        
        guard let url = URL(string: "https://cafeteriaassetsp.blob.core.windows.net/images/\(dishImage!)") else {
            fatalError("Invalid url")
        }
        
        let urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error retrieving canteen data")
            }
            
            let uiImage = UIImage(data: data)
            let currentFilter = CIFilter.pixellate()
            let context = CIContext()
            let beginImage = CIImage(image: uiImage ?? image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.scale = 5
            
            guard let outputImage = currentFilter.outputImage else { return image }
            
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                image = UIImage(cgImage: cgimg)
            } else {
                return image
            }
        } catch {
            print(error)
        }
        return image
    }
}

typealias MenuDatas = [MenuData]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

/*
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
*/

// MARK: - CafeteriaDatum
/*
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
*/
