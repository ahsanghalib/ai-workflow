import { readFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";

const repositoryRoot = join(import.meta.dirname, "..");
const opencodeRoot = join(repositoryRoot, "opencode");

function fail(message) {
	console.error(`validate-config: ${message}`);
	process.exitCode = 1;
}

function readJson(path) {
	try {
		return JSON.parse(readFileSync(path, "utf8"));
	} catch (error) {
		fail(`invalid JSON in ${path}: ${error.message}`);
		return null;
	}
}

function frontmatter(path) {
	const content = readFileSync(path, "utf8");
	const match = content.match(/^---\n([\s\S]*?)\n---\n/);
	if (!match) {
		fail(`${path} must start with a frontmatter block`);
		return new Map();
	}

	return new Map(
		match[1]
			.split("\n")
			.filter((line) => line.includes(":"))
			.map((line) => {
				const separator = line.indexOf(":");
				return [line.slice(0, separator).trim(), line.slice(separator + 1).trim()];
			}),
	);
}

function markdownFiles(directory) {
	return readdirSync(directory)
		.filter((entry) => entry.endsWith(".md"))
		.map((entry) => join(directory, entry));
}

const config = readJson(join(opencodeRoot, "opencode.json"));
const models = readJson(join(opencodeRoot, "opencode-models.json"));
const agentsDirectory = join(opencodeRoot, "agents");

if (config?.$schema !== "https://opencode.ai/config.json") {
	fail("opencode.json must declare the OpenCode schema URL");
}

for (const agentPath of markdownFiles(agentsDirectory)) {
	const fields = frontmatter(agentPath);
	if (!fields.get("description") || !fields.get("mode")) {
		fail(`${agentPath} must declare description and mode`);
	}
}

const configuredAgents = new Set();
for (const [tier, definition] of Object.entries(models ?? {})) {
	for (const group of ["main", "small"]) {
		if (!Array.isArray(definition.agents?.[group]) || definition.agents[group].length === 0) {
			fail(`tier ${tier} must declare at least one ${group} agent`);
			continue;
		}
		for (const agent of definition.agents[group]) {
			configuredAgents.add(agent);
			if (!statSync(join(agentsDirectory, `${agent}.md`), { throwIfNoEntry: false })) {
				fail(`tier ${tier} references missing agent ${agent}`);
			}
		}
	}
}

const skillNames = new Set();
for (const entry of readdirSync(join(opencodeRoot, "skills"))) {
	const skillPath = join(opencodeRoot, "skills", entry, "SKILL.md");
	if (!statSync(skillPath, { throwIfNoEntry: false })) continue;
	const fields = frontmatter(skillPath);
	const name = fields.get("name");
	if (name !== entry || !fields.get("description")) {
		fail(`${skillPath} must declare matching name and description`);
	}
	if (skillNames.has(name)) fail(`duplicate skill name ${name}`);
	skillNames.add(name);
}

for (const commandPath of markdownFiles(join(opencodeRoot, "commands"))) {
	if (!frontmatter(commandPath).get("description")) {
		fail(`${commandPath} must declare a description`);
	}
}

for (const expectedText of [
	"worktree-new BRANCH [BASE_REF] [START_WINDOW]",
	"worktree-close PATH [MERGED_INTO_REF]",
	"dev-session is unavailable",
]) {
	if (!readFileSync(join(repositoryRoot, "README.md"), "utf8").includes(expectedText)) {
		fail(`README.md must document: ${expectedText}`);
	}
}

if (process.exitCode) process.exit(process.exitCode);
console.log("OpenCode configuration validation passed");
