import Foundation

struct CodingAgent {
    func generateWorkflow(for project: Project) -> Project? {
        guard let specification = project.productSpecification else {
            return nil
        }

        var updatedProject = project
        let codingAgentWorkPackageIDs = Set(
            updatedProject.workPackages
                .filter { $0.source == .codingAgent }
                .map(\.id)
        )
        updatedProject.workPackages.removeAll { $0.source == .codingAgent }
        updatedProject.tasks.removeAll { task in
            guard let workPackageID = task.workPackageID else {
                return false
            }

            return codingAgentWorkPackageIDs.contains(workPackageID)
        }

        let generatedWorkPackages = makeWorkPackages(from: specification)
        var workPackages: [WorkPackage] = []
        var tasks: [ProjectTask] = []

        for packageDefinition in generatedWorkPackages {
            let workPackageID = UUID()
            let packageTasks = makeTasks(
                for: packageDefinition.title,
                summary: packageDefinition.summary,
                workPackageID: workPackageID
            )

            workPackages.append(
                WorkPackage(
                    id: workPackageID,
                    title: packageDefinition.title,
                    summary: packageDefinition.summary,
                    taskIDs: packageTasks.map(\.id),
                    source: .codingAgent
                )
            )
            tasks.append(contentsOf: packageTasks)
        }

        let queue = makeQueue(workPackages: workPackages)
        updatedProject.workPackages.append(contentsOf: workPackages)
        updatedProject.tasks.append(contentsOf: applyQueueStatuses(to: tasks, queue: queue))
        updatedProject.codingAgentState = CodingAgentState(
            status: queue.inProgressTaskIDs.isEmpty ? .generated : .inProgress,
            queue: queue,
            currentWorkPackageID: workPackages.first?.id,
            currentTaskID: queue.inProgressTaskIDs.first,
            sourceProductSpecificationID: specification.id,
            generatedAt: Date(),
            updatedAt: Date()
        )

        return updatedProject
    }

    func completeCurrentTask(for project: Project) -> Project {
        var updatedProject = project
        guard let currentTaskID = updatedProject.codingAgentState.currentTaskID else {
            return updatedProject
        }

        updatedProject.codingAgentState.queue.inProgressTaskIDs.removeAll { $0 == currentTaskID }
        updatedProject.codingAgentState.queue.completedTaskIDs.append(currentTaskID)
        updateTask(currentTaskID, in: &updatedProject.tasks, status: .done)

        if let nextPendingTaskID = updatedProject.codingAgentState.queue.pendingTaskIDs.first {
            startTask(nextPendingTaskID, in: &updatedProject)
        } else if let nextFuturePackage = nextFutureWorkPackage(in: updatedProject) {
            startWorkPackage(nextFuturePackage, in: &updatedProject)
        } else {
            updatedProject.codingAgentState.currentTaskID = nil
            updatedProject.codingAgentState.currentWorkPackageID = nil
            updatedProject.codingAgentState.status = .completed
        }

        updatedProject.codingAgentState.updatedAt = Date()
        return updatedProject
    }

    private func makeWorkPackages(from specification: ProductSpecification) -> [WorkPackageDefinition] {
        var definitions = [
            WorkPackageDefinition(
                title: "Project Foundation",
                summary: "Set up the app structure, core models, and initial navigation described by the Planner."
            )
        ]

        definitions.append(
            contentsOf: specification.mainFeatures.map {
                WorkPackageDefinition(
                    title: normalizedFeatureTitle($0),
                    summary: "Implement the \(normalizedFeatureTitle($0)) feature from the Product Specification."
                )
            }
        )

        if requiresImplementation(specification.authenticationRequirement) {
            definitions.append(
                WorkPackageDefinition(
                    title: "Authentication",
                    summary: specification.authenticationRequirement
                )
            )
        }

        if requiresImplementation(specification.databaseRequirement) {
            definitions.append(
                WorkPackageDefinition(
                    title: "Persistence Layer",
                    summary: specification.databaseRequirement
                )
            )
        }

        if requiresImplementation(specification.apiRequirement) {
            definitions.append(
                WorkPackageDefinition(
                    title: "API Layer",
                    summary: specification.apiRequirement
                )
            )
        }

        definitions.append(
            WorkPackageDefinition(
                title: "Settings",
                summary: "Add basic project settings and configuration surfaces needed by the first version."
            )
        )

        definitions.append(
            WorkPackageDefinition(
                title: "Polish and Review",
                summary: "Review empty states, error states, accessibility, and readiness for future validation."
            )
        )

        return uniqueDefinitions(definitions)
    }

    private func makeTasks(
        for title: String,
        summary: String,
        workPackageID: UUID
    ) -> [ProjectTask] {
        [
            ProjectTask(
                title: "Define \(title) requirements",
                notes: summary,
                workPackageID: workPackageID
            ),
            ProjectTask(
                title: "Create \(title) model updates",
                notes: "Identify domain state and persistence requirements for this work package.",
                workPackageID: workPackageID
            ),
            ProjectTask(
                title: "Create \(title) view model",
                notes: "Prepare presentation state and user actions for this work package.",
                workPackageID: workPackageID
            ),
            ProjectTask(
                title: "Create \(title) UI",
                notes: "Build the SwiftUI surface after the model and view model are ready.",
                workPackageID: workPackageID
            ),
            ProjectTask(
                title: "Plan \(title) verification",
                notes: "Define the manual checks or future tests needed for this work package without running validation.",
                workPackageID: workPackageID
            ),
            ProjectTask(
                title: "Review \(title) workflow",
                notes: "Manually review navigation, persistence, and expected user flow.",
                workPackageID: workPackageID
            )
        ]
    }

    private func makeQueue(workPackages: [WorkPackage]) -> CodingQueue {
        guard let firstPackage = workPackages.first, let firstTaskID = firstPackage.taskIDs.first else {
            return CodingQueue()
        }

        let pendingTaskIDs = Array(firstPackage.taskIDs.dropFirst())
        let futureTaskIDs = workPackages
            .dropFirst()
            .flatMap(\.taskIDs)

        return CodingQueue(
            pendingTaskIDs: pendingTaskIDs,
            inProgressTaskIDs: [firstTaskID],
            completedTaskIDs: [],
            futureTaskIDs: futureTaskIDs
        )
    }

    private func applyQueueStatuses(to tasks: [ProjectTask], queue: CodingQueue) -> [ProjectTask] {
        tasks.map { task in
            var updatedTask = task

            if queue.inProgressTaskIDs.contains(task.id) {
                updatedTask.status = .doing
            } else {
                updatedTask.status = .todo
            }

            return updatedTask
        }
    }

    private func startTask(_ taskID: UUID, in project: inout Project) {
        project.codingAgentState.queue.pendingTaskIDs.removeAll { $0 == taskID }
        project.codingAgentState.queue.inProgressTaskIDs = [taskID]
        project.codingAgentState.currentTaskID = taskID
        project.codingAgentState.currentWorkPackageID = project.tasks
            .first { $0.id == taskID }?
            .workPackageID
        project.codingAgentState.status = .inProgress
        updateTask(taskID, in: &project.tasks, status: .doing)
    }

    private func startWorkPackage(_ workPackage: WorkPackage, in project: inout Project) {
        guard let firstTaskID = workPackage.taskIDs.first else {
            return
        }

        project.codingAgentState.queue.futureTaskIDs.removeAll { workPackage.taskIDs.contains($0) }
        project.codingAgentState.queue.pendingTaskIDs = Array(workPackage.taskIDs.dropFirst())
        project.codingAgentState.queue.inProgressTaskIDs = [firstTaskID]
        project.codingAgentState.currentWorkPackageID = workPackage.id
        project.codingAgentState.currentTaskID = firstTaskID
        project.codingAgentState.status = .inProgress
        updateTask(firstTaskID, in: &project.tasks, status: .doing)
    }

    private func nextFutureWorkPackage(in project: Project) -> WorkPackage? {
        project.workPackages.first { workPackage in
            workPackage.source == .codingAgent
                && workPackage.taskIDs.contains { project.codingAgentState.queue.futureTaskIDs.contains($0) }
        }
    }

    private func updateTask(_ taskID: UUID, in tasks: inout [ProjectTask], status: TaskStatus) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else {
            return
        }

        tasks[index].status = status
    }

    private func requiresImplementation(_ text: String) -> Bool {
        let normalizedText = text.lowercased()

        if normalizedText.contains("not required")
            || normalizedText.contains("no external api requirement")
            || normalizedText.contains("not explicit") {
            return false
        }

        return normalizedText.contains("required")
            || normalizedText.contains("likely")
            || normalizedText.contains("unclear")
    }

    private func normalizedFeatureTitle(_ title: String) -> String {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            return "Core Feature"
        }

        return trimmedTitle
    }

    private func uniqueDefinitions(_ definitions: [WorkPackageDefinition]) -> [WorkPackageDefinition] {
        var seenTitles: Set<String> = []

        return definitions.filter { definition in
            let normalizedTitle = definition.title.lowercased()
            guard !seenTitles.contains(normalizedTitle) else {
                return false
            }

            seenTitles.insert(normalizedTitle)
            return true
        }
    }
}

private struct WorkPackageDefinition {
    var title: String
    var summary: String
}
