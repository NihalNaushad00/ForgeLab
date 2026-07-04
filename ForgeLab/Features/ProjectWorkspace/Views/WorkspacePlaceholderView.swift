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

            if section == .overview {
                projectOverview
            } else {
                ContentUnavailableView(
                    section.title,
                    systemImage: section.systemImage,
                    description: Text("This section is reserved for a future milestone.")
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle(section.title)
    }

    private var projectOverview: some View {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
            GridRow {
                Text("Type")
                    .foregroundStyle(.secondary)
                Text(project.type.displayName)
            }

            GridRow {
                Text("Created")
                    .foregroundStyle(.secondary)
                Text(DateFormatter.forgeLabProjectDate.string(from: project.createdAt))
            }

            GridRow {
                Text("Last Modified")
                    .foregroundStyle(.secondary)
                Text(DateFormatter.forgeLabProjectDate.string(from: project.updatedAt))
            }
        }
        .font(.body)
    }
}

#Preview {
    WorkspacePlaceholderView(
        project: Project(name: "Sample Project", type: .iOSApp),
        section: .overview
    )
}
