import Foundation

struct ArchitectureDecision: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var title: String
    var context: String
    var decision: String
    var consequences: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        context: String = "",
        decision: String = "",
        consequences: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.context = context
        self.decision = decision
        self.consequences = consequences
        self.createdAt = createdAt
    }
}
