//
//  ScheduleServiceError.swift
//  
//
//  Created by Jonas Richard Richter on 22.01.22.
//

import Foundation

public enum ScheduleServiceError: Error {
    case invalidURL
    case wrongCredentials
    case decoding(Error?)
    case network(Error?)
    case other(Error?)
}

extension ScheduleServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            switch Locale.current.languageCode {
            case "de":
                return "Es ist ein interner Fehler aufgetreten."
            default:
                return "An internal error has occurred."
            }
        case .wrongCredentials:
            switch Locale.current.languageCode {
            case "de":
                return "Die Anmeldedaten sind nicht korrekt."
            default:
                return "The login credentials are not valid."
            }
        case .decoding(let error):
            switch Locale.current.languageCode {
            case "de":
                return "Es ist ein Fehler bei der Verarbeitung der Daten aufgetreten. Mehr Informationen: \(error?.localizedDescription)"
            default:
                return "An error occurred while processing the data. More information: \(error?.localizedDescription)"
            }
        case .network(let error):
            switch Locale.current.languageCode {
            case "de":
                return "Es ist ein Netzwerkfehler aufgetreten. Mehr Informationen: \(error?.localizedDescription)"
            default:
                return "A network error occurred. More information: \(error?.localizedDescription)"
            }
        case .other(let error):
            switch Locale.current.languageCode {
            case "de":
                return "Ein unbekannter Fehler ist aufgetreten. Mehr Informationen: \(error?.localizedDescription)"
            default:
                return "An unknown error has occurred. More information: \(error?.localizedDescription)"
            }
        }
    }
}
