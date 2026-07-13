# Changelog

## Unreleased

### Added

- Added the Planner Agent as a Project Workspace flow after Discovery completion.
- Added generated Product Specifications with project summary, tech stack, architecture style, features, folder structure, database, authentication, API, and initial milestones.
- Added a Planner summary screen for reading and regenerating the saved Product Specification.
- Added persisted Planner output through the existing project repository and local JSON storage.

### Changed

- Expanded `ProductSpecification` from a starter intent model into the structured Planner output model while keeping compatibility with older saved data.
- Project workspace overview now includes Planner status and actions after Discovery is complete.
- Workspace now opens as the central project hub instead of automatically selecting Overview.
- Workspace hub now displays a clear heading, selected project name, and direct project-area actions.
- Workspace navigation now includes a separate Project Planner section between Discovery and Specifications.

### Fixed

- Fixed Workspace Overview navigation after returning to the workspace by routing the sidebar Overview action through the shared project overview view.
- Reused the same Overview implementation from the Project Dashboard and Project Workspace while preserving the selected project context.
- Removed duplicate navigation containers from Discovery and Project Planner when they are opened inside Workspace.
- Fixed Workspace section navigation on iPhone by replacing split-view selection rows with native Workspace hub navigation links.
- Kept Workspace section routing tied to the active project so Overview, Discovery, Project Planner, and placeholder sections retain project context.

## 0.3.0 - 2026-07-12

### Added

- Added the Discovery Engine as a guided Project Workspace flow.
- Added fixed discovery questions for project basics, users, platform, features, authentication, database needs, external services, difficulty, and constraints.
- Added progress indicators showing question position and completion percentage.
- Added a review screen for editing answers before confirmation.
- Added persisted `DiscoverySession` and `DiscoveryAnswer` models.
- Added workspace display for completed discovery answers.

### Changed

- `Project` now stores an optional completed discovery session.
- Project workspace overview now includes Discovery status and actions.

### Notes

- Discovery only gathers information; it does not generate architecture, milestones, code, documentation, validation, or planning output.

## 0.2.0 - 2026-07-04

### Added

- Added project list screen with empty state.
- Added new project flow with validation for required name and project type.
- Added project detail view with name, description, type, creation date, and last modified date.
- Added editing for project name, description, and type.
- Added confirmed project deletion.
- Added selected-project navigation into the project workspace.
- Added project type metadata.

### Changed

- App now launches into project management instead of a default workspace.
- Workspace overview now displays real project metadata.
- Local repository now supports create, read, update, and delete operations.
- JSON persistence now handles invalid stored project data gracefully.

## 0.1.0 - 2026-07-04

### Added

- Initialized the ForgeLab iOS application.
- Added SwiftUI app entry point.
- Added MVVM project workspace feature shell.
- Added lightweight domain models.
- Added local JSON persistence foundation.
- Added placeholder navigation sections for Overview, Requirements, Specifications, Documentation, Milestones, Tasks, Learning, Validation, and Settings.
- Added documentation structure and project planning files.
