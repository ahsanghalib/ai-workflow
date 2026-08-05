import type { Plugin } from "@opencode-ai/plugin";

export const AttentionNotification: Plugin = async ({ $, directory }) => {
  const project = directory.split("/").filter(Boolean).pop() ?? "project";

  const notify = async (title: string, message: string) => {
    await $`notify-send --app-name=OpenCode --urgency=critical --expire-time=10000 ${title} ${`${message} (${project})`}`.nothrow();
  };

  return {
    // The published @opencode-ai/plugin types (1.18.12) are stale: the Hooks
    // type still declares "permission.ask" and the SDK Event union omits
    // permission.asked / question.asked, but the 1.18.12 runtime emits those
    // names (the TUI's built-in internal:notifications plugin subscribes to
    // them via the same event stream). The `event` hook receives every server
    // event, so match the runtime names directly and widen the stale type.
    event: async ({ event }) => {
      const type = (event as { type?: string }).type;
      if (type === "permission.asked") {
        await notify("Permission required", "OpenCode is waiting for approval");
      } else if (type === "question.asked") {
        await notify("OpenCode question", "OpenCode is waiting for your answer");
      }
    },
  };
};
