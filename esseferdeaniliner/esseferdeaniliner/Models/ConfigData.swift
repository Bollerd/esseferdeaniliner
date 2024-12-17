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
        return UIImage(imageLiteralResourceName: "Empty")
    }
    
    func getDishImage() async -> UIImage {
        var image = UIImage(imageLiteralResourceName: "Empty")
        
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

