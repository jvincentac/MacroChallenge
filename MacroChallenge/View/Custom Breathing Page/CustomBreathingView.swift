//
//  CustomBreathingView.swift
//  MacroChallenge
//
//  Created by Kenji Surya Utama on 13/10/20.

import SwiftUI

struct CustomBreathingView: View {
    @State var breathName = ""
    @State var inhale = 0
    @State var hold1 = 0
    @State var exhale = 0
    @State var hold2 = 0
    @State var isSoundOn = false
    @State var isHapticOn = false
    @State var isFavorite = false
    
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().standardAppearance.shadowColor = .clear
//        UINavigationBar.appearance().scrollEdgeAppearance?.shadowColor = .clear
    }
    
    var body: some View {
        VStack {
            Precautions()
            InputName(breathName: $breathName)
            VStack {
                Text("Pattern (Seconds)")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(width: ScreenSize.windowWidth() * (331.5/375), height: 40, alignment: .leading)
                    .background(Color.blue)
                VStack {
                    HStack {
                        Text("Inhale")
                            .frame(width: ScreenSize.windowWidth() * (310/375)/4)
                        Text("Hold")
                            .frame(width: ScreenSize.windowWidth() * (310/375)/4)
                        Text("Exhale")
                            .frame(width: ScreenSize.windowWidth() * (310/375)/4)
                        Text("Hold")
                            .frame(width: ScreenSize.windowWidth() * (310/375)/4)
                    }
                    CustomBreathingViewPicker(inhaleSelection: $inhale, hold1Selection: $hold1, exhaleSelection: $exhale, hold2Selection: $hold2)
                        .frame(height: 250)

//                        .blur(radius : 0.2, opaque: false)
                }
            }
            .padding(.vertical)
            
            
            
            VStack {
                Text("Guiding Preferences")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(width: ScreenSize.windowWidth() * (331.5/375), height: 40, alignment: .leading)
                    .background(Color.black)
                    .offset(y: 20)
                GuidingPreferences(isSoundOn: $isSoundOn, isHapticOn: $isHapticOn, isFavorite: $isFavorite)
                    .background(Color.red)
                
            }
            .frame(width: 375, alignment: .leading)
//            .padding(.vertical)
//            .background(Color.white)
            
            
            
        }
//        .padding()
        .background(Image("ocean").blurBackgroundImageModifier())
        .navigationBarItems(trailing: CancelAddView(breathName: $breathName, inhale: $inhale, hold1: $hold1, exhale: $exhale, hold2: $hold2, isSoundOn: $isSoundOn, isHapticOn: $isHapticOn, isFavorite: $isFavorite))
        .frame(width : ScreenSize.windowWidth() * 0.9)
        .navigationBarTitle("Add Breathing",displayMode: .inline)
    }
}

struct Precautions: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: ScreenSize.windowWidth() * (327/375), height: ScreenSize.windowHeight() * (110/812))
                .cornerRadius(8)
                .foregroundColor(.init(red: 239/255, green: 239/255, blue: 244/255))
                .opacity(0.6)
                .blur(radius : 20, opaque : true)
            VStack(alignment: .leading) {
                Text("Precautions:")
                    .font(.system(size: 16, weight: .semibold, design: .default))
                Group {
                    Text("- Make sure that the breathing pattern is as")
                    Text("suggested as the experts")
                    Text("- It is better when the exhale is longer than the")
                    Text("inhale period")
                }
                .font(.system(size: 12, weight: .regular, design: .default))
            }
            .frame(width: ScreenSize.windowWidth() * (270/375), height: ScreenSize.windowHeight() * (103/812))
        }
    }
}

struct InputName: View {
    @Binding var breathName : String
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .frame(width: ScreenSize.windowWidth() * (327/375), height: ScreenSize.windowHeight() * (60/812))
                    .cornerRadius(8)
                    .foregroundColor(.init(red: 239/255, green: 239/255, blue: 244/255))
                HStack {
                    TextField("Name", text: $breathName)
                        .frame(width: ScreenSize.windowWidth() * (300/375), height: ScreenSize.windowHeight() * (40/812))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.breathName = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .frame(width: ScreenSize.windowWidth() * (15/375), height: ScreenSize.windowHeight() * (22/812))
                            .foregroundColor(.gray)
                            .padding()
                    })
                }
            }
            .padding(.horizontal, ScreenSize.windowWidth() * (50/375))
            Rectangle()
                .frame(width: ScreenSize.windowWidth() * (310/375), height: 0.5, alignment: .center)
                .foregroundColor(.gray)
                .padding(.vertical, -ScreenSize.windowWidth() * (15/375))
        }
    }
}



//Multi-Component picker, namanya doang keren isinya hanya Hstack + picker biasa
struct CustomBreathingViewPicker: View {
    @Binding var inhaleSelection : Int
    @Binding var hold1Selection : Int
    @Binding var exhaleSelection : Int
    @Binding var hold2Selection : Int
    
    var inhale = [Int](0..<11)
    var hold1 = [Int](0..<11)
    var exhale = [Int](0..<11)
    var hold2 = [Int](0..<11)
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(.init(red: 239/255, green: 239/255, blue: 244/255))
                .opacity(0.6)
                .blur(radius : 24, opaque : false)
            HStack {
                Picker("", selection: self.$inhaleSelection) {
                    ForEach(0..<self.inhale.count) { index in
                        Text("\(self.inhale[index])").tag(index)
                    }
                }
                .frame(width: ScreenSize.windowWidth() * (310/375)/4, height: 220, alignment: .center)
                .clipped()
                
                Picker("", selection: self.$hold1Selection) {
                    ForEach(0..<self.hold1.count) { index in
                        Text("\(self.hold1[index])").tag(index)
                    }
                }
                .frame(width: ScreenSize.windowWidth() * (310/375)/4, height: 220, alignment: .center)
                .clipped()
                
                Picker("", selection: self.$exhaleSelection) {
                    ForEach(0..<self.exhale.count) { index in
                        Text("\(self.exhale[index])").tag(index)
                    }
                }
                .frame(width: ScreenSize.windowWidth() * (310/375)/4, height: 220, alignment: .center)
                .clipped()
                
                Picker("", selection: self.$hold2Selection) {
                    ForEach(0..<self.hold2.count) { index in
                        Text("\(self.hold2[index])").tag(index)
                    }
                }
                .frame(width: ScreenSize.windowWidth() * (310/375)/4, height: 220, alignment: .center)
                .clipped()
            }
        }
    }
}

struct GuidingPreferences: View {
    @Binding var isSoundOn: Bool
    @Binding var isHapticOn: Bool
    @Binding var isFavorite: Bool
    var body: some View {
        VStack{
            Toggle(isOn: $isSoundOn, label: {
                Text("Sound")
            })
            .padding(.horizontal)
            
            Toggle(isOn: $isHapticOn, label: {
                Text("Haptic")
            })
            .padding(.horizontal)
            
            Toggle(isOn: $isFavorite) {
                Text("Favorite")
            }
            .padding(.horizontal)
        }
        
    }
}



struct CancelAddView: View {
    //pake ini untuk save ke core data
    @Environment(\.managedObjectContext) var manageObjectContext
    
    @Binding var breathName : String
    @Binding var inhale : Int
    @Binding var hold1 : Int
    @Binding var exhale : Int
    @Binding var hold2 : Int
    @Binding var isSoundOn : Bool
    @Binding var isHapticOn : Bool
    @Binding var isFavorite : Bool
    
    var body: some View {
        Button(action: {
            saveToCoreData()
            
        }, label: {
            Text("Add")
        })
    }
}

extension CancelAddView {
    func saveToCoreData() {
        let breath = Breathing(context: self.manageObjectContext)
        breath.name = breathName
        breath.inhale = Int16(inhale)
        breath.hold1 = Int16(hold1)
        breath.exhale = Int16(exhale)
        breath.hold2 = Int16(hold2)
        breath.sound = isSoundOn
        breath.haptic = isHapticOn
        breath.id = UUID()
        breath.favorite = isFavorite
        
        do{
            //save ke core data
            try self.manageObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct CustomBreathingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBreathingView()
    }
}
