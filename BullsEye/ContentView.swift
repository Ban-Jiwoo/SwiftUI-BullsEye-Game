//
//  ContentView.swift
//  BullsEye
//
//  Created by Jiwoo Ban on 2020/07/28.
//  Copyright © 2020 Jiwoo Ban. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 3...97)
    @State var score = 0
    @State var round = 1
    let midnightBlue = Color(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 103.0 / 255.0)
    
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .foregroundColor(Color.white)
            .modifier(Shadow())
        //iosfonts.com
            .font(Font.custom("Arial Rounded MT Bold", size: 20))
        }
    }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
        //iosfonts.com
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
        }
    }
    
    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .foregroundColor(Color.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .foregroundColor(Color.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
        }
    }
    
    
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            //Target row
            HStack {
                Text("주어진 숫자에 최대한 가깝게 움직여보세요 🎯: ").modifier(LabelStyle())
                Text("\(target)").modifier(ValueStyle())
            }
            
            Spacer()
            
            //Slider row
            HStack {
                Text("1").modifier(LabelStyle())
                Slider(value: $sliderValue, in: 1...100).accentColor(Color.green)
                Text("100").modifier(LabelStyle())
            }
            
            Spacer()
            
            //Button row
            Button(action: {
                print("yo")
                self.alertIsVisible = true
            }) {
                Text(/*@START_MENU_TOKEN@*/"Hit Me!"/*@END_MENU_TOKEN@*/).modifier(ButtonLargeTextStyle())
            }
            .alert(isPresented: $alertIsVisible) { () ->
                Alert in
                return Alert(title: Text(alertTitle()), message: Text("선택한 위치는 🎯 \(sliderValueRounded()) \n 100점 만점에 \(pointsForCurrentRound())점 드릴께요."), dismissButton: .default(Text("Awesome")) {
                        self.score = self.score + self.pointsForCurrentRound()
                        self.target = Int.random(in: 3...97)
                    self.round += 1
                    })
            }
            .background(Image("Button")).modifier(Shadow())
            
            Spacer()
            
            
            //Score row
            HStack {
                Button(action: {
                    self.resetGame()
                }) {
                    HStack{
                        Image("StartOverIcon")
                        Text("Start Over").modifier(ButtonSmallTextStyle())
                    }
                }.background(Image("Button")).modifier(Shadow())
                Spacer()
                Text("Score:").modifier(LabelStyle())
                Text("\(score)").modifier(ValueStyle())
                Spacer()
                Text("Round:").modifier(LabelStyle())
                Text("\(round)").modifier(ValueStyle())
                Spacer()
                NavigationLink(destination: AboutView()) {
                    HStack{
                        Image("InfoIcon")
                        Text("Info").modifier(ButtonSmallTextStyle())
                    }
                }.background(Image("Button")).modifier(Shadow())
                
            }.padding(.bottom, 20)
            
                
        }
        .background(Image("Background"), alignment: .center)
        .accentColor(midnightBlue)
        .navigationBarTitle("Bullseye")
    }
    
    
    
    func sliderValueRounded() -> Int {
        return Int(sliderValue.rounded())
    }
    
    func amountDiff() -> Int {
        abs(target - sliderValueRounded())
    }
            
    func pointsForCurrentRound() -> Int {
        
//            let difference = abs(target - roundedValue)
//            let awardedPoints = 100 - abs(target - roundedValue)
//            if roundedValue > self.target {
//                difference = roundedValue - self.target
//            } else if self.target > roundedValue {
//                difference = self.target - roundedValue
//            } else {
//                difference = 0
//            }
    
//            if difference < 0 {
//                difference = difference * -1
//            }
        let maximumScore = 100
        let difference = amountDiff()
        let bonus: Int

        if difference == 0 {
            bonus = 100
        } else if amountDiff() == 1 {
            bonus = 50
        } else {
            bonus = 0
        }

        return maximumScore - difference + bonus
    }
    
    func alertTitle() -> String {
        let difference = amountDiff()
        let title: String
        if difference == 0 {
            title = "정확하네요! 보너스 100점🎉"
        } else if difference == 1 {
            title = "거의 맞추셨어요! 보너스 50점🎁"
        } else if difference < 5 {
            title = "조금만 더 가까이..."
        } else if difference <= 10 {
            title = "나쁘지 않아요."
        } else {
            title = "감이 없으시군요."
        }
        return title
    }
    
    func resetGame() {
        self.score = 0
        self.round = 1
        self.sliderValue = 50.0
        target = Int.random(in: 3...98)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .previewLayout(.fixed(width: 650, height: 350))
    }
}

