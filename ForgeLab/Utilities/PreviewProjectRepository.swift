import Foundation

struct PreviewProjectRepository: ProjectRepository {
    func fetchProjects() async throws -> [Project] {
        [makePreviewProject()]
    }

    func project(withID id: UUID) async throws -> Project? {
        try await fetchProjects().first { $0.id == id }
    }

    func save(_ project: Project) async throws {}

    func deleteProject(withID id: UUID) async throws {}

    private func makePreviewProject() -> Project {
        var project = Project(
            name: "Sample Project",
            summary: "A preview project for SwiftUI canvas rendering.",
            type: .iOSApp,
            productSpecification: ProductSpecification(
                projectSummary: "A sample iOS app for previewing ForgeLab planning workflows.",
                recommendedTechStack: ["Swift", "SwiftUI", "MVVM", "Local JSON persistence"],
                architectureStyle: "Simple MVVM with feature folders and repository-backed persistence.",
                mainFeatures: ["Project list", "Guided discovery", "Planner summary"],
                suggestedFolderStructure: ["App/", "Core/Persistence/", "Features/", "Models/", "Services/"],
                databaseRequirement: "Local persistence is enough for the first version.",
                authenticationRequirement: "Authentication is not required for the first version.",
                apiRequirement: "No external API requirement is explicit in discovery.",
                initialMilestones: ["Build core models", "Implement primary workflow", "Persist project state"]
            ),
            discoverySession: DiscoverySession(
                answers: DiscoveryQuestion.all.map {
                    DiscoveryAnswer(
                        questionID: $0.id,
                        prompt: $0.prompt,
                        category: $0.category,
                        response: "Preview answer"
                    )
                }
            )
        )
        project.digitalTwin = ProjectDigitalTwinBuilder().buildTwin(
            for: project,
            updatedAt: project.updatedAt
        )
        return project
    }
}
