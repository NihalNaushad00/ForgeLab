import Foundation

struct WorkPackage: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var milestoneID: UUID?
    var title: String
    var summary: String
    var taskIDs: [UUID]

    init(
        id: UUID = UUID(),
        milestoneID: UUID? = nil,
        title: String,
        summary: String = "",
        taskIDs: [UUID] = []
    ) {
        self.id = id
        self.milestoneID = milestoneID
        self.title = title
        self.summary = summary
        self.taskIDs = taskIDs
    }
}
