//
//  SettingsView.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        ScrollView {
            Text("Einstellungen").font(.title3).padding(.bottom)
            VStack {
                //Text("Kantine")
                Picker("Kantine", selection: $model.canteen){
                    ForEach(model.canteenList, id: \.cafeteriaID) { canteen in
                        Text("\(canteen.cafeteriaName)")
                    }
                }  // Hier kannst du den Stil festlegen
                .frame(height: 50)
                    .font(.footnote)// Optional für Anpassung des Layouts
                    .padding()
                Toggle(isOn: $model.showAllergenes) {
                    Text("Allergene in Übersicht anzeigen")
                }
            
                Text("Auszublendende Allergene").font(.title3)
            
                    Toggle(isOn: $model.noGluten) {
                        Text("Gluten in Übersicht ausblenden")
                    }
               
                    Toggle(isOn: $model.noSoya) {
                        Text("Soja in Übersicht ausblenden")
                    }
                
                    Toggle(isOn: $model.noSweeteners) {
                        Text("Süßungsmittel in Übersicht ausblenden")
                    }
                
                    Toggle(isOn: $model.noNuts) {
                        Text("Nüsse und Schalenfrüchte in Übersicht ausblenden")
                    }
                
            }.padding(.bottom,20)
            Button("Neu laden") {
                Task {
                    await model.readData()
                }
            }.buttonStyle(.borderedProminent)
            Spacer()
        }.padding().onAppear {
            print(model.canteenList.count)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(Model())
    }
}
