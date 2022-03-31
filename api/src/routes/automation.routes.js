const express = require("express");
const router = express.Router();

const {
	register,
	getStatus,
} = require("../controllers/automation.controllers");

router.get("/", getStatus);
router.post("/", register);

module.exports = router;
