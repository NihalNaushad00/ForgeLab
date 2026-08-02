import Foundation

struct ProjectDigitalTwin: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let projectID: UUID
    var projectInformation: ProjectDigitalTwinProjectInformation
    var discoveryAnswers: [ProjectDigitalTwinDiscoveryAnswer]
    var productSpecification: ProjectDigitalTwinProductSpecification?
    var plannerOutput: ProjectDigitalTwinPlannerOutput?
    var currentStatus: String
    var progress: ProjectDigitalTwinProgress
    var currentMilestone: String
    var codingSummary: ProjectDigitalTwinCodingSummary?
    var lastUpdated: Date

    init(
        id: UUID = UUID(),
        projectID: UUID,
        projectInformation: ProjectDigitalTwinProjectInformation,
        discoveryAnswers: [ProjectDigitalTwinDiscoveryAnswer] = [],
        productSpecification: ProjectDigitalTwinProductSpecification? = nil,
        plannerOutput: ProjectDigitalTwinPlannerOutput? = nil,
        currentStatus: String = "Project created",
        progress: ProjectDigitalTwinProgress = ProjectDigitalTwinProgress(),
        currentMilestone: String = "Discovery",
        codingSummary: ProjectDigitalTwinCodingSummary? = nil,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.projectID = projectID
        self.projectInformation = projectInformation
        self.discoveryAnswers = discoveryAnswers
        self.productSpecification = productSpecification
        self.plannerOutput = plannerOutput
        self.currentStatus = currentStatus
        self.progress = progress
        self.currentMilestone = currentMilestone
        self.codingSummary = codingSummary
        self.lastUpdated = lastUpdated
    }

    static func bootstrap(
        projectID: UUID,
        name: String,
        summary: String,
        type: ProjectType,
        createdAt: Date,
        updatedAt: Date
    ) -> ProjectDigitalTwin {
        ProjectDigitalTwin(
            projectID: projectID,
            projectInformation: ProjectDigitalTwinProjectInformation(
                name: name,
                summary: summary,
                type: type.displayName,
                createdAt: createdAt,
                updatedAt: updatedAt
            ),
            lastUpdated: updatedAt
        )
    }
}

struct ProjectDigitalTwinProjectInformation: Codable, Equatable, Sendable {
    var name: String
    var summary: String
    var type: String
    var createdAt: Date
    var updatedAt: Date
}

struct ProjectDigitalTwinDiscoveryAnswer: Identifiable, Codable, Equatable, Sendable {
    var id: String { questionID }
    var questionID: String
    var prompt: String
    var category: String
    var response: String
}

struct ProjectDigitalTwinProductSpecification: Codable, Equatable, Sendable {
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
}

struct ProjectDigitalTwinPlannerOutput: Codable, Equatable, Sendable {
    var specificationID: UUID
    var sourceDiscoverySessionID: UUID?
    var generatedAt: Date
    var summary: String
    var milestoneCount: Int
    var featureCount: Int
}

struct ProjectDigitalTwinProgress: Codable, Equatable, Sendable {
    var completedSteps: Int
    var totalSteps: Int
    var completionPercentage: Int

    init(completedSteps: Int = 0, totalSteps: Int = 3) {
        self.completedSteps = completedSteps
        self.totalSteps = totalSteps

        guard totalSteps > 0 else {
            completionPercentage = 0
            return
        }

        completionPercentage = Int((Double(completedSteps) / Double(totalSteps) * 100).rounded())
    }
}

struct ProjectDigitalTwinCodingSummary: Codable, Equatable, Sendable {
    var status: String
    var workPackageCount: Int
    var taskCount: Int
    var pendingTaskCount: Int
    var inProgressTaskCount: Int
    var completedTaskCount: Int
    var futureTaskCount: Int
}
