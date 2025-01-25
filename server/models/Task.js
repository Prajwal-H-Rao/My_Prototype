const mongoose = require("mongoose");

const TaskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  isDashed: { type: Boolean },
});

module.exports = mongoose.model("Task", TaskSchema);
