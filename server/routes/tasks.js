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

//This route is used to fetch the tasks of a particular date

router.get("/:date", authenticate, async (req, res) => {
  const { date } = req.params;
  try {
    const tasks = await Task.find({
      user: req.user.id,
      date: new Date(date),
    });

    res.status(200).json(tasks);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

//This route is for uploading a new task

router.post("/", authenticate, async (req, res) => {
  const { title, date } = req.body;

  try {
    const newTask = new Task({
      title,
      date,
      user: req.user.id,
    });
    await newTask.save();
    res.status(201).json(newTask);
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});
