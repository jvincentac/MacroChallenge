//
//  CustomBreathingView.swift
//  MacroChallenge
//
//  Created by Kenji Surya Utama on 13/10/20.

import SwiftUI




struct CustomBreathingView: View {
    
    @State var breathName = ""
    @State var inhale = 2
    @State var hold1 = 0
    @State var exhale = 2
    @State var hold2 = 0
    @State var isSoundOn = false
    @State var isHapticOn = false
    @State var isFavorite = false
    @EnvironmentObject var navPop : NavigationPopObject
    @Environment(\.managedObjectContext) var manageObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var attempts: Int = 0
    @State var background = "forest"
    @State var id: UUID?
    @State var isChooseBackground = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack (spacing : 16) {
                        Precautions()
                            .padding(.top, 16)
                        InputName(breathName: $breathName)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                        VStack {
                            Group {
                                Text("Pattern - in seconds")
                                    .font(Font.custom("Poppins-SemiBold", size: 16, relativeTo: .body))
                                    .padding()
                                    .frame(width: ScreenSize.windowWidth() * 0.9, height: ScreenSize.windowHeight() * 0.054, alignment: .leading)
                                    .background(SomeBackground.headerBackground())
                                ZStack {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .background(Blur(style: .systemThinMaterial)
                                                        .opacity(0.95))
                                        .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                                    VStack {
                                        HStack {
                                            Text("Inhale")
                                                .font(Font.custom("Poppins-Light", size: 15, relativeTo: .body))
                                                .frame(width: ScreenSize.windowWidth() * 0.2075)
                                            Text("Hold")
                                                .font(Font.custom("Poppins-Light", size: 15, relativeTo: .body))
                                                .frame(width: ScreenSize.windowWidth() * 0.2075)
                                            Text("Exhale")
                                                .font(Font.custom("Poppins-Light", size: 15, relativeTo: .body))
                                                .frame(width: ScreenSize.windowWidth() * 0.2075)
                                            Text("Hold")
                                                .font(Font.custom("Poppins-Light", size: 15, relativeTo: .body))
                                                .frame(width: ScreenSize.windowWidth() * 0.2075)
                                            
                                        }.padding(.top)
                                        CustomBreathingViewPicker(inhaleSelection: $inhale, hold1Selection: $hold1, exhaleSelection: $exhale, hold2Selection: $hold2)
                                            .frame(height: (226-40))
                                    }
                                }
                                .frame(height: (215))
                            }
                        }
                        
                        VStack (spacing : 0) {
                            Text("Guiding Preferences")
                                .font(Font.custom("Poppins-SemiBold", size: 16, relativeTo: .body))
                                .padding()
                                .frame(width: ScreenSize.windowWidth() * 0.9, height: ScreenSize.windowHeight() * 0.054, alignment: .leading)
                                .background(SomeBackground.headerBackground())
                                
                            GuidingPreferences(isSoundOn: $isSoundOn, isHapticOn: $isHapticOn)
                                .padding(.vertical)
                                .background(Rectangle()
                                                .fill(Color.clear)
                                                .background(Blur(style: .systemThinMaterial)
                                                                .opacity(0.95))
                                                .cornerRadius(8, corners: [.bottomLeft, .bottomRight]))
                            
                        }
                        .frame(width: ScreenSize.windowWidth() * 0.9, alignment: .leading)
                        .padding(.top, 8)
                        
                        Button(action: {
                            self.isChooseBackground = true
                        }, label: {
                            HStack {
                                Text("Ambience")
                                    .font(Font.custom("Poppins-SemiBold", size: 17, relativeTo: .body))
                                Spacer()
                                Text("\(self.background)")
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .frame(width: ScreenSize.windowWidth() * 0.9, height: ScreenSize.windowHeight() * 0.054, alignment: .leading)
                            .background(Rectangle()
                                            .fill(Color.white.opacity(0.8))
                                            .background(Blur(style: .systemMaterial)
                                                            .opacity(0.95))
                                            .cornerRadius(8))
                            .foregroundColor(.black)
                        })
                        .frame(width: ScreenSize.windowWidth() * 0.9, alignment: .leading)
                    }
                    .frame(width : ScreenSize.windowWidth() * 0.9)
                }
            }
        }
        .onAppear(perform: {
            navPop.playLooping.player.moveBackground(name: self.background)
            if self.background == "lake"{
                navPop.black2 = true
            }else{
                navPop.black2 = false
            }
        })
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            navPop.playLooping.player.playing()
        }
        .fullScreenCover(isPresented: $isChooseBackground, content: {
            ChooseBackground(isChooseBackground: $isChooseBackground, currBackground: $background)
                .environment(\.managedObjectContext, self.manageObjectContext)
        })
        .background(navPop.playLooping
                        .frame(width: ScreenSize.windowWidth(), height: ScreenSize.windowHeight(), alignment: .center)
                        .ignoresSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack{
                    Text("Add Breathing")
                        .font(Font.custom("Poppins-SemiBold", size: 18, relativeTo: .body))
                        .foregroundColor(Color.changeTheme(black: navPop.black2))
                }
            }
        }
        .navigationBarItems(trailing:                     Button(action: {
            if breathName == ""{
                withAnimation(.default) {
                    self.attempts += 1
                }

            }else{
                saveToCoreData()
                navPop.addBreath = false
            }
        }, label: {
            Text("Add")
                .foregroundColor(Color.changeTheme(black: navPop.black2))
        }))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Precautions: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .background(Blur(style: .systemThinMaterial)
                                .opacity(0.5))
                .cornerRadius(8)
                .frame(width: ScreenSize.windowWidth() * 0.9, height: ScreenSize.windowHeight() * 0.14)
            VStack(alignment: .leading) {
                Text("Precautions:")
                    .font(Font.custom("Poppins-SemiBold", size: 16, relativeTo: .body))
                Group {
                    Text("- Make sure that the breathing pattern is as suggested by the doctor or psychiatrist")
                        .font(Font.custom("Poppins-Light", size: 12, relativeTo: .body))
                    Text("- Try to make the exhale period longer than the inhale period")
                        .font(Font.custom("Poppins-Light", size: 12, relativeTo: .body))
                }
            }
            .padding()
            .frame(width: ScreenSize.windowWidth() * 0.9, height: ScreenSize.windowHeight() * 0.14)
        }
    }
}

struct InputName: View {
    @Binding var breathName : String
    
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .background(Blur(style: .systemThinMaterial)
                                    .opacity(0.5))
                    .cornerRadius(8)
                    .frame(width: ScreenSize.windowWidth() * 0.9, height: ScreenSize.windowHeight() * 0.074)
                HStack {
                    TextField("Name", text: $breathName)
                        .accentColor(.black)
                        .font(Font.custom("Poppins-Light", size: 16, relativeTo: .body))
                        .frame(width: ScreenSize.windowWidth() * 0.8, height: ScreenSize.windowHeight() * 0.05)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.breathName = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding()
                    })
                }
                Rectangle()
                    .frame(width: ScreenSize.windowWidth() * 0.8, height: 0.5, alignment: .center)
                    .foregroundColor(.gray)
                    .padding(.top,ScreenSize.windowHeight() * 0.057 )
            }
        }
    }
}

//Multi-Component picker, namanya doang keren isinya hanya Hstack + picker biasa
struct CustomBreathingViewPicker: View {
    @Binding var inhaleSelection : Int
    @Binding var hold1Selection : Int
    @Binding var exhaleSelection : Int
    @Binding var hold2Selection : Int
    
    //batasnya ganti disni
    var inhale = [Int](2..<12)
    var hold1 = [Int](0..<12)
    var exhale = [Int](2..<12)
    var hold2 = [Int](0..<12)
    
    var body: some View {
        ZStack {
                HStack {
                Picker("", selection: self.$inhaleSelection) {
                    ForEach(self.inhale, id: \.self) { index in
                        Text("\(index)").tag(index)
                            .font(Font.custom("Poppins-Medium", size: 18, relativeTo: .body))
                    }
                }
                .frame(width: ScreenSize.windowWidth() * 0.2075, height: ScreenSize.windowHeight() * 0.185, alignment: .center)
                .clipped()
                
                Picker("", selection: self.$hold1Selection) {
                    ForEach(self.hold1, id: \.self) { index in
                        Text("\(index)").tag(index)
                            .font(Font.custom("Poppins-Medium", size: 18, relativeTo: .body))
                    }
                }
                .frame(width: ScreenSize.windowWidth() * 0.2075, height: ScreenSize.windowHeight() * 0.185, alignment: .center)
                .clipped()
                
                Picker("", selection: self.$exhaleSelection) {
                    ForEach(self.exhale, id: \.self) { index in
                        Text("\(index)").tag(index)
                            .font(Font.custom("Poppins-Medium", size: 18, relativeTo: .body))
                            
                    }
                }
                .frame(width: ScreenSize.windowWidth() * 0.2075, height: ScreenSize.windowHeight() * 0.185, alignment: .center)
                .clipped()
                
                Picker("", selection: self.$hold2Selection) {
                    ForEach(self.hold2, id: \.self) { index in
                        Text("\(index)").tag(index)
                            .font(Font.custom("Poppins-Medium", size: 18, relativeTo: .body))
                    }
                }
                .frame(width: ScreenSize.windowWidth() * 0.2075, height: ScreenSize.windowHeight() * 0.185, alignment: .center)
                .clipped()
            }
        }
    }
}

struct GuidingPreferences: View {
    @Binding var isSoundOn: Bool
    @Binding var isHapticOn: Bool
    var body: some View {
        VStack{
            Toggle(isOn: $isSoundOn, label: {
                Text("Audio Instruction")
                    .font(Font.custom("Poppins-Light", size: 16, relativeTo: .body))
            })
            .padding(.horizontal)
            
            Toggle(isOn: $isHapticOn, label: {
                Text("Haptic")
                    .font(Font.custom("Poppins-Light", size: 16, relativeTo: .body))
            })
            .padding(.horizontal)
        }
        
    }
}

extension CustomBreathingView {
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
        breath.background = background
        
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
        CustomBreathingView().environmentObject(NavigationPopObject())
    }
}
