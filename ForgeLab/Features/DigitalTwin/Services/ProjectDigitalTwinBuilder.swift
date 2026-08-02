import Foundation

struct ProjectDigitalTwinBuilder {
    func buildTwin(for project: Project, updatedAt: Date = Date()) -> ProjectDigitalTwin {
        let completedSteps = completedStepCount(for: project)
        let productSpecification = project.productSpecification.map(makeProductSpecification)

        return ProjectDigitalTwin(
            id: project.digitalTwin.id,
            projectID: project.id,
            projectInformation: ProjectDigitalTwinProjectInformation(
                name: project.name,
                summary: project.summary,
                type: project.type.displayName,
                createdAt: project.createdAt,
                updatedAt: updatedAt
            ),
            discoveryAnswers: project.discoverySession?.answers.map(makeDiscoveryAnswer) ?? [],
            productSpecification: productSpecification,
            plannerOutput: project.productSpecification.map(makePlannerOutput),
            currentStatus: currentStatus(for: project),
            progress: ProjectDigitalTwinProgress(completedSteps: completedSteps, totalSteps: 4),
            currentMilestone: currentMilestone(for: project),
            codingSummary: makeCodingSummary(for: project),
            lastUpdated: updatedAt
        )
    }

    private func makeDiscoveryAnswer(_ answer: DiscoveryAnswer) -> ProjectDigitalTwinDiscoveryAnswer {
        ProjectDigitalTwinDiscoveryAnswer(
            questionID: answer.questionID,
            prompt: answer.prompt,
            category: answer.category,
            response: answer.response
        )
    }

    private func makeProductSpecification(
        _ specification: ProductSpecification
    ) -> ProjectDigitalTwinProductSpecification {
        ProjectDigitalTwinProductSpecification(
            projectSummary: specification.projectSummary,
            recommendedTechStack: specification.recommendedTechStack,
            architectureStyle: specification.architectureStyle,
            mainFeatures: specification.mainFeatures,
            suggestedFolderStructure: specification.suggestedFolderStructure,
            databaseRequirement: specification.databaseRequirement,
            authenticationRequirement: specification.authenticationRequirement,
            apiRequirement: specification.apiRequirement,
            initialMilestones: specification.initialMilestones,
            generatedAt: specification.generatedAt
        )
    }

    private func makePlannerOutput(_ specification: ProductSpecification) -> ProjectDigitalTwinPlannerOutput {
        ProjectDigitalTwinPlannerOutput(
            specificationID: specification.id,
            sourceDiscoverySessionID: specification.sourceDiscoverySessionID,
            generatedAt: specification.generatedAt,
            summary: specification.projectSummary,
            milestoneCount: specification.initialMilestones.count,
            featureCount: specification.mainFeatures.count
        )
    }

    private func completedStepCount(for project: Project) -> Int {
        var completedSteps = 1

        if project.discoverySession != nil {
            completedSteps += 1
        }

        if project.productSpecification != nil {
            completedSteps += 1
        }

        if project.codingAgentState.status != .notStarted {
            completedSteps += 1
        }

        return completedSteps
    }

    private func currentStatus(for project: Project) -> String {
        if project.codingAgentState.status == .completed {
            return "Coding workflow complete"
        }

        if project.codingAgentState.status == .inProgress {
            return "Coding workflow in progress"
        }

        if project.codingAgentState.status == .generated {
            return "Coding workflow generated"
        }

        if project.productSpecification != nil {
            return "Product Specification generated"
        }

        if project.discoverySession != nil {
            return "Discovery complete"
        }

        return "Project created"
    }

    private func currentMilestone(for project: Project) -> String {
        if let currentWorkPackage = project.workPackages.first(
            where: { $0.id == project.codingAgentState.currentWorkPackageID }
        ) {
            return currentWorkPackage.title
        }

        if let milestone = project.productSpecification?.initialMilestones.first {
            return milestone
        }

        if project.discoverySession != nil {
            return "Project Planner"
        }

        return "Discovery"
    }

    private func makeCodingSummary(for project: Project) -> ProjectDigitalTwinCodingSummary? {
        guard project.codingAgentState.status != .notStarted else {
            return nil
        }

        return ProjectDigitalTwinCodingSummary(
            status: project.codingAgentState.status.displayName,
            workPackageCount: project.workPackages.filter { $0.source == .codingAgent }.count,
            taskCount: project.tasks.filter { $0.workPackageID != nil }.count,
            pendingTaskCount: project.codingAgentState.queue.pendingTaskIDs.count,
            inProgressTaskCount: project.codingAgentState.queue.inProgressTaskIDs.count,
            completedTaskCount: project.codingAgentState.queue.completedTaskIDs.count,
            futureTaskCount: project.codingAgentState.queue.futureTaskIDs.count
        )
    }
}
