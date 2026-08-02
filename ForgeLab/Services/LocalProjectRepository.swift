import Foundation

actor LocalProjectRepository: ProjectRepository {
    private let store: ProjectStore
    private let digitalTwinBuilder: ProjectDigitalTwinBuilder

    init(store: ProjectStore, digitalTwinBuilder: ProjectDigitalTwinBuilder = ProjectDigitalTwinBuilder()) {
        self.store = store
        self.digitalTwinBuilder = digitalTwinBuilder
    }

    func fetchProjects() async throws -> [Project] {
        let projects = try await store.loadProjects()
        let normalizedProjects = projects.map(normalizedProject)

        if normalizedProjects != projects {
            try await store.saveProjects(normalizedProjects)
        }

        return normalizedProjects
    }

    func project(withID id: UUID) async throws -> Project? {
        try await fetchProjects().first { $0.id == id }
    }

    func save(_ project: Project) async throws {
        var projectToSave = project
        projectToSave.updatedAt = Date()
        projectToSave.digitalTwin = digitalTwinBuilder.buildTwin(
            for: projectToSave,
            updatedAt: projectToSave.updatedAt
        )

        var projects = try await store.loadProjects()

        if let index = projects.firstIndex(where: { $0.id == projectToSave.id }) {
            projects[index] = projectToSave
        } else {
            projects.append(projectToSave)
        }

        try await store.saveProjects(projects)
    }

    func deleteProject(withID id: UUID) async throws {
        let projects = try await store.loadProjects()
            .filter { $0.id != id }

        try await store.saveProjects(projects)
    }

    private func normalizedProject(_ project: Project) -> Project {
        var normalizedProject = project
        normalizedProject.digitalTwin = digitalTwinBuilder.buildTwin(
            for: normalizedProject,
            updatedAt: normalizedProject.updatedAt
        )
        return normalizedProject
    }
}
