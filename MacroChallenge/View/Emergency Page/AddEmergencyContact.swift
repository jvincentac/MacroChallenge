//
//  AddEmergencyContact.swift
//  MacroChallenge
//
//  Created by Vincent Alexander Christian on 23/10/20.
//

import SwiftUI

struct AddEmergencyContact: View {
    @EnvironmentObject var navPop: NavigationPopObject
    @Environment(\.managedObjectContext) var manageObjectContext
    @State var name: String = ""
    @State var number: String = ""
    @Binding var isAddNewContact: Bool
    @Binding var off: CGFloat
    @State var attempts: Int = 0
    @State var attempts2: Int = 0
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        self.isAddNewContact = false
                    }
                    navPop.tabIsHidden = false
                    hideKeyboard()
                    self.off = 200
                }, label: {
                    Text("Cancel")
                        .padding(5)
                        .foregroundColor(.blue)

                })
                
                Spacer()
                
                Text("Add New Contact")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                
                Spacer()
                
                Button {
                    if self.name == "" {
                        withAnimation(.default) {
                            self.attempts += 1
                        }
                    }
                    else if self.number == ""{
                        withAnimation(.default) {
                            self.attempts2 += 1
                        }

                    
                    }else{
                        saveToCoreData()
                        self.name = ""
                        self.number = ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            self.isAddNewContact = false
                        }
                        self.off = 200
                        navPop.tabIsHidden = false
                        hideKeyboard()
                    }
                } label: {
                    Text("Done")
                        .padding(5)
                        .foregroundColor(Color.blue)
                }
//                .disabled(self.name == "" ? true : (self.number == "" ? true : false))
            }
            .padding()
            .frame(width: ScreenSize.windowWidth() * 0.9, height: 60)
            Divider()

            Group {
                TextField("Name", text: $name)
                    .modifier(ClearButton(text: $name))
                    .accentColor(.black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor(.white))).modifier(Shake(animatableData: CGFloat(attempts))))
                
                TextField("Number", text: $number)
                    .modifier(ClearButton(text: $number))
                    .accentColor(.black)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor(.white))).modifier(Shake(animatableData: CGFloat(attempts2))))
            }
            .frame(width: ScreenSize.windowWidth() * 0.9, height: 60)
        }
    }
}

extension AddEmergencyContact {
    func saveToCoreData() {
        let emergency = Emergency(context: manageObjectContext)
        emergency.name = name
        emergency.number = number
        emergency.id = UUID()
        
        do {
            try self.manageObjectContext.save()
        } catch {
            print(error)
        }
    }
}

//struct AddEmergencyContact_Previews: PreviewProvider {
//    @State static var isAddNewContact = true
//    static var previews: some View {
//        AddEmergencyContact(isAddNewContact: $isAddNewContact)
//    }
//}
