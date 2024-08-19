//
//  CardView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 21/07/24.
//

import SwiftUI

struct CardView: View {
    
    @Binding var Exercise: Bool
    @Binding var Tabla: Int
    
    var card: Card
    var isSelected: Bool
    @EnvironmentObject var appData: AppData
    var incrementExercises: () -> Void

    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: appData.UISH * 0.4)
                .scaleEffect(isSelected ? 1.2 : 1)
            if appData.currentLanguage == .spanish {
                if card.id == 10 {
                    Text("Completa")
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.secondary)
                        .rotationEffect(Angle(degrees: -5))
                        .offset(x: -60,y:-130)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    Text("el")
                        .font(.custom("RifficFree-Bold", size: 25))
                        .foregroundColor(.AmarilloAns)
                        .offset(x: -40,y:-110)
                        .rotationEffect(Angle(degrees: 35))
                        .scaleEffect(isSelected ? 1.2 : 1)
                    Text("Reto")
                        .font(.custom("RifficFree-Bold", size: 75))
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: -5))
                        .offset(x: -50,y:-80)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id <= 1 || card.id == 5 {
                    Text(card.label)
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 60,y:-120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                
                if card.id == 9  {
                    Text(appData.localizationManager.localizedString(for: "10" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 110, y:-120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 2 || card.id == 4  || card.id == 6 || card.id == 7 || card.id == 8{
                    Text(card.label)
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 50,y:-120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                
                if card.id == 3 {
                    Text(appData.localizationManager.localizedString(for: "4" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                
                if isSelected && card.id <= 8{
                    Circle()
                        .frame(width: 60)
                        .foregroundColor(.white)
                        .overlay {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .foregroundColor(.AvatarPopColor)
                                .offset(x:5)
                        }
                        .offset(x:90, y: 150)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0)) {
                                Exercise = true
                            }
                            if let tableNumber = numberFromLabel(card.label){
                                Tabla = tableNumber
                            }
                        }
                    
                }
                
                if isSelected && card.id > 8{
                    Circle()
                        .frame(width: 60)
                        .foregroundColor(.white)
                        .overlay {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .foregroundColor(.AvatarPopColor)
                                .offset(x:5)
                        }
                        .offset(x:160, y: 145)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0)) {
                                Exercise = true
                            }
                            if let tableNumber = numberFromLabel(card.label){
                                Tabla = tableNumber
                            }
                        }
                    
                }
            }
            
            if appData.currentLanguage == .english {
                
                if card.id == 10 {
                    Text(appData.localizationManager.localizedString(for: "stringReto" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.secondary)
                        .rotationEffect(Angle(degrees: -5))
                        .offset(x: -60,y:-130)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    Text(appData.localizationManager.localizedString(for: "stringReto2"))
                        .font(.custom("RifficFree-Bold", size: 25))
                        .foregroundColor(.AmarilloAns)
                        .offset(x: -40,y:-110)
                        .rotationEffect(Angle(degrees: 35))
                        .scaleEffect(isSelected ? 1.2 : 1)
                    Text(appData.localizationManager.localizedString(for: "stringReto3"))
                        .font(.custom("RifficFree-Bold", size: 55))
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: -5))
                        .offset(x: -20,y:-80)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 5 {
                    Text(appData.localizationManager.localizedString(for: "6"))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 60,y:-120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 9 {
                    Text(appData.localizationManager.localizedString(for: "10" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 110, y:-120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 2 {
                    Text(appData.localizationManager.localizedString(for: "3"))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 50,y:-120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 3 {
                    Text(appData.localizationManager.localizedString(for: "4" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 4 {
                    Text(appData.localizationManager.localizedString(for: "5" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                }
                if card.id == 6 {
                    Text(appData.localizationManager.localizedString(for: "7" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 1 {
                    Text(appData.localizationManager.localizedString(for: "2" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 0 {
                    Text(appData.localizationManager.localizedString(for: "1" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 7 {
                    Text(appData.localizationManager.localizedString(for: "8" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                if card.id == 8 {
                    Text(appData.localizationManager.localizedString(for: "9" ))
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(.white)
                        .offset(x: 40,y: -120)
                        .scaleEffect(isSelected ? 1.2 : 1)
                    
                }
                
                if isSelected && card.id <= 8{
                    Circle()
                        .frame(width: 60)
                        .foregroundColor(.white)
                        .overlay {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .foregroundColor(.AvatarPopColor)
                                .offset(x:5)
                        }
                        .offset(x:90, y: 150)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0)) {
                                Exercise = true
                            }
                            if let tableNumber = numberFromLabel(card.label){
                                Tabla = tableNumber
                            }
                        }
                    
                }
                
                if isSelected && card.id > 8{
                    Circle()
                        .frame(width: 60)
                        .foregroundColor(.white)
                        .overlay {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .foregroundColor(.AvatarPopColor)
                                .offset(x:5)
                        }
                        .offset(x:160, y: 145)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0)) {
                                Exercise = true
                            }
                            if let tableNumber = numberFromLabel(card.label){
                                Tabla = tableNumber
                            }
                        }
                    
                }
            }
        }
    }
    
    func numberFromLabel(_ label: String) -> Int? {
        let mapping: [String: Int] = [
            "Uno": 1,
            "Dos": 2,
            "Tres": 3,
            "Cuatro": 4,
            "Cinco": 5,
            "Seis": 6,
            "Siete": 7,
            "Ocho": 8,
            "Nueve": 9,
            "Diez": 10,
            "Once": 11
        ]
        return mapping[label]
    }
}
