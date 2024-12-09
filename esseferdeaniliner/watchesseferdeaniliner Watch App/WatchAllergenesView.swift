//
//  WatchAllergenesView.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 09.12.2024.
//
import SwiftUI

struct AllergenesView: View {
    @Binding var allergenes: String
    @Binding var additives: String
    var body: some View {
        ScrollView {
            Text("Kennzeichnungspflichtige Allergene").font(.title3)
            Text("\(allergenes)")
            Text("Kennzeichnungspflichtige Zusatzstoffe").font(.title3).padding(.vertical)
            Text("\(additives)")
        }.padding()
    }
}

struct AllergenesView_Previews: PreviewProvider {
    @State static var allergenes = "Test"
    
    static var previews: some View {
        AllergenesView(allergenes: $allergenes, additives: $allergenes)
    }
}
