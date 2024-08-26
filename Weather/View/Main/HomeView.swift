//
//  HomeView.swift
//  Weather
//
//  Created by Kritchanat on 26/8/2567 BE.
//

import SwiftUI

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83 // 702/844
    case middle = 0.385 // 325/844
}

struct HomeView: View {
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @State private var showNewScreen: Bool = false

    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                let imageOffset = screenHeight + 36
                
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    Image("House")
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 250)
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                        Text("Montreal")
                            .font(.largeTitle)
                        
                        VStack {
                            Text(attributedString)
                            
                            Text("H:24°   L:18°")
                                .font(.title3.weight(.semibold))
                                .opacity(1 - bottomSheetTranslationProrated)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.top, 20)
                    .offset(y: -bottomSheetTranslationProrated * 36)
                    
                    
                    VStack {
                        Spacer()

                        ForecastView(bottomSheetTranslationProrated: bottomSheetTranslation)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .frame(height: 1000)
                            .padding(.top, 460)
                            .cornerRadius(10)
                    }
                    
    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            if bottomSheetPosition == BottomSheetPosition.top {
                                hasDragged = true
                            } else {
                                hasDragged = false
                            }
                        }
                    }) {
                        // Button content, if needed
                    }
                    
                    NewScreen(showNewScreen: $showNewScreen)
                        .padding(.top, 0)
                        .offset(y: showNewScreen ? 0 : UIScreen.main.bounds.height)
                        .animation(.spring())
                    
                    TabBar(action: {
                        showNewScreen.toggle()
                    })
                    .offset(y: bottomSheetTranslationProrated * 115)
                    .padding(.top, 710)
                }
            }
            .navigationBarHidden(true)
            
            
        }
    }
    
    private var attributedString: AttributedString {
        var string = AttributedString("19°" + (hasDragged ? " | " : "\n ") + "Mostly Clear")
        
        if let temp = string.range(of: "19°") {
            string[temp].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))), weight: hasDragged ? .semibold : .thin)
            string[temp].foregroundColor = hasDragged ? .secondary : .white
        }
        
        if let pipe = string.range(of: " | ") {
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .white.opacity(bottomSheetTranslationProrated)
        }
        
        if let weather = string.range(of: "Mostly Clear") {
            string[weather].font = .title3.weight(.semibold)
            string[weather].foregroundColor = .secondary
        }
        
        return string
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}

struct NewScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showNewScreen: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForecastView2()
                .background(Color.bottomSheetBackground)
                .cornerRadius(40)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                
            })
        }
    }
}
