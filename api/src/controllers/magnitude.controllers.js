const Magnitude = require("../models/magnitude.model");
const { StatusCodes } = require("http-status-codes");

const register = async (req, res) => {
	const { temperature, device } = req.body;
	// registered data
	await Magnitude.create({
		temperature,
		device,
	});
	// send response
	res.status(StatusCodes.CREATED).json({
		msg: "Success",
	});
};

const getAll = async (req, res) => {
	const { device } = req.query;
	const magnitudes = await Magnitude.find({ device: device || "iot-001" });
	return res.status(StatusCodes.OK).json({ magnitudes });
};

module.exports = {
	register,
	getAll,
};
