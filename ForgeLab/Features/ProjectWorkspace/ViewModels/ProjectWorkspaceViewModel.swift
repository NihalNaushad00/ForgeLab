import Foundation
import Combine

@MainActor
final class ProjectWorkspaceViewModel: ObservableObject {
    @Published private(set) var project: Project
    @Published var selectedSection: WorkspaceSection?

    private let projectRepository: ProjectRepository

    init(project: Project, projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
        self.project = project
    }

    func load() async {
        do {
            if let savedProject = try await projectRepository.project(withID: project.id) {
                project = savedProject
            }
        } catch {
            // The workspace remains usable with its current project snapshot.
        }
    }

    func makeDiscoverySessionViewModel() -> DiscoverySessionViewModel {
        DiscoverySessionViewModel(
            project: project,
            projectRepository: projectRepository
        )
    }

    func makePlannerSummaryViewModel() -> PlannerSummaryViewModel {
        PlannerSummaryViewModel(
            project: project,
            projectRepository: projectRepository
        )
    }

    func makeDigitalTwinViewModel() -> ProjectDigitalTwinViewModel {
        ProjectDigitalTwinViewModel(project: project)
    }

    func makeCodingAgentViewModel() -> CodingAgentViewModel {
        CodingAgentViewModel(
            project: project,
            projectRepository: projectRepository
        )
    }

    func updateProject(_ project: Project) {
        self.project = project
    }
}
