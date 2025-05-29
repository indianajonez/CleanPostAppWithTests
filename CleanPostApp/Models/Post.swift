
import Foundation

struct Post: Codable, Identifiable, Equatable {
    let id: Int
    let userId: Int
    var title: String
    var body: String
    var isFavorite: Bool = false

    private enum CodingKeys: String, CodingKey {
        case id, userId, title, body
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - CDPost → Post Conversion

extension CDPost {
    func toPost() -> Post {
        Post(
            id: Int(self.id),
            userId: Int(self.userId),
            title: self.title ?? "",
            body: self.body ?? "",
            isFavorite: self.isFavorite
        )
    }
}
