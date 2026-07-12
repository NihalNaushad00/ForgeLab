import SwiftUI

struct WorkspacePlaceholderView: View {
    let project: Project
    let section: WorkspaceSection
    let onStartDiscovery: () -> Void

    init(
        project: Project,
        section: WorkspaceSection,
        onStartDiscovery: @escaping () -> Void = {}
    ) {
        self.project = project
        self.section = section
        self.onStartDiscovery = onStartDiscovery
    }

    var body: some View {
        ScrollView {
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
                    discoveryOverview
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
        }
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

    private var discoveryOverview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Discovery")
                        .font(.headline)

                    Text(discoveryStatusText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    onStartDiscovery()
                } label: {
                    Label(discoveryActionTitle, systemImage: discoveryActionIcon)
                }
                .buttonStyle(.borderedProminent)
            }

            if let discoverySession = project.discoverySession {
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                    GridRow {
                        Text("Completed")
                            .foregroundStyle(.secondary)
                        Text(DateFormatter.forgeLabProjectDate.string(from: discoverySession.completedAt))
                    }

                    GridRow {
                        Text("Answers")
                            .foregroundStyle(.secondary)
                        Text("\(discoverySession.answers.count)")
                    }
                }
                .font(.body)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(discoverySession.answers) { answer in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(answer.prompt)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(answer.response)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }

    private var discoveryStatusText: String {
        if project.discoverySession == nil {
            "Start a guided question flow to capture the project context before planning."
        } else {
            "Discovery is complete. You can review or edit the saved answers."
        }
    }

    private var discoveryActionTitle: String {
        project.discoverySession == nil ? "Start Discovery" : "View Discovery"
    }

    private var discoveryActionIcon: String {
        project.discoverySession == nil ? "sparkles" : "doc.text.magnifyingglass"
    }
}

#Preview {
    WorkspacePlaceholderView(
        project: Project(name: "Sample Project", type: .iOSApp),
        section: .overview
    )
}
