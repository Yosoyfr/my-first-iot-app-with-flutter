const express = require("express");
const router = express.Router();

const { register, getAll } = require("../controllers/magnitude.controllers");

router.post("/", register);
router.get("/", getAll);

module.exports = router;
