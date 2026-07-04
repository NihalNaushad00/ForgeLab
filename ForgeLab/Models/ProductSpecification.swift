import Foundation

struct ProductSpecification: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var problemStatement: String
    var targetAudience: String
    var goals: [String]
    var nonGoals: [String]

    init(
        id: UUID = UUID(),
        problemStatement: String = "",
        targetAudience: String = "",
        goals: [String] = [],
        nonGoals: [String] = []
    ) {
        self.id = id
        self.problemStatement = problemStatement
        self.targetAudience = targetAudience
        self.goals = goals
        self.nonGoals = nonGoals
    }
}
