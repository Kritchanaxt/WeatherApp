//
//  ContentView.swift
//  Weather
//
//  Created by Kritchanat on 26/8/2567 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
