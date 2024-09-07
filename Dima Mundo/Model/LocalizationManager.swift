//
//  LocalizationManager.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 14/08/24.
//
import Foundation

struct LocalizationManager {
    var currentLanguage: Language
    
    func localizedString(for key: String) -> String {
        switch currentLanguage {
        case .english:
            return englishStrings[key] ?? key
        case .spanish:
            return spanishStrings[key] ?? key
        }
    }
    
    private let englishStrings: [String: String] = [
        ///Navegation strings
        "title": "Dima World",
        "start": "Start",
        "information": "Information",
        "PerfilesTitle" : "Who are you?",
        "PerfilesButton" : "Continue",
        "CrearPerfilTitle":"Enter your name",
        "CrearPerfilTextfield":"Write here",
        "CrearPerfilButton":"Add",
        "SelectTableTitle":"Choose a number and practice",
        "AttemptsLbl":"Atts: ",
        "ExitButton":"Exit",
        "ExercisesLbl":"Exercises",
        "RoundLbl":"Round",
        
        ///InfoView strings
        "IVText1":"¡Descubre ",
        "IVText2":"DimaMundo",
        "IVText3":", la app que convierte el aprendizaje de las tablas de multiplicar en una aventura emocionante!",
        "IVText4":"A través de actividades creativas, los",
        "IVText5":" pequeños ",
        "IVText6":"exploradores ",
        "IVText7":"dominarán las matemáticas ",
        "IVText8":"sin siquiera darse cuenta. ",
        
        ///Cards strings
        "1":"One",
        "2":"Two",
        "3":"Three",
        "4":"Four",
        "5":"Five",
        "6":"Six",
        "7":"Seven",
        "8":"Eight",
        "9":"Nine",
        "10":"Ten",
        "stringReto":"Complete",
        "stringReto2":"the",
        "stringReto3":"Challenge",
        
    ]
    
    private let spanishStrings: [String: String] = [
        ///Navegation strings
        "title": "Dima Mundo",
        "start": "Iniciar",
        "information": "Información",
        "PerfilesTitle" : "¿Quién eres?",
        "PerfilesButton" : "Continuar",
        "CrearPerfilTitle":"Ingresa tu nombre",
        "CrearPerfilTextfield":"Escribe acá",
        "CrearPerfilButton":"Agregar",
        "SelectTableTitle":"Elige una tabla para practicar",
        "AttemptsLbl":"Intentos: ",
        "ExitButton":"Salir",
        "ExercisesLbl":"Ejercicios",
        "RoundLbl":"Ronda",
        
        ///InfoView strings
        "IVText1":"¡Descubre ",
        "IVText2":"DimaMundo",
        "IVText3":", la app que convierte el aprendizaje de las tablas de multiplicar en una aventura emocionante!",
        "IVText4":"A través de actividades creativas, los",
        "IVText5":" pequeños ",
        "IVText6":"exploradores ",
        "IVText7":"dominarán las matemáticas ",
        "IVText8":"sin siquiera darse cuenta. ",
        
        ///Cards strings
        "1":"Uno",
        "2":"Dos",
        "3":"Tres",
        "4":"Cuatro",
        "5":"Cinco",
        "6":"Seis",
        "7":"Siete",
        "8":"Ocho",
        "9":"Nueve",
        "10":"Diez",
        "stringReto":"Completa",
        "stringReto2":"el",
        "stringReto3":"Reto",
        
        ///Tutorial strings
        "t":"t",
        
        ///Stars and trophy pop up strings
        ///Dashboard strings
        "DashboardTitle":"Panel de Control",
        "DashboardPassTextField":"Contraseña",
        "DashboardWelcomeLbl":"¡Bienvenido!",
        "DashboardRecordBtn":"Historial",
        "DashboardManageBtn":"Gestionar perfiles",
        "DashboardCreationLbl":"Creado el ",
        //Para los intentos usar "AttemptsLbl"
        "DashboardAttBtn":"Ver intentos",
        "DashboardSaveBtn":"Guardar",
        "DashboardDropChallenge":"Reto",
        "DashboardDropExercise":"Ejercicios",
        "DashboardHeaderUser":"Usuario",
        "DashboardHeaderTable":"Tabla",
        "DashboardHeaderCorrect":"Aciertos",
        "DashboardHeaderWrong":"Errores",
        "DashboardHeaderDate":"Fecha",
        "DashboardChartsBtn":"Graficar",
        
        "cal-reto1":"¡Ánimo! Los comienzos siempre son difíciles. Sigue practicando y verás resultados mejores",
        "cal-reto2":"¡Bien hecho! Has respondido varias preguntas correctamente, pero aún hay espacio para mejorar. ¡Sigue practicando!",
        "cal-reto3":"¡Buen trabajo! Estás casi en la cima. Con un poco más de práctica, ¡lograrás mejores resultados!",
        "cal-reto4":"¡Excelente trabajo! Has respondido todos los ejercicios correctamente, ¡eres un experto en las tablas de multiplicar!",
        
        
        "cal-ejercicio0":"No te preocupes. ¡Sigue intentando y mejorarás con la práctica!",
        "cal-ejercicio1-2":"No te desanimes, ¡practicar te ayudará a mejorar!",
        "cal-ejercicio3-4":"¡Vas por buen camino! Continúa practicando y lograrás más aciertos.",
        "cal-ejercicio5":"¡Buen trabajo! Completaste todos los ejercicios correctamente, ¡sigue así!",
        
    ]
}
