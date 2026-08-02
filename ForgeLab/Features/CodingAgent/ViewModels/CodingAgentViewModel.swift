import Foundation
import Combine

@MainActor
final class CodingAgentViewModel: ObservableObject {
    @Published private(set) var project: Project
    @Published private(set) var isSaving = false
    @Published private(set) var errorMessage: String?

    private let projectRepository: ProjectRepository
    private let codingAgent: CodingAgent

    init(
        project: Project,
        projectRepository: ProjectRepository,
        codingAgent: CodingAgent = CodingAgent()
    ) {
        self.project = project
        self.projectRepository = projectRepository
        self.codingAgent = codingAgent
    }

    var productSpecification: ProductSpecification? {
        project.productSpecification
    }

    var canGenerateWorkflow: Bool {
        productSpecification != nil && !isSaving
    }

    var statusText: String {
        project.codingAgentState.status.displayName
    }

    var generatedWorkPackages: [WorkPackage] {
        project.workPackages.filter { $0.source == .codingAgent }
    }

    var currentWorkPackage: WorkPackage? {
        generatedWorkPackages.first { $0.id == project.codingAgentState.currentWorkPackageID }
    }

    var currentTask: ProjectTask? {
        project.tasks.first { $0.id == project.codingAgentState.currentTaskID }
    }

    var currentMilestone: String {
        currentWorkPackage?.title
            ?? project.productSpecification?.initialMilestones.first
            ?? "Coding Agent"
    }

    var pendingTasks: [ProjectTask] {
        tasks(for: project.codingAgentState.queue.pendingTaskIDs)
    }

    var inProgressTasks: [ProjectTask] {
        tasks(for: project.codingAgentState.queue.inProgressTaskIDs)
    }

    var completedTasks: [ProjectTask] {
        tasks(for: project.codingAgentState.queue.completedTaskIDs)
    }

    var futureTasks: [ProjectTask] {
        tasks(for: project.codingAgentState.queue.futureTaskIDs)
    }

    func generateWorkflow() async -> Project? {
        guard canGenerateWorkflow else {
            errorMessage = "Generate a Product Specification before using the Coding Agent."
            return nil
        }

        guard let updatedProject = codingAgent.generateWorkflow(for: project) else {
            errorMessage = "Generate a Product Specification before using the Coding Agent."
            return nil
        }

        return await save(updatedProject, errorMessage: "Coding workflow could not be saved.")
    }

    func completeCurrentTask() async -> Project? {
        guard project.codingAgentState.currentTaskID != nil else {
            return nil
        }

        let updatedProject = codingAgent.completeCurrentTask(for: project)
        return await save(updatedProject, errorMessage: "Task progress could not be saved.")
    }

    func clearError() {
        errorMessage = nil
    }

    private func save(_ updatedProject: Project, errorMessage: String) async -> Project? {
        isSaving = true
        defer { isSaving = false }

        do {
            try await projectRepository.save(updatedProject)
            project = try await projectRepository.project(withID: updatedProject.id) ?? updatedProject
            self.errorMessage = nil
            return project
        } catch {
            self.errorMessage = errorMessage
            return nil
        }
    }

    private func tasks(for taskIDs: [UUID]) -> [ProjectTask] {
        taskIDs.compactMap { taskID in
            project.tasks.first { $0.id == taskID }
        }
    }
}
