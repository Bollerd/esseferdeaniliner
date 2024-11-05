//
//  SettingsView.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: Model
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            Text("Einstellungen").font(.largeTitle).padding(.bottom)
            HStack {
                Text("Kantine")
                Spacer()
                Picker("Kantine", selection: $model.canteen){
                    ForEach(model.canteenList, id: \.cafeteriaID) { canteen in
                        Text("\(canteen.cafeteriaName)")
                    }
                }.pickerStyle(.automatic)
               

            }
            HStack {
                Toggle(isOn: $model.showAllergenes) {
                    Text("Allergene in Übersicht anzeigen")
                }
            }
            VStack {
                Text("Auszublendende Allergene").font(.title2)
                HStack {
                    Toggle(isOn: $model.noGluten) {
                        Text("Gluten in Übersicht ausblenden")
                    }
                }
                HStack {
                    Toggle(isOn: $model.noSoya) {
                        Text("Soja in Übersicht ausblenden")
                    }
                }
                HStack {
                    Toggle(isOn: $model.noSweeteners) {
                        Text("Süßungsmittel in Übersicht ausblenden")
                    }
                }
                HStack {
                    Toggle(isOn: $model.noNuts) {
                        Text("Nüsse und Schalenfrüchte in Übersicht ausblenden")
                    }
                }
            }.padding(.bottom,30)
            Button("Neu laden") {
                Task {
                    await model.readData()
                    isPresented = false
                }
                
            }.buttonStyle(.borderedProminent)
            Spacer()
        }.padding().onAppear {
            print(model.canteenList.count)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        SettingsView(isPresented: $isPresented).environmentObject(Model())
    }
}
