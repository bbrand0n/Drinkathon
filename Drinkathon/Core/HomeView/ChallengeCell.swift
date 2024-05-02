//
//  ChallengeCell.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI
import Charts

struct ChallengeCell: View {
    
    let data: [Entry] = [
        .init(name: "Today", amount: 5),
        .init(name: "Me", amount: 4)
    ]
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                CircleProfilePictureView()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bdizzle")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    GroupBox {
                        VStack(alignment: .leading, spacing: 4) {
                            Chart(data) { item in
                                BarMark(x: .value("Amount", item.amount),
                                        y: .value("Name", item.name),
                                        width: .fixed(12)
                                )
                                .foregroundStyle(.link)
                                .cornerRadius(8)
                                .annotation(position: .trailing) {
                                    Text(item.amount.formatted())
                                        .foregroundColor(Color.primaryBlue)
                                        .font(.caption)
                                }
                            }
                            .padding(.bottom)
                            .chartXAxis(.hidden)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .chartYAxis {
                                AxisMarks(preset: .extended, position: .leading) { _ in
                                    AxisValueLabel(horizontalSpacing: 8)
                                        .font(.footnote)
                                }
                            }
                            
                            Divider()
                                .padding(.bottom, 5)
                            HStack(alignment: .bottom, spacing: 5) {
                                Text("Time left: ")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                
                                Text("2h 5m 3s")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.red)
                                
                                Spacer()
                                
                                Text("4-1")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                        }
                        
                        
                    }
                    .cornerRadius(15)
                    .padding(.top, 5)
                    
                    Divider()
                        .padding(.top)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ChallengeCell()
}
