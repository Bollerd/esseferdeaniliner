//
//  AllergenesView.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI

struct AllergenesView: View {
    @Binding var allergenes: String
    @Binding var additives: String
    var body: some View {
        ScrollView {
            Text("Hinweis: Die Allergeninformationen beziehen sich auf die Zutaten der angebotenen Speisen. Spuren von unten genannten Allergenen sind trotz aller Sorgfalt im Großküchenbetrieb und bei Zulieferern nicht völlig ausgeschließen.").padding(.bottom).font(.headline)
            Text("Kennzeichnungspflichtige Allergene").font(.title2)
            Text("\(allergenes)").padding()
            Text("Kennzeichnungspflichtige Zusatzstoffe").font(.title2)
            Text("\(additives)").padding()
            Spacer()
            Text("Diese App ist keine offizielle App der Kantinenbetriebe. Die Allergene und Zusatzstoffe sind nicht online auswertbar und daher in dieser App ebenfalls hinterlegt. Sollten die Nummern der Allergene geändert werden, so müssen diese Informationen in dieser App nachträglich ebenfalls angepasst werden. Die Anzeige der Allergene und Zusatzstoffe ist daher ohne Gewähr").font(.footnote)
        }.padding()
    }
}

struct AllergenesView_Previews: PreviewProvider {
    @State static var allergenes = "Test"
    
    static var previews: some View {
        AllergenesView(allergenes: $allergenes, additives: $allergenes)
    }
}
