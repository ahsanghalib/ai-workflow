import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type CmdResult = { code: number; stdout: string; stderr: string };

function notify(
  ctx: {
    hasUI: boolean;
    ui: { notify: (s: string, kind: "info" | "error" | "warning") => void };
  },
  text: string,
  type: "info" | "error" | "warning" = "info",
) {
  if (ctx.hasUI) ctx.ui.notify(text, type);
  else console.log(text);
}

async function run(
  pi: ExtensionAPI,
  cwd: string,
  bin: string,
  argv: string[],
  ms = 120_000,
): Promise<CmdResult> {
  const result = await pi.exec(bin, argv, { cwd, timeout: ms });
  return {
    code: result.code,
    stdout: result.stdout ?? "",
    stderr: result.stderr ?? "",
  };
}

function describeResult(name: string, result: CmdResult): string {
  const short = (result.stderr || result.stdout).trim().slice(-1500);
  return `${result.code === 0 ? "PASS" : "FAIL"} ${name}${short ? `\n${short}` : ""}`;
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("repo-status", {
    description: "Show Git status and diff summary without modifying files",
    handler: async (_args, ctx) => {
      const cwd = ctx.cwd;
      const root = await run(
        pi,
        cwd,
        "git",
        ["rev-parse", "--show-toplevel"],
        10_000,
      );
      if (root.code !== 0) {
        notify(ctx, "Not a Git repository", "warning");
        return;
      }
      const status = await run(pi, cwd, "git", ["status", "--short"], 10_000);
      const stat = await run(pi, cwd, "git", ["diff", "--stat"], 10_000);
      notify(
        ctx,
        `Repo: ${root.stdout.trim()}\nStatus:\n${status.stdout.trim() || "clean"}\nDiff:\n${stat.stdout.trim() || "none"}`,
      );
    },
  });

  pi.registerCommand("verify", {
    description:
      "Run available repository checks without installing dependencies (fast|full|list)",
    handler: async (args, ctx) => {
      const mode = (args || "fast").trim();
      if (!["fast", "full", "list"].includes(mode)) {
        notify(ctx, "Usage: /verify [fast|full|list]", "warning");
        return;
      }
      const cwd = ctx.cwd;
      const checks: Array<{
        label: string;
        bin: string;
        argv: string[];
        timeout: number;
      }> = [];
      const root = await run(
        pi,
        cwd,
        "git",
        ["rev-parse", "--show-toplevel"],
        10_000,
      );
      if (root.code === 0)
        checks.push({
          label: "git diff --check",
          bin: "git",
          argv: ["diff", "--check"],
          timeout: 30_000,
        });

      const pkgFile = join(cwd, "package.json");
      if (existsSync(pkgFile)) {
        try {
          const pkg = JSON.parse(readFileSync(pkgFile, "utf8")) as {
            scripts?: Record<string, string>;
          };
          const scripts = pkg.scripts ?? {};
          const runner = existsSync(join(cwd, "pnpm-lock.yaml"))
            ? "pnpm"
            : existsSync(join(cwd, "yarn.lock"))
              ? "yarn"
              : existsSync(join(cwd, "bun.lock")) ||
                  existsSync(join(cwd, "bun.lockb"))
                ? "bun"
                : "npm";
          const candidates =
            mode === "full"
              ? ["lint", "typecheck", "test", "build"]
              : ["lint", "typecheck", "test"];
          for (const name of candidates) {
            if (typeof scripts[name] === "string") {
              checks.push({
                label: `${runner} run ${name}`,
                bin: runner,
                argv: ["run", name],
                timeout:
                  name === "test" || name === "build" ? 300_000 : 180_000,
              });
            }
          }
        } catch (error) {
          notify(ctx, `Cannot parse package.json: ${String(error)}`, "error");
          return;
        }
      } else if (existsSync(join(cwd, "go.mod"))) {
        checks.push({
          label: "go test ./...",
          bin: "go",
          argv: ["test", "./..."],
          timeout: 300_000,
        });
      } else if (existsSync(join(cwd, "pyproject.toml"))) {
        notify(
          ctx,
          "Python project: set its test command explicitly (no automatic uv/pytest execution)",
          "warning",
        );
      }
      if (!checks.length) {
        notify(ctx, "No supported checks detected", "warning");
        return;
      }
      if (mode === "list") {
        notify(
          ctx,
          `Detected checks:\n${checks.map((c) => `- ${c.label}`).join("\n")}`,
        );
        return;
      }
      // Explicit user command is authorization to run the repository's local checks.
      // Note: package.json scripts are executable project code; trust the checkout.
      for (const c of checks) {
        try {
          const result = await run(pi, cwd, c.bin, c.argv, c.timeout);
          notify(
            ctx,
            describeResult(c.label, result),
            result.code === 0 ? "info" : "error",
          );
          if (result.code !== 0) return;
        } catch (error) {
          notify(ctx, `FAIL ${c.label}: ${String(error)}`, "error");
          return;
        }
      }
      notify(ctx, `${checks.length} verification checks passed`);
    },
  });
}
