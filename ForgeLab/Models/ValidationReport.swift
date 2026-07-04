import Foundation

struct ValidationReport: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var title: String
    var summary: String
    var status: ValidationStatus
    let createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        summary: String = "",
        status: ValidationStatus = .notRun,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.status = status
        self.createdAt = createdAt
    }
}

enum ValidationStatus: String, Codable, CaseIterable, Sendable {
    case notRun
    case passed
    case failed
}
