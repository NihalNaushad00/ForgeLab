import Foundation

struct Project: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var name: String
    var summary: String
    var type: ProjectType
    var requirements: [String]
    var productSpecification: ProductSpecification?
    var buildSpecification: BuildSpecification?
    var milestones: [Milestone]
    var workPackages: [WorkPackage]
    var tasks: [ProjectTask]
    var architectureDecisions: [ArchitectureDecision]
    var validationReports: [ValidationReport]
    var learningResources: [String]
    var discoverySession: DiscoverySession?
    let createdAt: Date
    var updatedAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary
        case type
        case requirements
        case productSpecification
        case buildSpecification
        case milestones
        case workPackages
        case tasks
        case architectureDecisions
        case validationReports
        case learningResources
        case discoverySession
        case createdAt
        case updatedAt
    }

    init(
        id: UUID = UUID(),
        name: String,
        summary: String = "",
        type: ProjectType = .iOSApp,
        requirements: [String] = [],
        productSpecification: ProductSpecification? = nil,
        buildSpecification: BuildSpecification? = nil,
        milestones: [Milestone] = [],
        workPackages: [WorkPackage] = [],
        tasks: [ProjectTask] = [],
        architectureDecisions: [ArchitectureDecision] = [],
        validationReports: [ValidationReport] = [],
        learningResources: [String] = [],
        discoverySession: DiscoverySession? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.type = type
        self.requirements = requirements
        self.productSpecification = productSpecification
        self.buildSpecification = buildSpecification
        self.milestones = milestones
        self.workPackages = workPackages
        self.tasks = tasks
        self.architectureDecisions = architectureDecisions
        self.validationReports = validationReports
        self.learningResources = learningResources
        self.discoverySession = discoverySession
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? ""
        type = try container.decodeIfPresent(ProjectType.self, forKey: .type) ?? .iOSApp
        requirements = try container.decodeIfPresent([String].self, forKey: .requirements) ?? []
        productSpecification = try container.decodeIfPresent(
            ProductSpecification.self,
            forKey: .productSpecification
        )
        buildSpecification = try container.decodeIfPresent(
            BuildSpecification.self,
            forKey: .buildSpecification
        )
        milestones = try container.decodeIfPresent([Milestone].self, forKey: .milestones) ?? []
        workPackages = try container.decodeIfPresent([WorkPackage].self, forKey: .workPackages) ?? []
        tasks = try container.decodeIfPresent([ProjectTask].self, forKey: .tasks) ?? []
        architectureDecisions = try container.decodeIfPresent(
            [ArchitectureDecision].self,
            forKey: .architectureDecisions
        ) ?? []
        validationReports = try container.decodeIfPresent(
            [ValidationReport].self,
            forKey: .validationReports
        ) ?? []
        learningResources = try container.decodeIfPresent([String].self, forKey: .learningResources) ?? []
        discoverySession = try container.decodeIfPresent(DiscoverySession.self, forKey: .discoverySession)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? createdAt
    }
}
