import SwiftUI

struct ProjectRowView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(project.name)
                .font(.headline)

            HStack(spacing: 8) {
                Text(project.type.displayName)
                Text(DateFormatter.forgeLabProjectDate.string(from: project.updatedAt))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProjectRowView(
        project: Project(
            name: "Example App",
            summary: "A sample project.",
            type: .iOSApp
        )
    )
}
