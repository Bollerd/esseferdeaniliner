//
//  esseferdeanilinerApp.swift
//  esseferdeaniliner
//
//  Created by Dirk Boller on 01.09.23.
//

import SwiftUI

@main
struct esseferdeanilinerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Model())
        }
    }
}
