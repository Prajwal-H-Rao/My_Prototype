const express = require("express");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const Task = require("../models/Task");

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET;

//This is a middleware to check if the user is authenticated or not

const authenticate = (req, res, next) => {
  const token = req.headers.authorisation?.split(" ")[1];
  if (!token)
    return res.status(401).json({ message: "Authentication required" });
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(403).json({ message: "Invaloid Token" });
  }
};

//This route is for uploading a new task

router.get("/", authenticate, async (req, res) => {
  try {
    const allTasks = await Task.find({ user: req.user.id });
    console.log(allTasks.length);
    if (allTasks) {
      console.log(allTasks);
      res.status(200).json({ tasks: allTasks });
    }
  } catch (err) {
    res.status(500).json({ tasks: [] });
  }
});

router.post("/", authenticate, async (req, res) => {
  const { title } = req.body;
  try {
    // console.log("api call reached");
    const newTask = new Task({
      title,
      user: req.user.id,
    });
    await newTask.save();
    res.status(201).json({ newTask });
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});

//This path is to update a particular task

router.put("/", authenticate, async (req, res) => {
  const { title, newtitle } = req.body;
  // console.log(title, newtitle);

  const update = { title: newtitle };
  // console.log(updateTask);
  try {
    const taskToBeUpdated = await Task.findOne({
      title: title,
      user: req.user.id,
    });
    const updateTask = await Task.findOneAndUpdate(
      { _id: taskToBeUpdated._id },
      update,
      { new: true }
    );
    if (!updateTask)
      return res
        .status(404)
        .json({ message: "Task not found or unauthorized" });

    res.status(200).json(updateTask);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

//This post is to delete a particular task

router.delete("/:id", authenticate, async (req, res) => {
  const { id } = req.params;
  try {
    await Task.findByIdAndDelete(id);
    res.status(200).json({ message: "Task deleted" });
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
