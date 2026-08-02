import Foundation

struct WorkPackage: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var milestoneID: UUID?
    var title: String
    var summary: String
    var taskIDs: [UUID]
    var source: WorkPackageSource

    init(
        id: UUID = UUID(),
        milestoneID: UUID? = nil,
        title: String,
        summary: String = "",
        taskIDs: [UUID] = [],
        source: WorkPackageSource = .manual
    ) {
        self.id = id
        self.milestoneID = milestoneID
        self.title = title
        self.summary = summary
        self.taskIDs = taskIDs
        self.source = source
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case milestoneID
        case title
        case summary
        case taskIDs
        case source
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        milestoneID = try container.decodeIfPresent(UUID.self, forKey: .milestoneID)
        title = try container.decode(String.self, forKey: .title)
        summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? ""
        taskIDs = try container.decodeIfPresent([UUID].self, forKey: .taskIDs) ?? []
        source = try container.decodeIfPresent(WorkPackageSource.self, forKey: .source) ?? .manual
    }
}
