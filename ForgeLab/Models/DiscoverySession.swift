import Foundation

struct DiscoverySession: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var answers: [DiscoveryAnswer]
    let completedAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        answers: [DiscoveryAnswer],
        completedAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.answers = answers
        self.completedAt = completedAt
        self.updatedAt = updatedAt
    }
}

struct DiscoveryAnswer: Identifiable, Codable, Equatable, Sendable {
    var id: String { questionID }

    let questionID: String
    let prompt: String
    let category: String
    var response: String

    init(
        questionID: String,
        prompt: String,
        category: String,
        response: String
    ) {
        self.questionID = questionID
        self.prompt = prompt
        self.category = category
        self.response = response
    }
}
