
import SwiftUI
import Foundation
import Network

enum NetworkState: Equatable {
    case connected
    case offline
    case serverUnreachable
    case generalError(String)
    
    //MARK: Computer properties

    var alertMessage: String? {
        switch self {
        case .generalError(let message):
            return message
        case .offline:
            return "Нет подключения к интернету. Показаны данные из кэша."
        case .serverUnreachable:
            return "Сервер недоступен. Возможно, включён VPN."
        default:
            return nil
        }
    }
}
