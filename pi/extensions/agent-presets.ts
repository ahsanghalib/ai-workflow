import { readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { parseFrontmatter } from "@earendil-works/pi-coding-agent";

type ThinkingLevel = "off" | "minimal" | "low" | "medium" | "high" | "xhigh" | "max";

type AgentFrontmatter = {
  name?: unknown;
  description?: unknown;
  provider?: unknown;
  model?: unknown;
  thinkingLevel?: unknown;
  tools?: unknown;
};

type AgentProfile = {
  name: string;
  description: string;
  provider?: string;
  model?: string;
  thinkingLevel?: ThinkingLevel;
  tools: string[];
  instructions: string;
};

const agentsDirectory = join(dirname(fileURLToPath(import.meta.url)), "..", "agents");
const defaultTools = ["read", "bash", "edit", "write"];

function asString(value: unknown): string | undefined {
  return typeof value === "string" && value.trim() ? value.trim() : undefined;
}

function loadProfiles(): Map<string, AgentProfile> {
  const profiles = new Map<string, AgentProfile>();

  for (const entry of readdirSync(agentsDirectory, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
    if (!entry.isFile() || !entry.name.endsWith(".md")) continue;

    const source = readFileSync(join(agentsDirectory, entry.name), "utf8");
    const parsed = parseFrontmatter<AgentFrontmatter>(source);
    const name = asString(parsed.frontmatter.name) ?? entry.name.slice(0, -3);
    const description = asString(parsed.frontmatter.description) ?? `Pi agent preset: ${name}`;
    const thinkingLevel = asString(parsed.frontmatter.thinkingLevel) as ThinkingLevel | undefined;
    const tools = Array.isArray(parsed.frontmatter.tools)
      ? parsed.frontmatter.tools.filter((tool): tool is string => typeof tool === "string")
      : defaultTools;

    if (thinkingLevel && !["off", "minimal", "low", "medium", "high", "xhigh", "max"].includes(thinkingLevel)) {
      throw new Error(`Invalid thinkingLevel for Pi agent ${name}: ${thinkingLevel}`);
    }

    profiles.set(name, {
      name,
      description,
      provider: asString(parsed.frontmatter.provider),
      model: asString(parsed.frontmatter.model),
      thinkingLevel,
      tools,
      instructions: parsed.body.trim(),
    });
  }

  return profiles;
}

function stateName(ctx: ExtensionContext): string | undefined {
  const entry = [...ctx.sessionManager.getEntries()]
    .reverse()
    .find((candidate) => candidate.type === "custom" && candidate.customType === "pi-agent-state");
  const data = entry && "data" in entry ? (entry.data as { name?: unknown } | undefined) : undefined;
  return asString(data?.name);
}

export default function agentPresets(pi: ExtensionAPI) {
  let profiles = new Map<string, AgentProfile>();
  let activeProfile: AgentProfile | undefined;
  let activeName: string | undefined;

  pi.registerFlag("agent", {
    description: "Start Pi with a named repository agent profile",
    type: "string",
  });

  function updateStatus(ctx: ExtensionContext): void {
    ctx.ui.setStatus("agent", activeName ? `agent:${activeName}` : undefined);
  }

  async function applyProfile(name: string, ctx: ExtensionContext, persist = true): Promise<void> {
    const profile = profiles.get(name);
    if (!profile) {
      const available = [...profiles.keys()].join(", ") || "none";
      ctx.ui.notify(`Unknown Pi agent "${name}". Available: ${available}`, "error");
      return;
    }

    if (profile.provider && profile.model) {
      const model = ctx.modelRegistry.find(profile.provider, profile.model);
      if (!model) {
        ctx.ui.notify(`Model not found for ${name}: ${profile.provider}/${profile.model}`, "warning");
      } else if (!(await pi.setModel(model))) {
        ctx.ui.notify(`No credentials available for ${profile.provider}/${profile.model}`, "warning");
      }
    }

    if (profile.thinkingLevel) pi.setThinkingLevel(profile.thinkingLevel);
    pi.setActiveTools(profile.tools);
    activeName = name;
    activeProfile = profile;
    if (persist) pi.appendEntry("pi-agent-state", { name });
    updateStatus(ctx);
    ctx.ui.notify(`Pi agent "${name}" active`, "info");
  }

  async function chooseProfile(args: string | undefined, ctx: ExtensionContext): Promise<void> {
    const requested = args?.trim();
    if (requested) {
      if (requested === "none") {
        activeName = undefined;
        activeProfile = undefined;
        pi.setActiveTools(defaultTools);
        updateStatus(ctx);
        ctx.ui.notify("Pi agent cleared", "info");
        return;
      }
      await applyProfile(requested, ctx);
      return;
    }

    const selected = await ctx.ui.select("Select Pi agent", ["none", ...profiles.keys()]);
    if (selected) await chooseProfile(selected, ctx);
  }

  const command = {
    description: "Switch the active Pi agent profile",
    handler: chooseProfile,
  };
  pi.registerCommand("agent", command);
  pi.registerCommand("preset", command);

  pi.on("before_agent_start", async (event) => {
    if (!activeProfile?.instructions) return;
    return {
      systemPrompt: `${event.systemPrompt}\n\n## Active Pi agent: ${activeProfile.name}\n\n${activeProfile.instructions}`,
    };
  });

  pi.on("session_start", async (_event, ctx) => {
    profiles = loadProfiles();

    const requested = pi.getFlag("agent");
    const selected = typeof requested === "string" && requested.trim() ? requested.trim() : stateName(ctx);
    if (selected) await applyProfile(selected, ctx, false);
    else updateStatus(ctx);
  });
}
