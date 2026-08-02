import Foundation
import Combine

@MainActor
final class ProjectDigitalTwinViewModel: ObservableObject {
    @Published private(set) var project: Project

    init(project: Project) {
        self.project = project
    }

    var digitalTwin: ProjectDigitalTwin {
        project.digitalTwin
    }
}
