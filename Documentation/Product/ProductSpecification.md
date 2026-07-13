# Product Specification

Defines the Planner Agent output that is generated from a completed Discovery Session.

The persisted `ProductSpecification` includes:

- Project summary
- Recommended tech stack
- Architecture style
- Main features
- Suggested folder structure
- Database requirement
- Authentication requirement
- API requirement
- Initial milestones
- Generation timestamp
- Source Discovery Session ID

The Planner Agent stores this model on `Project.productSpecification` through the existing project repository. The milestone does not support manual editing, code generation, LLM orchestration, validation, or automatic documentation generation.
