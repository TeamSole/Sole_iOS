//
//  HourMinutePicker.swift
//  SoleApp
//
//  Created by SUN on 2023/03/22.
//

import SwiftUI

struct HourMinutePickerModifier: ViewModifier {
    @Binding var isShowFlag: Bool
    let complete: (Int, Int) -> ()
//    @Binding var selectedHours: Int
//    @Binding var selectedMins: Int
    func body(content: Content) -> some View {
        ZStack() {
            content
            if isShowFlag {
                Color.black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                CountDownPicker(isShowFlag: $isShowFlag, complete: { complete($0, $1) })
                    .padding(.horizontal, 40)
            }
        }
    }
}

struct CountDownPicker: View {
    
    var hours = Array(0...23)
    var min = Array(0...59)
    @State private var selectedHours: Int = 0
    @State private var selectedMins: Int = 0
    
    @Binding var isShowFlag: Bool
    
    let complete: (Int, Int) -> ()
    
    var body: some View {
        VStack() {
        GeometryReader { geometry in
            
                HStack {
                    Picker(selection: $selectedHours, label: Text("시간")) {
                        ForEach(0..<self.hours.count, id: \.self) {
                            Text("\(self.hours[$0]) 시간")
                                .bold()
                        }
                    }
                    .frame(maxWidth: geometry.size.width / 2)
                    .clipped()
                    .pickerStyle(.wheel)
                    
                    Picker(selection: self.$selectedMins, label: Text("분")) {
                        ForEach(0..<self.min.count, id: \.self) {
                            Text("\(self.min[$0]) 분")
                                .bold()
                        }
                    }
                    .frame(maxWidth: geometry.size.width / 2)
                    .clipped()
                    .pickerStyle(.wheel)
                }
            }
            Text("확인")
                .foregroundColor(.white)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity)
                .frame(height: 48.0)
                .background(Color.blue_4708FA.cornerRadius(8.0))
                .padding(16.0)
                .contentShape(Rectangle())
                .onTapGesture {
                    complete(selectedHours, selectedMins)
                    isShowFlag = false
                }
            
        }
        .padding(.horizontal, 16.0)
        .frame(width: .infinity, alignment: .center)
        .frame(height: 300.0)
        .background(Color.white)
        .cornerRadius(12.0)
        
    }
}

struct HourMinutePicker_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .modifier(HourMinutePickerModifier(isShowFlag: .constant(true), complete: {_,_ in}))
        
    }
}
