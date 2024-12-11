//
//  DetailView.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject  var model: Model
    var menu: MenuData
    var body: some View {
        let additivesBinding: Binding<String> = Binding(
            get: {
                model.getConfig(key: self.menu.additiveAndAllergen, type: .additives, lineBreak: true)
            },
            set: { _ in  }
        )
        let allergenesBinding: Binding<String> = Binding(
            get: {
                model.getConfig(key: self.menu.additiveAndAllergen, type: .allergens, lineBreak: true)
            },
            set: { _ in  }
        )
        
        ScrollView {
            VStack {
                HStack {
                    Text("\(menu.dishName)").font(.body).multilineTextAlignment(.leading)
                        .foregroundStyle(.black)
                }.padding(5).background(Rectangle().fill(headlineBackground).shadow(radius: 3).cornerRadius(10))
                HStack {
                    Spacer()
                    Text("\(menu.priceInt, specifier: "%.2f") EUR")
                    Text("(\(menu.priceEXT ?? 0.0, specifier: "%.2f") EUR)").font(.footnote)
                }
                .padding(.bottom)
                Text("\(menu.foodCategory)").padding(.top,10)
                Text("\(model.getConfig(key: menu.foodCategory, type: .meatTypes, lineBreak: false))").font(.footnote).padding(.bottom,10)
                // NavigationLink zur neuen Detailansicht
                NavigationLink(
                    destination: AllergenesView(allergenes: allergenesBinding, additives: additivesBinding),
                    label: {
                        Text("\(menu.additiveAndAllergen)")
                    }
                )
                if menu.decription != nil {
                    Text("\(menu.decription ?? "")")
                }
                HStack {
                    Text("\(menu.nutritionalInfo)").font(.footnote)
                    Spacer()
                }
                if menu.co2Footprint != "" {
                    HStack {
                        Text("CO2 Abdruck: \(menu.co2Footprint)g").font(.headline)
                        Spacer()
                    }
                }
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Text("Einstellungen")
                    }
                )
            }
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    @State static var menu = MenuData()
    static var previews: some View {
        DetailView(menu: menu).environmentObject(Model())
    }
}
