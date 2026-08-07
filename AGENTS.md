# Repository Code Layout

Apply these layout rules to every Swift source file in this repository tree.

- Put one blank line immediately inside the opening and closing braces of every nonempty multiline scope, including types, functions, computed properties, control-flow blocks, and trailing closures. Keep compact single-expression closures inline. Do not add trailing whitespace to blank lines.
- Keep every argument and parameter list on one physical line, both at declarations and call sites. This includes initializers and chained modifiers such as accessibility APIs. If a declaration or call becomes difficult to read, extract a helper instead of vertically wrapping its arguments or parameters.
- When a standalone helper call inside a closure continues with a modifier, keep the modifier on the next line and indent it one level beneath the call.
- Keep declaration attributes on the same line as the type definition, including multiple attributes. Example: `@MainActor @Observable final class GameStore`.
- Keep simple ternary expressions on one line. Replace a ternary with `if` or `switch` when its full expression is too large for a readable single line.

These are layout-only rules. Do not change behavior solely to satisfy them.
