# ForgeLab

ForgeLab is an iOS application for helping students and beginner developers turn software ideas into production-quality projects through a documentation-first workflow.

The central object in the app is the `Project`. A project can contain requirements, specifications, documentation, milestones, work packages, tasks, generated files, validation reports, architecture decisions, and learning resources.

## Current Scope

This repository currently implements the project management foundation:

- SwiftUI iOS app shell.
- MVVM feature structure.
- Lightweight core domain models.
- Local JSON persistence foundation behind protocols.
- Project list, creation, editing, deletion, and detail views.
- Project workspace navigation with real project overview metadata.
- Starter documentation structure.

The current version intentionally does not include AI integrations, networking, authentication, cloud sync, team collaboration, or code generation workflows.

## Repository Structure

```text
ForgeLab/
  App/                         App entry point and composition root
  Core/Persistence/            Persistence interfaces and local store
  Features/ProjectManagement/  Project list, details, and edit flows
  Features/ProjectWorkspace/   Workspace MVVM feature
  Models/                      Core domain models
  Resources/                   Asset catalog
  Services/                    App services and repositories
  Utilities/                   Preview and development helpers
Documentation/                 Planning and engineering documentation
ForgeLab.xcodeproj/    Xcode project
```

## Development

Open `ForgeLab.xcodeproj` in Xcode and run the `ForgeLab` scheme on an iOS simulator.

The current environment only has Command Line Tools selected, so command-line `xcodebuild` verification requires switching `xcode-select` to a full Xcode installation.

## Milestone 2 Features

- View locally stored projects.
- Create projects with name, optional description, and type.
- Edit project name, description, and type.
- Delete projects after confirmation.
- Open an existing project into its workspace.
- Persist project changes locally between launches.

## Milestone 2 Implementation Notes

Architecture decisions:

- Project management was added as a new feature module beside the existing workspace module.
- The existing repository pattern was extended with read-by-id and delete operations.
- `Project` now stores `ProjectType` because type is required for creation, list display, and details.
- JSON persistence keeps the existing implementation and adds graceful fallback for invalid stored data.

Files added:

- `ForgeLab/Models/ProjectType.swift`
- `ForgeLab/Features/ProjectManagement/ViewModels/ProjectListViewModel.swift`
- `ForgeLab/Features/ProjectManagement/ViewModels/ProjectFormViewModel.swift`
- `ForgeLab/Features/ProjectManagement/Views/ProjectListView.swift`
- `ForgeLab/Features/ProjectManagement/Views/ProjectRowView.swift`
- `ForgeLab/Features/ProjectManagement/Views/ProjectFormView.swift`
- `ForgeLab/Features/ProjectManagement/Views/ProjectDetailView.swift`
- `ForgeLab/Utilities/DateFormatter+ForgeLab.swift`

Files modified:

- `ForgeLab/App/ForgeLabApp.swift`
- `ForgeLab/Models/Project.swift`
- `ForgeLab/Core/Persistence/JSONProjectStore.swift`
- `ForgeLab/Services/ProjectRepository.swift`
- `ForgeLab/Services/LocalProjectRepository.swift`
- `ForgeLab/Features/ProjectWorkspace/ViewModels/ProjectWorkspaceViewModel.swift`
- `ForgeLab/Features/ProjectWorkspace/Views/ProjectWorkspaceView.swift`
- `ForgeLab/Features/ProjectWorkspace/Views/WorkspacePlaceholderView.swift`
- `ForgeLab/Utilities/PreviewProjectRepository.swift`
- `ForgeLab.xcodeproj/project.pbxproj`
- `README.md`
- `ROADMAP.md`
- `CHANGELOG.md`
