# Changelog

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
