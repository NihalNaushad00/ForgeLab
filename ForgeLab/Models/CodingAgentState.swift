import Foundation

struct CodingAgentState: Codable, Equatable, Sendable {
    var status: CodingAgentStatus
    var queue: CodingQueue
    var currentWorkPackageID: UUID?
    var currentTaskID: UUID?
    var sourceProductSpecificationID: UUID?
    var generatedAt: Date?
    var updatedAt: Date

    init(
        status: CodingAgentStatus = .notStarted,
        queue: CodingQueue = CodingQueue(),
        currentWorkPackageID: UUID? = nil,
        currentTaskID: UUID? = nil,
        sourceProductSpecificationID: UUID? = nil,
        generatedAt: Date? = nil,
        updatedAt: Date = Date()
    ) {
        self.status = status
        self.queue = queue
        self.currentWorkPackageID = currentWorkPackageID
        self.currentTaskID = currentTaskID
        self.sourceProductSpecificationID = sourceProductSpecificationID
        self.generatedAt = generatedAt
        self.updatedAt = updatedAt
    }
}

enum CodingAgentStatus: String, Codable, CaseIterable, Sendable {
    case notStarted
    case ready
    case generated
    case inProgress
    case completed

    var displayName: String {
        switch self {
        case .notStarted:
            "Not Started"
        case .ready:
            "Ready"
        case .generated:
            "Plan Generated"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
}

struct CodingQueue: Codable, Equatable, Sendable {
    var pendingTaskIDs: [UUID]
    var inProgressTaskIDs: [UUID]
    var completedTaskIDs: [UUID]
    var futureTaskIDs: [UUID]

    init(
        pendingTaskIDs: [UUID] = [],
        inProgressTaskIDs: [UUID] = [],
        completedTaskIDs: [UUID] = [],
        futureTaskIDs: [UUID] = []
    ) {
        self.pendingTaskIDs = pendingTaskIDs
        self.inProgressTaskIDs = inProgressTaskIDs
        self.completedTaskIDs = completedTaskIDs
        self.futureTaskIDs = futureTaskIDs
    }
}

enum WorkPackageSource: String, Codable, Sendable {
    case manual
    case codingAgent
}
