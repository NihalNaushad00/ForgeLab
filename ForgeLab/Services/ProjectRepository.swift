import Foundation

protocol ProjectRepository: Sendable {
    func fetchProjects() async throws -> [Project]
    func project(withID id: UUID) async throws -> Project?
    func save(_ project: Project) async throws
    func deleteProject(withID id: UUID) async throws
}
