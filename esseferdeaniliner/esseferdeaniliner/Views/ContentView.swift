//
//  ContentView.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI
import IntentsUI

struct ContentView: View {
    @EnvironmentObject  var model: Model
    @State var isSettingVisible = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("\(model.getCanteenName())").font(.title)
                    Spacer()
                    Button {
                        self.isSettingVisible = true
                    } label: {
                        Image(systemName: "gearshape.fill").font(.title)
                    }
                }.padding(.horizontal)
                if $model.menus.count > 0 {
                    List(model.menusList) { menuList in
                        Section(header: Text("\(menuList.dateUI)")) {
                            ForEach(menuList.menuData) { menu in
                                if !(menu.hasGluten == true && model.noGluten == true) {
                                    NavigationLink(destination: DetailView( menu: menu )) {
                                        VStack {
                                             HStack {
                                                Text("\(menu.dishName)")
                                                Spacer()
                                                Text("\(menu.priceInt, specifier: "%.2f")").font(.caption)
                                            }
                                            if model.showAllergenes == true {
                                                HStack {
                                                    Text("\(menu.additiveAndAllergen)").font(.footnote)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }.refreshable {
                        Task {
                            await model.readData()
                        }
                    }
                }
                Spacer()
                Text("Made with ❤️ in SwiftUI by Dirk v \(VERSION) (\(BUILD))").font(.footnote)
            }.sheet(isPresented: $isSettingVisible) {
                SettingsView(isPresented: $isSettingVisible).presentationDragIndicator(.visible)
            }
           
        }.onAppear(perform: {
            Task {
                await model.readData()
            }
        })
    }
    private func setMenu(menu: MenuData) {
        print("function called")
        model.menu = menu
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Model())
    }
}
