# Flutter project instructions

## Scope and tooling

- Apply these instructions to all work in this project.
- Use FVM for all Flutter and Dart commands and respect the SDK pinned in `.fvmrc`.
- Follow the existing project structure, naming conventions, and analyzer configuration.
- Keep changes focused on the requested task; preserve unrelated user changes.
- Use current stable, compatible package versions and current official documentation when adding or updating dependencies. Verify compatibility with the pinned SDK and existing dependencies. Do not upgrade unrelated packages as part of another task.
- Never edit generated files manually. Update their source and run the appropriate generator when needed.

## Code style and documentation

- Do not add ordinary inline or block comments in code. Use English Dart documentation comments (`///`) to document class, function, method, and variable declarations; documentation comments are the required exception to the no-comments rule.
- Document purpose, behavior, and relevant constraints concisely rather than restating declaration names. Apply this to newly added or changed declarations, including private declarations.
- Prefer generic, reusable solutions with clear responsibilities. Reuse existing abstractions before introducing new ones, and avoid speculative abstractions.
- Keep each class in its own file, including private widget classes. Generated files follow their generator's conventions.
- Use clear names, sound null safety, and clean formatting. Avoid unnecessary casts and null assertions.

## Widgets and layout

- Extract reusable or substantial UI into widget classes. Do not introduce functions or methods that return widgets as UI composition helpers; framework overrides such as `build` are expected exceptions.
- Split extensive widgets into cohesive files. Extracted widgets belonging to the same library go into separate `part` files with matching `part of` declarations. Independently reusable widgets remain standalone libraries.
- Keep business logic out of widget build methods.
- Prefer `const` constructors and widgets where possible.
- Use `Row.spacing` and `Column.spacing` for regular gaps when appropriate. Prefer `Padding` for insets rather than using `SizedBox` as a padding substitute. Use explicit sizing widgets when actual size constraints or standalone gaps are required.
- Support small screens, large text scales, and keyboard insets without clipping or overflow.

## State and lifecycle

- Use Riverpod for application state and asynchronous data. Use `setState` only for local form state.
- Keep providers focused and avoid unnecessary rebuilds by watching only the state a widget needs.
- Preserve relevant state across navigation and app background/resume, including scroll positions, filters, selections, and form drafts where appropriate.
- Choose provider lifetimes deliberately. Do not let automatic disposal unexpectedly discard state that must survive navigation or backgrounding.
- Use stable keys, scroll controllers, and page storage where appropriate. Use restoration or persistence when state must survive process termination; in-memory state alone does not provide that guarantee.
- Dispose controllers, subscriptions, focus nodes, and other owned resources correctly. Handle asynchronous lifecycle boundaries safely.

## Loading, errors, and offline behavior

- Provide clear loading, empty, success, and error states for asynchronous UI.
- Keep existing content visible during refreshes when possible and prevent duplicate submissions.
- Show understandable, localized offline and connection error messages with a meaningful retry action where appropriate.
- Treat actual request outcomes as authoritative; connectivity status alone does not guarantee internet access.
- Preserve user input and recoverable state after failures. Do not expose raw exceptions to users.

## Localization

- Use `easy_localization` for every user-facing string, including validation, errors, tooltips, and accessibility labels. Do not hardcode user-facing text in Dart code.
- Add German translations to `assets/translations/de.json` and follow the existing key structure.
- Use translation parameters and pluralization instead of concatenating translated fragments.
- Format dates, numbers, and other locale-dependent values consistently with the active locale.
- Technical identifiers, protocol values, asset paths, and localization keys are not user-facing strings.

## Accessibility

- Provide an accessible screen reader experience for all new or changed UI.
- Use `Semantics` where built-in widget semantics do not adequately describe content, actions, values, or state.
- Give icon-only controls localized accessible labels or tooltips. Expose selected, expanded, checked, enabled, and loading states where relevant.
- Preserve logical reading and focus order. Avoid duplicate announcements by merging or excluding semantics where appropriate.
- Keep interactive targets accessible, support text scaling, and do not communicate meaning through color alone.

## Performance

- Keep expensive computations, network requests, and avoidable allocations out of build methods.
- Use lazy builders for long lists and grids, stable item keys where needed, and appropriately sized images.
- Avoid unnecessary intrinsic layouts, nested scrolling, broad provider subscriptions, and repeated work.
- Prefer measured, task-relevant improvements over speculative optimization.

## Verification and completion

- After every task, run `fvm dart format .` followed by `fvm flutter analyze` from the project root.
- Review formatter changes and keep unrelated formatting churn out of the final change.
- Run relevant tests for changed behavior using `fvm flutter test` with an appropriate scope. Add meaningful regression tests for bug fixes and nontrivial logic changes.
- Check localization keys and accessibility behavior for changed UI. Verify loading, empty, error, and offline states when applicable.
- Fix issues introduced by the task. Report pre-existing failures or checks that could not be completed accurately.
- Summarize the result and verification briefly, including material limitations.
