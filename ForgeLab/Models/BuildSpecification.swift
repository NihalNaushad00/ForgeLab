import Foundation

struct BuildSpecification: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var platform: String
    var architectureSummary: String
    var technicalRequirements: [String]

    init(
        id: UUID = UUID(),
        platform: String = "iOS",
        architectureSummary: String = "",
        technicalRequirements: [String] = []
    ) {
        self.id = id
        self.platform = platform
        self.architectureSummary = architectureSummary
        self.technicalRequirements = technicalRequirements
    }
}
