import Foundation

protocol ProjectStore: Sendable {
    func loadProjects() async throws -> [Project]
    func saveProjects(_ projects: [Project]) async throws
}
