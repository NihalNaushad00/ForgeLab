import Foundation

struct ProjectTask: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var title: String
    var notes: String
    var status: TaskStatus
    var workPackageID: UUID?

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        status: TaskStatus = .todo,
        workPackageID: UUID? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.status = status
        self.workPackageID = workPackageID
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case notes
        case status
        case workPackageID
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        status = try container.decodeIfPresent(TaskStatus.self, forKey: .status) ?? .todo
        workPackageID = try container.decodeIfPresent(UUID.self, forKey: .workPackageID)
    }
}

enum TaskStatus: String, Codable, CaseIterable, Sendable {
    case todo
    case doing
    case blocked
    case done
}
