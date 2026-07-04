import Foundation

protocol ProjectRepository: Sendable {
    func fetchProjects() async throws -> [Project]
    func save(_ project: Project) async throws
}
