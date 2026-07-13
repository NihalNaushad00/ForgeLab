import SwiftUI

struct ProjectOverviewView: View {
    let project: Project
    let onStartDiscovery: () -> Void
    let onGeneratePlan: () -> Void

    init(
        project: Project,
        onStartDiscovery: @escaping () -> Void = {},
        onGeneratePlan: @escaping () -> Void = {}
    ) {
        self.project = project
        self.onStartDiscovery = onStartDiscovery
        self.onGeneratePlan = onGeneratePlan
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

                projectOverview
                discoveryOverview
                plannerOverview

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Overview")
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

    private var plannerOverview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Planner")
                        .font(.headline)

                    Text(plannerStatusText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    onGeneratePlan()
                } label: {
                    Label(plannerActionTitle, systemImage: plannerActionIcon)
                }
                .buttonStyle(.borderedProminent)
                .disabled(project.discoverySession == nil)
            }

            if let productSpecification = project.productSpecification {
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                    GridRow {
                        Text("Generated")
                            .foregroundStyle(.secondary)
                        Text(DateFormatter.forgeLabProjectDate.string(from: productSpecification.generatedAt))
                    }

                    GridRow {
                        Text("Milestones")
                            .foregroundStyle(.secondary)
                        Text("\(productSpecification.initialMilestones.count)")
                    }
                }
                .font(.body)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Plan Summary")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(productSpecification.projectSummary)
                        .font(.body)
                        .foregroundStyle(.secondary)
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

    private var plannerStatusText: String {
        if project.discoverySession == nil {
            "Complete Discovery before generating a structured Product Specification."
        } else if project.productSpecification == nil {
            "Discovery is complete. Generate a Product Specification from the saved answers."
        } else {
            "A Product Specification has been generated and saved with this project."
        }
    }

    private var plannerActionTitle: String {
        project.productSpecification == nil ? "Generate Project Plan" : "View Project Plan"
    }

    private var plannerActionIcon: String {
        project.productSpecification == nil ? "wand.and.stars" : "doc.text"
    }
}

struct WorkspacePlaceholderView: View {
    let section: WorkspaceSection
    let project: Project

    var body: some View {
        ContentUnavailableView(
            section.title,
            systemImage: section.systemImage,
            description: Text("This section is reserved for a future milestone for \(project.name).")
        )
        .navigationTitle(section.title)
    }
}

#Preview {
    ProjectOverviewView(
        project: Project(name: "Sample Project", type: .iOSApp),
        onStartDiscovery: {},
        onGeneratePlan: {}
    )
}

#Preview {
    WorkspacePlaceholderView(
        section: .specifications,
        project: Project(name: "Sample Project", type: .iOSApp)
    )
}
