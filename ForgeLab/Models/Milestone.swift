import Foundation

struct Milestone: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var title: String
    var summary: String
    var status: MilestoneStatus
    var targetDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        summary: String = "",
        status: MilestoneStatus = .planned,
        targetDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.status = status
        self.targetDate = targetDate
    }
}

enum MilestoneStatus: String, Codable, CaseIterable, Sendable {
    case planned
    case inProgress
    case review
    case completed
}
