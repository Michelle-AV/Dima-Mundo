//
//  CustomKeyboardView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 04/07/24.
//
import SwiftUI

struct CustomKeyboardView: View {
    @EnvironmentObject var appData: AppData
    @Binding var text: String
    @Binding var keyboardVisible: Bool
    @State private var isUppercase: Bool = false
    
    let rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]

    var body: some View {
        VStack(spacing: 15) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 10) {
                    if rowIndex == 2 {
                        CapsLockButton(isUppercase: $isUppercase)
                    }
                    ForEach(Array(rows[rowIndex]), id: \.self) { letter in
                        KeyboardButton(letter: letter, isUppercase: $isUppercase, text: $text)
                    }
                    if rowIndex == 1 {
                        DeleteButton(text: $text)
                    }
                    if rowIndex == 2 {
                        CapsLockButton(isUppercase: $isUppercase)
                    }
                }
            }
            HStack(spacing: 10) {
                MicButton()
                SpacerButton(text: $text)
                DoneButton(text: $text, keyboardVisible: $keyboardVisible)
            }
        }
        .padding(50)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct KeyboardButton: View {
    var letter: Character
    @Binding var isUppercase: Bool
    @Binding var text: String

    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                self.text.append(self.isUppercase ? letter.uppercased() : letter.lowercased())
            }
        }) {
            Text(self.isUppercase ? String(letter.uppercased()) : String(letter.lowercased()))
                .font(.custom("RifficFree-Bold", size: 20))
                .frame(width: 75, height: 50)
                .foregroundColor(.gray)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(5)
        }
    }
}
struct CapsLockButton: View {
    @Binding var isUppercase: Bool

    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                self.isUppercase.toggle()
            }
        }) {
            Image(systemName: isUppercase ? "capslock.fill" : "capslock")
                .resizable()
                .scaledToFit()
                .bold()
                .frame(width: 20)
                .padding(14)
                .padding(.horizontal, 36)
                .background(isUppercase ? Color.blue : Color.gray)
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}

struct DeleteButton: View {
    @Binding var text: String

    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                _ = self.text.popLast()
            }
        }) {
            Image(systemName: "delete.left.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .padding(15)
                .padding(.horizontal, 15)
                .background(Color.red)
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}

struct MicButton: View {
    var body: some View {
        Button(action: {
            // Aquí se puede integrar funcionalidad de dictado o reconocimiento de voz
        }) {
            Image(systemName: "mic.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .padding(10)
                .padding(.horizontal,44)
                .background(Color.gray)
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}

struct SpacerButton: View {
    @Binding var text: String
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                self.text += " "
            }
        }) {
            Image(systemName: "rectangle.portrait")
                .resizable()
                .scaledToFit()
                .bold()
                .frame(width:  UISW * 0.5, height: 30)
                .padding(10)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}

struct DoneButton: View {
    @Binding var text: String
    @Binding var keyboardVisible: Bool


    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 1.35)) {
                keyboardVisible = false
            }
        }) {
            Image(systemName: "keyboard.chevron.compact.down.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .padding(.horizontal,44)
                .padding(11)
                .background(Color.green)
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CustomKeyboardView(text: .constant(""), keyboardVisible: .constant(true))
        .environmentObject(AppData())
}
