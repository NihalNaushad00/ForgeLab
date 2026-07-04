import SwiftUI

struct WorkspacePlaceholderView: View {
    let project: Project
    let section: WorkspaceSection

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(project.name)
                    .font(.title)
                    .fontWeight(.semibold)

                Text(project.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Divider()

            ContentUnavailableView(
                section.title,
                systemImage: section.systemImage,
                description: Text("This section is reserved for a future milestone.")
            )

            Spacer()
        }
        .padding()
        .navigationTitle(section.title)
    }
}

#Preview {
    WorkspacePlaceholderView(
        project: Project(name: "Sample Project"),
        section: .overview
    )
}
