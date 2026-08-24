# json-schemas

Local JSON Schema files for config formats that don't have an official or
SchemaStore-published schema, kept here so editors (IntelliJ, VS Code, etc.)
can point at a stable local path instead of everyone re-deriving the schema
by hand.

Nothing in this directory is symlinked into `$HOME` by `script/bootstrap` —
these are reference files, wired up per-editor.

## Files

- **`claude-mcp-config.schema.json`** — schema for the `mcpServers` block in
  `claude_desktop_config.json`. Unofficial (Anthropic doesn't publish one as
  of this writing); derived from Claude Code's documented config format.

## Wiring into IntelliJ

Settings → Languages & Frameworks → Schemas and DTDs → JSON Schema Mappings
→ `+` → point "Schema file or URL" at the file in this directory (e.g.
`~/dotfiles/json-schemas/claude-mcp-config.schema.json`) → add
`claude_desktop_config.json` as a file path pattern.

## Adding another schema

Drop the `.schema.json` file in here and add a line to the list above.
