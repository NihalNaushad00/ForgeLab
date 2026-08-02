import Foundation
import Combine

@MainActor
final class PlannerSummaryViewModel: ObservableObject {
    @Published private(set) var project: Project
    @Published private(set) var isGenerating = false
    @Published private(set) var errorMessage: String?

    private let projectRepository: ProjectRepository
    private let plannerAgent: PlannerAgent

    init(
        project: Project,
        projectRepository: ProjectRepository,
        plannerAgent: PlannerAgent = PlannerAgent()
    ) {
        self.project = project
        self.projectRepository = projectRepository
        self.plannerAgent = plannerAgent
    }

    var productSpecification: ProductSpecification? {
        project.productSpecification
    }

    var canGeneratePlan: Bool {
        project.discoverySession != nil
    }

    func generatePlan() async -> Project? {
        guard !isGenerating else {
            return nil
        }

        guard let updatedProject = makeProjectWithGeneratedPlan() else {
            errorMessage = "Complete Discovery before generating a project plan."
            return nil
        }

        isGenerating = true
        defer { isGenerating = false }

        do {
            try await projectRepository.save(updatedProject)
            project = try await projectRepository.project(withID: updatedProject.id) ?? updatedProject
            errorMessage = nil
            return project
        } catch {
            errorMessage = "Project plan could not be saved."
            return nil
        }
    }

    func clearError() {
        errorMessage = nil
    }

    private func makeProjectWithGeneratedPlan() -> Project? {
        guard let specification = plannerAgent.generateSpecification(for: project) else {
            return nil
        }

        var updatedProject = project
        updatedProject.productSpecification = specification
        return updatedProject
    }
}
