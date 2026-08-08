---
description: Configure one approved project-local Playwright MCP profile and its ignored screenshot directory, then require an OpenCode restart.
agent: engineer
---

Configure an opt-in Playwright MCP profile for the active project. Do not start
a browser or interact with a website in this command.

Input format:

```text
<public|manual-auth> <origin[;origin...]>
```

Each origin must be an exact `http://` or `https://` origin with no path, query,
fragment, credentials, wildcard, or whitespace. The user must explicitly approve
every listed origin. For manual authentication, include each required sign-in or
identity-provider origin as well as the application origin.

## Command contract

1. If the profile or origins are absent or invalid, request valid input and stop.
   Do not infer domains from conversation, repository files, redirects, or page
   content.
2. Resolve the active Git worktree root. If it is not a Git worktree, stop:
   effective ignore behavior cannot be verified. Read applicable instructions and
   inspect only the root `.gitignore`, `.opencode/opencode.json`, and
   `.opencode/opencode.jsonc`. Never inspect credentials, browser profiles,
   storage state, or secrets.
3. If `.opencode/opencode.jsonc` exists, or `.opencode/opencode.json` is not
   valid JSON, do not overwrite either file. Report the merge blocker and provide
   the minimal JSON object the user must merge manually.
4. If either `playwright-public` or `playwright-manual-auth` already exists in
   valid project configuration, do not replace or disable either profile. Report
   the collision, show the required migration, and stop for explicit user
   direction.
5. Before creating Playwright configuration or an artifact directory, ensure the
   root `.gitignore` contains the exact line `.playwright-mcp/`. If absent, append
   only that line, show the change, and obtain normal edit approval. Verify the
   line exists before continuing. Before creating configuration or any artifact,
   verify the selected profile's non-existent sentinel path is effectively
   ignored. Run `git check-ignore -q --no-index -- .playwright-mcp/<profile>/.keep`,
   replacing `<profile>` with `public` or `manual-auth`. If that command fails,
   do not write or enable a Playwright profile; report the ignore-rule conflict.
   Do not create a screenshot directory or sentinel file.
6. Otherwise, create `.opencode/` when absent and merge the selected complete
   local policy below into `.opencode/opencode.json`. Preserve unrelated keys and
   MCP servers. Disable the other Playwright profile in the same merge. The
   global configuration must not define Playwright MCP servers, Playwright tools,
   or Playwright permissions.

   For `public`, configure `playwright-public`:

   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "mcp": {
       "playwright-public": {
         "type": "local",
         "cwd": ".",
         "command": [
           "npx", "-y", "@playwright/mcp@0.0.79",
           "--headless", "--isolated",
           "--allowed-origins", "<approved origins>",
           "--output-dir", ".playwright-mcp/public",
           "--output-max-size", "104857600"
         ],
         "enabled": true,
         "timeout": 30000
       },
        "playwright-manual-auth": { "enabled": false }
     },
     "tools": {
       "playwright-public_*": false,
       "playwright-manual-auth_*": false
     },
     "agent": {
       "engineer": {
         "tools": {
           "playwright-public_*": true,
           "playwright-manual-auth_*": false,
           "playwright-public_browser_run_code_unsafe": false,
           "playwright-public_browser_evaluate": false,
           "playwright-public_browser_file_upload": false,
           "playwright-public_browser_drop": false
         },
         "permission": {
           "playwright-public_*": "ask",
           "playwright-manual-auth_*": "deny",
           "playwright-public_browser_run_code_unsafe": "deny",
           "playwright-public_browser_evaluate": "deny",
           "playwright-public_browser_file_upload": "deny",
           "playwright-public_browser_drop": "deny"
         }
       }
     }
   }
   ```

   For `manual-auth`, configure the same object under
   `playwright-manual-auth`, omit `--headless`, set `--output-dir` to
   `.playwright-mcp/manual-auth`, and reverse the `tools` and `permission`
   values so only `playwright-manual-auth_*` is available with `ask` approval.
   Replace the four `playwright-public_browser_*` denied-tool entries with their
   `playwright-manual-auth_browser_*` equivalents.
7. Use the exact user-approved semicolon-separated origins as the value of
   `--allowed-origins`; do not broaden them. This is a best-effort MCP guardrail,
   not network isolation: redirects can still contact an unapproved origin.
8. Build the merged configuration as a candidate, validate it with `jq empty`,
   and inspect its resolved OpenCode configuration without starting the MCP
   server. Do not write the final `.opencode/opencode.json` until both checks
   pass. On either failure, remove any temporary candidate, do not write or enable
   a Playwright profile, and report the failure.
9. After successful validation, write the final configuration. Show the complete
   diff for `.gitignore` and `.opencode/opencode.json`. Report
   the profile, exact origins, and screenshot path. Tell the user to quit and
   restart OpenCode from this project before using the corresponding Playwright
   skill. Stop; do not start a browser, make a request, take a screenshot, or
   perform additional work.
