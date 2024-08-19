//
//  CustomNumericKeyboard.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 16/08/24.
//
import SwiftUI

struct CustomNumericKeyboard: View {
    var onKeyPress: (String) -> Void
    
    let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["x", "0", "OK"]
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            onKeyPress(key)
                        }) {
                            Text(key)
                                .font(.custom("RifficFree-Bold", size: 30))
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .background(Color.skinMonin)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    CustomNumericKeyboard { key in
        print("Key pressed: \(key)")
    }
}
