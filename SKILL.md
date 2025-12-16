---
name: digestor
description: Analyze complex monorepos to generate comprehensive specifications for LLM-assisted code generation. Discovers files, maps dependencies, analyzes code structure, detects architectural patterns, researches best practices, and synthesizes findings into spec files (project-overview.md, modules/*.md, patterns.md, improvements.md, manifest.json). Use when understanding codebase architecture or creating specifications.
---

# Digestor - Codebase Analyzer Skill

## Overview

Digestor systematically analyzes codebases through a multi-stage workflow, producing comprehensive specification files that can instruct LLMs about the codebase and guide future code generation.

## Output Structure

All output goes to a `digestor-output/` directory:

```
digestor-output/
├── project-overview.md    # High-level architecture summary
├── patterns.md            # Detected patterns and conventions
├── improvements.md        # Best practice recommendations
├── manifest.json          # Machine-readable index
└── modules/
    └── [module-name].md   # Per-module specifications
```

## Analysis Workflow

Execute these stages in order. Use the TodoWrite tool to track progress through stages.

### Stage 1: File Discovery

**Goal**: Build a complete map of the codebase structure.

1. Identify project type from root configuration files:
   - `package.json` / `tsconfig.json` → TypeScript/JavaScript
   - `pyproject.toml` / `setup.py` / `requirements.txt` → Python
   - `go.mod` → Go
   - `Cargo.toml` → Rust
   - `pom.xml` / `build.gradle` → Java

2. Use Glob to discover files by category:
   ```
   Source: **/*.{ts,tsx,js,jsx,py,go,rs,java}
   Config: **/*.{json,yaml,yml,toml}
   Tests: **/*.{test,spec}.{ts,js,py} or **/test_*.py
   Docs: **/*.md
   ```

3. Identify key directories (src/, lib/, pkg/, cmd/, internal/, tests/)

4. Count files by category and note the project structure

**Output**: Mental map of project structure, file counts, key directories

### Stage 2: Dependency Analysis

**Goal**: Map all dependencies and internal module relationships.

1. Parse dependency manifests:
   - JavaScript: Read `package.json` for dependencies/devDependencies
   - Python: Read `pyproject.toml` or `requirements.txt`
   - Go: Read `go.mod` for require statements

2. Categorize dependencies:
   - **Production**: Runtime dependencies
   - **Development**: Build/test tools
   - **Internal**: Workspace/monorepo packages

3. For monorepos, identify workspace structure and internal package relationships

**Output**: List of dependencies with categories, internal module graph

### Stage 3: Code Structure Analysis

**Goal**: Understand the public API and internal organization of key modules.

1. Identify the top 5-10 most important modules based on:
   - Entry points (index.ts, main.py, cmd/)
   - Core business logic directories
   - Shared utilities and types

2. For each key module, analyze:
   - **Exports**: Public functions, classes, types, interfaces
   - **Imports**: Dependencies on other modules
   - **Classes**: Key classes with methods and properties
   - **Functions**: Exported functions with signatures

3. Use Grep to find patterns:
   ```
   Exports: grep -E "^export (async )?(function|class|const|type|interface)"
   Classes: grep -E "^(export )?class \w+"
   Functions: grep -E "^(export )?(async )?function \w+"
   ```

**Output**: Module-by-module breakdown of structure and APIs

### Stage 4: Pattern Detection

**Goal**: Identify architectural patterns, design patterns, and coding conventions.

Based on the file structure and code analysis, identify:

1. **Architectural Patterns**:
   - Monorepo (multiple packages, workspace config)
   - Layered architecture (controllers, services, repositories)
   - Plugin/extension system
   - Microservices structure
   - Clean/hexagonal architecture

2. **Design Patterns**:
   - Factory patterns (createX functions, X.create())
   - Singleton patterns (getInstance, shared instances)
   - Observer patterns (event emitters, subscriptions)
   - Repository patterns (data access abstraction)
   - Dependency injection

3. **Coding Conventions**:
   - Naming conventions (camelCase, snake_case, PascalCase)
   - File organization patterns
   - Error handling approach
   - Async patterns (promises, async/await, callbacks)
   - Logging conventions

**Output**: List of patterns with confidence levels and example locations

### Stage 5: Code Research

**Goal**: Compare implementation against best practices and identify improvements.

Review the codebase against:

1. **Framework Best Practices**:
   - Are framework features being used optimally?
   - Are there deprecated patterns in use?

2. **Security Considerations**:
   - Input validation patterns
   - Authentication/authorization implementation
   - Secrets management

3. **Performance**:
   - Caching strategies
   - Database query patterns
   - Bundle size considerations

4. **Maintainability**:
   - Code organization
   - Test coverage patterns
   - Documentation quality

5. **Testing**:
   - Test patterns and coverage
   - Mocking strategies
   - Integration vs unit test balance

**Output**: Categorized list of improvement suggestions with severity levels

### Stage 6: Documentation Synthesis

**Goal**: Generate the specification files.

Create the output directory and write each spec file:

```bash
mkdir -p digestor-output/modules
```

#### 1. project-overview.md
See [templates/project-overview.md](templates/project-overview.md) for format.

Write a comprehensive overview including:
- Project name and purpose
- Technology stack
- Architecture summary
- Key modules table
- Dependency highlights
- Quick start guide (inferred)

#### 2. patterns.md
See [templates/patterns.md](templates/patterns.md) for format.

Document all detected patterns organized by type.

#### 3. improvements.md
See [templates/improvements.md](templates/improvements.md) for format.

Document all improvement suggestions organized by category and severity.

#### 4. modules/*.md
For each key module analyzed, create a specification file.
See [templates/module.md](templates/module.md) for format.

#### 5. manifest.json
Create a machine-readable index:
```json
{
  "version": "1.0.0",
  "generatedAt": "[ISO timestamp]",
  "project": {
    "name": "[project name]",
    "type": "[typescript|python|go|etc]",
    "path": "[analyzed path]"
  },
  "summary": {
    "totalFiles": 0,
    "totalModules": 0,
    "totalDependencies": 0,
    "totalPatterns": 0,
    "totalImprovements": 0
  },
  "modules": ["list", "of", "module", "names"],
  "patterns": ["list", "of", "pattern", "names"],
  "dependencies": {
    "production": [],
    "development": []
  }
}
```

## Usage Tips

1. **For large codebases**: Focus detailed analysis on 5-10 core modules rather than every file
2. **For monorepos**: Analyze each package separately, then synthesize the relationships
3. **Incremental updates**: Re-run specific stages if the codebase changes
4. **Custom focus**: Ask to focus on specific aspects (security, performance, testing)

## Example Invocation

"Analyze the codebase at ~/workspace/my-project and generate specs"

"Run digestor on this repo focusing on the authentication modules"

"Generate a codebase specification for the packages/core directory"
