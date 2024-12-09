//
//  ContentView.swift
//  watchesseferdeaniliner Watch App
//
//  Created by Dirk Boller on 07.12.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject  var model: Model
    @State var isSettingVisible = false
    var body: some View {
        NavigationView {
            VStack {
                if $model.menus.count > 0 {
                    List(model.menusList) { menuList in
                        Section(header: Text("\(menuList.dateUI)")) {
                            ForEach(menuList.menuData) { menu in
                                if !(menu.hasGluten == true && model.noGluten == true) {
                                    NavigationLink(destination: DetailView( menu: menu )) {
                                        VStack {
                                             HStack {
                                                Text("\(menu.dishName)")
                                            
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
            }
        }.onAppear(perform: {
            Task {
                await model.readData()
            }
        })
    }
    
}

#Preview {
    ContentView()
}
