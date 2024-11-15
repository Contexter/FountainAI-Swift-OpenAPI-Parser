
## Prompt Template for Generating Comprehensive Documentation

Here’s the **prompt template** you can use to guide any language model or documentation generation tool effectively:

---

### **Title:** Comprehensive Documentation for FountainAI OpenAPI Implementations as Vapor Projects

---

### **Prompt:**

> Write a comprehensive documentation guide for implementing, deploying, and managing multiple services defined in the **FountainAI OpenAPIs**, using the following requirements:
>
> 1. **Introduction:**
>    - Provide a brief overview of the FountainAI OpenAPI specifications and their purpose.
>    - Include a list of all services (e.g., Central Sequence Service, Action Service, Character Service, etc.).
>
> 2. **Prerequisites:**
>    - List the required tools (e.g., Vapor, Swift, Docker, AWS Copilot).
>    - Provide links or commands to install each tool.
>
> 3. **Project Setup:**
>    - Explain how to create a new Vapor project for each service using `vapor new`.
>    - Describe how to add dependencies such as `FountainAI-Swift-OpenAPI-Parser` and other required libraries.
>    - Include instructions for initializing a GitHub repository for each project.
>
> 4. **Service Implementation Workflow:**
>    - Parse the OpenAPI YAML specification for the given service using the **FountainAI-Swift-OpenAPI-Parser**.
>    - Extract schemas, paths, and components for use in Vapor models, routes, and controllers.
>    - Provide examples of:
>       - Vapor models, migrations, and database setup.
>       - Route definitions and controller logic.
>       - Middleware and request validation.
>
> 5. **Testing:**
>    - Include instructions for writing unit tests and integration tests for the service.
>    - Provide examples of tests for routes and database operations.
>
> 6. **Dockerization:**
>    - Provide a detailed `Dockerfile` example for containerizing the service.
>    - Include instructions for building and testing the Docker image locally.
>
> 7. **Deployment with AWS Copilot:**
>    - Explain how to initialize and configure AWS Copilot for each service.
>    - Include detailed steps for deploying the service to AWS.
>    - Provide examples of `copilot/manifest.yml` configuration.
>
> 8. **CI/CD Pipeline:**
>    - Provide a GitHub Actions workflow for automating build, test, and deployment steps.
>    - Include instructions for setting up secrets and configuring the workflow.
>
> 9. **Branching Strategy:**
>    - Suggest a branching model (e.g., Git Flow) for collaborative development.
>    - Include examples of branch naming conventions and workflows.
>
> 10. **Scaling and Maintenance:**
>     - Provide recommendations for scaling services using AWS Copilot.
>     - Explain how to update OpenAPI specifications and regenerate models as requirements evolve.
>
> Ensure the documentation is structured logically, uses clear language, and includes examples and commands wherever applicable.

---

### **How to Use This Prompt**

- Submit the prompt to your chosen AI model.
- Ensure the model understands the **context** (e.g., Vapor, OpenAPI, FountainAI services).
- Review the generated documentation to ensure completeness and accuracy.

