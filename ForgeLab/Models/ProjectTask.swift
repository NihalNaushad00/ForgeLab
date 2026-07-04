import Foundation

struct ProjectTask: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var title: String
    var notes: String
    var status: TaskStatus

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        status: TaskStatus = .todo
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.status = status
    }
}

enum TaskStatus: String, Codable, CaseIterable, Sendable {
    case todo
    case doing
    case blocked
    case done
}
