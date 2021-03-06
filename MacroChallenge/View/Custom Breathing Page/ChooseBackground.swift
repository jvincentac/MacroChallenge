//
//  ChooseBackground.swift
//  MacroChallenge
//
//  Created by Vincent Alexander Christian on 17/11/20.
//

import SwiftUI

struct BackgroundAssetList {
    static let assetList: [String] = ["forest","lake"]
}

struct ChooseBackground: View {
    @FetchRequest(fetchRequest: Breathing.getAllBreathing()) var breaths: FetchedResults<Breathing>
    @Environment(\.managedObjectContext) var manageObjectContext
    @EnvironmentObject var navPop: NavigationPopObject
    @Binding var isChooseBackground: Bool
    @Binding var currBackground: String
    @State var idx = 0
    var playLooping = LoopingPlayer()
    @State var isForest = true
    @State var hitam = true
    
    var body: some View {
        ZStack {
            playLooping
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        self.isChooseBackground = false
                    }, label: {
                        Text("Cancel")
                            .font(Font.custom("Poppins-Medium", size: 17, relativeTo: .body))
                            .foregroundColor(hitam ? Color.black : Color.white)
                            .padding(5)
                    })
                    Spacer()
                    Text("Select Ambience")
                        .font(Font.custom("Poppins-SemiBold", size: 18, relativeTo: .body))
                        .foregroundColor(hitam ? Color.black : Color.white)
                        .padding(5)
                    Spacer()
                    Button(action: {
                        if idx == 0{
                            navPop.black2 = false
                        }else{
                            navPop.black2 = true
                        }
                        saveBackground()
                        self.isChooseBackground = false
                    }, label: {
                        Text("Save")
                            .font(Font.custom("Poppins-Medium", size: 17, relativeTo: .body))
                            .foregroundColor(hitam ? Color.black : Color.white)
                            .padding(5)
                    })
                    
                }
                .padding(.bottom, 80)
                .frame(width: ScreenSize.windowWidth() * 0.9)
                
                
                Spacer()
                    .frame(width: 100, height: 0.6 * UIScreen.main.bounds.height)
                
                HStack {
                    Button(action: {
                        hitam = false
                        if idx != 0 {
                            idx -= 1
                        }
                        playLooping.player.moveBackground(name: "\(BackgroundAssetList.assetList[idx])")
                        isForest = true
                    }, label: {
                        ZStack {
                            Image("forest_img")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                
                        }
                    })
                    
                    Spacer()
                        .frame(width: 100)
                    
                    Button(action: {
                        hitam = true
                        if idx != BackgroundAssetList.assetList.count - 1 {
                            idx += 1
                        }
                        playLooping.player.moveBackground(name: "\(BackgroundAssetList.assetList[idx])")
                        isForest = false
                    }, label: {
                        ZStack {
                            Image("lake_img")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                
                        }
                    })
                }
                .padding(.top, 50)
            }
        }
        .onAppear() {
            checkBackground()
        }
    }
}

extension ChooseBackground {
    func checkBackground() {
        if self.currBackground == "forest" {
            hitam = false
            self.isForest = true
            self.playLooping.player.moveBackground(name: "forest")
        }
        else {
            hitam = true
            self.isForest = false
            self.playLooping.player.moveBackground(name: "lake")
        }
    }
    
    func saveBackground() {
        navPop.playLooping.player.moveBackground(name: String(BackgroundAssetList.assetList[idx]))
        self.currBackground = BackgroundAssetList.assetList[idx]
    }
}

struct ChooseBackground_Previews: PreviewProvider {
    @State static var isChooseBackground = true
    @State static var currBackground = "forest"
    static var previews: some View {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        ChooseBackground(isChooseBackground: $isChooseBackground, currBackground: $currBackground)
            .environment(\.managedObjectContext, viewContext)
            .environmentObject(NavigationPopObject())
    }
}
