const DEFAULT_COOLDOWN_MS = 1500

export const CompletionSoundPlugin = async ({ client, $ }) => {
  const defaultSound = new URL("../sounds/navi-listen.wav", import.meta.url).pathname
  const soundFile = process.env.OPENCODE_SOUND_FILE || defaultSound
  const cooldownMs = Number(process.env.OPENCODE_SOUND_COOLDOWN_MS || DEFAULT_COOLDOWN_MS)

  let lastPlayedAt = 0

  async function playCompletionSound() {
    const now = Date.now()
    if (now - lastPlayedAt < cooldownMs) return
    lastPlayedAt = now

    try {
      await $`afplay ${soundFile}`
    } catch (error) {
      await client.app.log({
        body: {
          service: "completion-sound-plugin",
          level: "warn",
          message: "Failed to play OpenCode completion sound",
          extra: {
            soundFile,
            error: String(error),
          },
        },
      })
    }
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await playCompletionSound()
      }
    },
  }
}
