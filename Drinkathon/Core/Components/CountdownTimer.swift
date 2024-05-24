//
//  CountdownTimer.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/23/24.
//

import SwiftUI

struct CountdownTimer: View {
    @Binding var progress: Double
    var duration: String
    @State var progressAnimate = 0.97
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.8)
                .foregroundColor(.black)
                .frame(width: 150, height: 150)
            
            Circle()
                .trim(from: 0.0, to: progressAnimate)
                .stroke(style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270.0))
                .foregroundStyle(
                    AngularGradient(colors: [.red, .green], center: .center, startAngle: Angle.degrees(0), endAngle: Angle.degrees(350))
                )
                .frame(width: 150, height: 150)
                
            
            Text(duration)
              .font(.title2.bold())
              .foregroundStyle(.white)
              .contentTransition(.numericText())
        }
        .onChange(of: progress) {
            withAnimation(.spring(.bouncy(duration: 1), blendDuration: 1)) {
                self.progressAnimate = progress
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.darkerBlue)
    }
}

#Preview {
    
    let timer = CountdownTimer(progress: .constant(0.95), duration: "4h 5m")
    return timer
}
