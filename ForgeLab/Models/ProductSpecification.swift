import Foundation

struct ProductSpecification: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var projectSummary: String
    var recommendedTechStack: [String]
    var architectureStyle: String
    var mainFeatures: [String]
    var suggestedFolderStructure: [String]
    var databaseRequirement: String
    var authenticationRequirement: String
    var apiRequirement: String
    var initialMilestones: [String]
    var generatedAt: Date
    var sourceDiscoverySessionID: UUID?

    private enum CodingKeys: String, CodingKey {
        case id
        case projectSummary
        case recommendedTechStack
        case architectureStyle
        case mainFeatures
        case suggestedFolderStructure
        case databaseRequirement
        case authenticationRequirement
        case apiRequirement
        case initialMilestones
        case generatedAt
        case sourceDiscoverySessionID
        case problemStatement
        case targetAudience
        case goals
    }

    init(
        id: UUID = UUID(),
        projectSummary: String = "",
        recommendedTechStack: [String] = [],
        architectureStyle: String = "",
        mainFeatures: [String] = [],
        suggestedFolderStructure: [String] = [],
        databaseRequirement: String = "",
        authenticationRequirement: String = "",
        apiRequirement: String = "",
        initialMilestones: [String] = [],
        generatedAt: Date = Date(),
        sourceDiscoverySessionID: UUID? = nil
    ) {
        self.id = id
        self.projectSummary = projectSummary
        self.recommendedTechStack = recommendedTechStack
        self.architectureStyle = architectureStyle
        self.mainFeatures = mainFeatures
        self.suggestedFolderStructure = suggestedFolderStructure
        self.databaseRequirement = databaseRequirement
        self.authenticationRequirement = authenticationRequirement
        self.apiRequirement = apiRequirement
        self.initialMilestones = initialMilestones
        self.generatedAt = generatedAt
        self.sourceDiscoverySessionID = sourceDiscoverySessionID
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        projectSummary = try container.decodeIfPresent(String.self, forKey: .projectSummary)
            ?? container.decodeIfPresent(String.self, forKey: .problemStatement)
            ?? ""
        recommendedTechStack = try container.decodeIfPresent(
            [String].self,
            forKey: .recommendedTechStack
        ) ?? []
        architectureStyle = try container.decodeIfPresent(String.self, forKey: .architectureStyle) ?? ""
        mainFeatures = try container.decodeIfPresent([String].self, forKey: .mainFeatures)
            ?? container.decodeIfPresent([String].self, forKey: .goals)
            ?? []
        suggestedFolderStructure = try container.decodeIfPresent(
            [String].self,
            forKey: .suggestedFolderStructure
        ) ?? []
        databaseRequirement = try container.decodeIfPresent(String.self, forKey: .databaseRequirement) ?? ""
        authenticationRequirement = try container.decodeIfPresent(
            String.self,
            forKey: .authenticationRequirement
        ) ?? ""
        apiRequirement = try container.decodeIfPresent(String.self, forKey: .apiRequirement) ?? ""
        initialMilestones = try container.decodeIfPresent([String].self, forKey: .initialMilestones) ?? []
        generatedAt = try container.decodeIfPresent(Date.self, forKey: .generatedAt) ?? Date()
        sourceDiscoverySessionID = try container.decodeIfPresent(UUID.self, forKey: .sourceDiscoverySessionID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(projectSummary, forKey: .projectSummary)
        try container.encode(recommendedTechStack, forKey: .recommendedTechStack)
        try container.encode(architectureStyle, forKey: .architectureStyle)
        try container.encode(mainFeatures, forKey: .mainFeatures)
        try container.encode(suggestedFolderStructure, forKey: .suggestedFolderStructure)
        try container.encode(databaseRequirement, forKey: .databaseRequirement)
        try container.encode(authenticationRequirement, forKey: .authenticationRequirement)
        try container.encode(apiRequirement, forKey: .apiRequirement)
        try container.encode(initialMilestones, forKey: .initialMilestones)
        try container.encode(generatedAt, forKey: .generatedAt)
        try container.encodeIfPresent(sourceDiscoverySessionID, forKey: .sourceDiscoverySessionID)
    }
}
