# Roadmap

## Completed

### Milestone 1: Project Foundation

- Created a SwiftUI iOS project foundation.
- Added scalable folders for app, core, features, models, services, resources, utilities, and documentation.
- Added initial domain models for projects, milestones, work packages, tasks, specifications, architecture decisions, and validation reports.
- Added a local persistence abstraction with a JSON-backed implementation.
- Added a placeholder project workspace navigation experience.
- Initialized repository documentation.

### Milestone 2: Project Management Foundation

- Added a project list with empty state.
- Added project creation with required name and required project type.
- Added project details with metadata.
- Added editing for project name, description, and type.
- Added confirmed deletion.
- Added workspace navigation for selected projects.
- Extended local persistence through the existing repository pattern.

### Milestone 3: Discovery Engine

- Added a guided Discovery Session in the Project Workspace.
- Added step-by-step project discovery questions for basics, users, platform, features, authentication, storage, APIs, difficulty, and constraints.
- Added progress indicators with current question count and completion percentage.
- Added a review screen for confirming or editing answers.
- Persisted completed Discovery Sessions with projects through the existing repository pattern.
- Added workspace display for saved discovery answers.

### Milestone 4: Planner Agent

- Added a Planner Agent that generates a structured Product Specification from a completed Discovery Session.
- Added deterministic planning logic for project summary, tech stack, architecture style, features, folder structure, database, authentication, API, and initial milestones.
- Added a Planner summary screen for reading and regenerating the saved Product Specification.
- Persisted generated Product Specifications with projects through the existing repository pattern.
- Added workspace display for saved plan status and summary.

### Milestone 5: Project Digital Twin

- Added a persisted Project Digital Twin owned by each project.
- Added a twin data model for project information, Discovery answers, Product Specification data, Planner output, current status, progress, current milestone, and last updated timestamp.
- Added isolated Digital Twin builder logic that derives the twin from the Project aggregate.
- Updated repository save and load paths to create, refresh, migrate, and persist the twin automatically.
- Added a Project Digital Twin dashboard to the Workspace.
- Updated Workspace order to Overview, Discovery, Project Planner, Project Digital Twin, Specifications, Documentation, Milestones, Tasks, Learning, Validation, Settings.

### Milestone 6: Coding Agent

- Added a first-version Coding Agent that prepares implementation workflow artifacts from Planner output.
- Added generated Work Packages from Product Specification features and technical requirements.
- Added generated Tasks linked to Work Packages.
- Added persisted Coding Agent state with status, current Work Package, current Task, source Product Specification, and timestamps.
- Added a Coding Queue with Pending, In Progress, Completed, and Future task buckets.
- Added a Coding Agent Workspace screen for viewing Planner summary, current position, queue state, and generated work.
- Updated the Project Digital Twin to summarize Coding Agent status and queue counts.

## Future Milestones

- Requirements and specification capture.
- Specification authoring workflows.
- Milestone and task planning.
- Documentation review surfaces.
- Validation report generation.
- Learning resource organization.
- File generation and full application generation.
- AI integrations after the core workflow is stable.
