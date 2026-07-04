# ForgeLab

ForgeLab is an iOS application for helping students and beginner developers turn software ideas into production-quality projects through a documentation-first workflow.

The central object in the app is the `Project`. A project can contain requirements, specifications, documentation, milestones, work packages, tasks, generated files, validation reports, architecture decisions, and learning resources.

## Milestone 1 Scope

This repository currently implements the project foundation:

- SwiftUI iOS app shell.
- MVVM feature structure.
- Lightweight core domain models.
- Local JSON persistence foundation behind protocols.
- Project workspace navigation with placeholder sections.
- Starter documentation structure.

Milestone 1 intentionally does not include AI integrations, networking, authentication, cloud sync, team collaboration, or code generation workflows.

## Repository Structure

```text
ForgeLab/
  App/                         App entry point and composition root
  Core/Persistence/            Persistence interfaces and local store
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
