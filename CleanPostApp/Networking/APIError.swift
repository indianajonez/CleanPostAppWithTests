
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case serverError(Int)
    case decodingFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .decodingFailed:
            return "Ошибка при декодировании данных"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
