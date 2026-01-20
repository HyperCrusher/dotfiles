return {
  {
    "chrisgrieser/nvim-recorder",
    opts = {
      slots = { "a", "b", "c", "d", "e", "f" },
      mapping = {
        startStopRecording = "q",
        playMacro = "Q",
        switchSlot = "<M-q>",
        editMacro = "eq",
      },
      clear = true,
    },
  },
}
