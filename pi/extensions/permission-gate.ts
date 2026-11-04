import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const protectedPathPatterns = [
  /(^|\/)\.env(?:\.[^/]+)?$/i,
  /(^|\/)(?:credentials|secrets|tokens?)\.(?:json|ya?ml)$/i,
  /(^|\/)service-account\.json$/i,
  /(^|\/)firebase-adminsdk-[^/]+\.json$/i,
  /(^|\/)appsettings\.[^/]+\.json$/i,
  /(^|\/)(?:auth\.json|\.git-credentials)$/i,
  /(^|\/)(?:\.netrc|\.npmrc|\.pypirc)$/i,
  /(^|\/)(?:\.aws|\.kube|\.ssh)(?:\/|$)/i,
  /(^|\/)id_[^/]+(?:\.pub)?$/i,
  /\.(?:pem|key|p12|pfx|tfvars|tfvars\.json)$/i,
];

const deniedCommandPatterns = [
  /\b(?:sudo|doas)\b/i,
  /\brm\s+(?:-[^\s]*r|--recursive)\b/i,
  /\bfind\b.*(?:-delete|-exec\s+(?:rm|shred)\b)/i,
  /\bshred\b/i,
  /\bgit\s+reset\s+--hard\b/i,
  /\bgit\s+clean\b/i,
  /\bgit\s+(?:checkout\s+--|restore\b|push\b)/i,
  /\bterraform\s+(?:apply|destroy)\b/i,
  /\b(?:aws|kubectl|docker)\b/i,
  /\b(?:npm|pnpm)\s+publish\b/i,
  /\b(?:pacman|yay|systemctl)\b/i,
];

function asRecord(value: unknown): Record<string, unknown> {
  return value !== null && typeof value === "object"
    ? (value as Record<string, unknown>)
    : {};
}

function pathFromInput(input: unknown): string | undefined {
  const value = asRecord(input).path;
  return typeof value === "string" ? value.replaceAll("\\", "/") : undefined;
}

function isProtectedPath(path: string): boolean {
  const normalized = path.replace(/^\.\//, "");
  if (normalized.split("/").at(-1) === ".env.example") return false;
  return protectedPathPatterns.some((pattern) => pattern.test(normalized));
}

function shellCommand(input: unknown): string {
  const value = asRecord(input).command;
  return typeof value === "string" ? value.trim() : "";
}

function isSafeInspectionCommand(command: string): boolean {
  return /^git\s+(?:status|diff|log|show|branch\s+--show-current)(?:\s|$)/i.test(
    command,
  );
}

async function confirm(
  ctx: {
    hasUI: boolean;
    ui: { confirm(title: string, message: string): Promise<boolean> };
  },
  title: string,
  detail: string,
) {
  if (!ctx.hasUI) return false;
  return ctx.ui.confirm(title, detail);
}

export default function permissionGate(pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "read") {
      const path = pathFromInput(event.input);
      if (path && isProtectedPath(path)) {
        return { block: true, reason: `Protected path read blocked: ${path}` };
      }
      return undefined;
    }

    if (event.toolName === "edit" || event.toolName === "write") {
      const path = pathFromInput(event.input);
      if (path && isProtectedPath(path)) {
        return {
          block: true,
          reason: `Protected path mutation blocked: ${path}`,
        };
      }

      const allowed = await confirm(
        ctx,
        "Allow file mutation?",
        `${event.toolName}: ${path ?? "unknown path"}`,
      );
      return allowed
        ? undefined
        : { block: true, reason: "File mutation was not approved" };
    }

    if (event.toolName !== "bash" && event.toolName !== "powershell")
      return undefined;

    const command = shellCommand(event.input);
    if (deniedCommandPatterns.some((pattern) => pattern.test(command))) {
      return { block: true, reason: `Denied shell command: ${command}` };
    }

    if (isSafeInspectionCommand(command)) return undefined;

    const allowed = await confirm(
      ctx,
      "Allow shell command?",
      command || "Empty shell command",
    );
    return allowed
      ? undefined
      : { block: true, reason: "Shell command was not approved" };
  });
}
