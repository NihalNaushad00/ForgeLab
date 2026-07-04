import Foundation

struct Project: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var name: String
    var summary: String
    var requirements: [String]
    var productSpecification: ProductSpecification?
    var buildSpecification: BuildSpecification?
    var milestones: [Milestone]
    var workPackages: [WorkPackage]
    var tasks: [ProjectTask]
    var architectureDecisions: [ArchitectureDecision]
    var validationReports: [ValidationReport]
    var learningResources: [String]
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        summary: String = "",
        requirements: [String] = [],
        productSpecification: ProductSpecification? = nil,
        buildSpecification: BuildSpecification? = nil,
        milestones: [Milestone] = [],
        workPackages: [WorkPackage] = [],
        tasks: [ProjectTask] = [],
        architectureDecisions: [ArchitectureDecision] = [],
        validationReports: [ValidationReport] = [],
        learningResources: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.requirements = requirements
        self.productSpecification = productSpecification
        self.buildSpecification = buildSpecification
        self.milestones = milestones
        self.workPackages = workPackages
        self.tasks = tasks
        self.architectureDecisions = architectureDecisions
        self.validationReports = validationReports
        self.learningResources = learningResources
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
