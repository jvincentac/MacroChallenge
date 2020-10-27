//
//  BreathView.swift
//  MacroChallenge
//
//  Created by Kenji Surya Utama on 13/10/20.
//

import SwiftUI

struct BreathView: View {
    
    @EnvironmentObject var navPop : NavigationPopObject
    @FetchRequest(fetchRequest: Breathing.getAllBreathing()) var breaths: FetchedResults<Breathing>
    @State var index = 0
    @State var inhale = 0
    @State var hold1 = 0
    @State var exhale = 0
    @State var hold2 = 0
    
    
    var body: some View {
        VStack {
            // show data by index
            if !breaths.isEmpty{
                HStack {
                    Button(action: {
                        changeLeft()
                    }, label: {
                        Image (systemName: "chevron.left")
                            .foregroundColor(.black)
                    })
                    VStack {
                        Text(String(breaths[index].name ?? ""))
                        Text("\(inhale)-\(hold1)-\(exhale)-\(hold2)")
                    }
                    Button(action: {
                        changeRight()
                    }, label: {
                        Image (systemName: "chevron.right")
                            .foregroundColor(.black)
                    })
                }
            }
            Group {
                Button(action: {
                    navPop.toBreathing = true
                }, label: {
                    Text("After Breathing")
                        .padding()
                        .foregroundColor(.white)
                })
                NavigationLink(
                    destination: AfterBreathingView(),
                    isActive : $navPop.toBreathing,
                    label: {
                        EmptyView()
                    })
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Image("ocean").backgroundImageModifier())
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        //left
                        if value.translation.width < 0 {
                            changeLeft()
                        }
                        //right
                        if value.translation.width > 0 {
                            changeRight()
                        }
                        inhale = Int(breaths[index].inhale)
                        hold1 = Int(breaths[index].hold1)
                        exhale = Int(breaths[index].exhale)
                        hold2 = Int(breaths[index].hold2)
                        
                    }))
    }
}

extension BreathView{
    func changeRight(){
        if index == breaths.count - 1 {
            index = 0
        }else{
            index += 1
        }
    }
    func changeLeft(){
        if index == 0 {
            index = breaths.count - 1
        }else{
            index -= 1
        }
    }
}

struct BreathView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        BreathView().environment(\.managedObjectContext, viewContext).environmentObject(NavigationPopObject())
    }
}
