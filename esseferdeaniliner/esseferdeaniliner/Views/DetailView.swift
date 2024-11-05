//
//  DetailView.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    @EnvironmentObject  var model: Model
    @State private var showAllergenes = false
    @State private var dishImage = UIImage(named: "Empty")!
    @State private var loadedLastImage = ""
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
        
        VStack {
            VStack {
                HStack {
                    Text("\(menu.dishName)").font(.title2).padding()
                    Spacer()
                }.background(Rectangle().fill(headlineBackground).shadow(radius: 3).cornerRadius(10))
                HStack {
                    Spacer()
                    Text("\(menu.priceInt, specifier: "%.2f") EUR")
                    Text("(\(menu.priceEXT ?? 0.0, specifier: "%.2f") EUR)").font(.footnote)
                }
                .padding(.bottom)
                if menu.decription != nil {
                    Text("\(menu.decription ?? "")")
                }
                Spacer()
                if menu.dishImage != nil {
                    /*
                    WebImage(url: URL(string: "https://cafeteriaassetsp.blob.core.windows.net/images/\(menu.dishImage!)")).resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: 300, height: 300, alignment: .center)
                     */
               //     let _ = loadImage()
                    Image(uiImage: dishImage).resizable()   .scaledToFill()
                        .frame(width: 300, height: 300, alignment: .center)
                }
            }
            Spacer()
            VStack {
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
                Text("\(menu.foodCategory)").padding(.top,10)
                Text("\(model.getConfig(key: menu.foodCategory, type: .meatTypes, lineBreak: false))").font(.footnote).padding(.bottom,10)
                Text("\(menu.additiveAndAllergen)").onTapGesture {
                    showAllergenes.toggle()
                }.sheet(isPresented: $showAllergenes) {
                    AllergenesView(allergenes: allergenesBinding, additives: additivesBinding).presentationDragIndicator(.visible)
                }
            }

        }.padding().onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        if loadedLastImage != menu.dishImage && menu.dishImage != nil {
            loadedLastImage = menu.dishImage ?? ""
            Task {
                print("Started task in loadImage")
                self.dishImage = await menu.getDishImage()
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
