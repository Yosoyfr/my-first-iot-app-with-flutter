const Automation = require("../models/automation.model");
const { StatusCodes } = require("http-status-codes");

const register = async (req, res) => {
	const { illumination, device } = req.body;
	const deviceAlreadyExists = await Automation.findOne({ device });
	if (deviceAlreadyExists) {
		// we update the information
		deviceAlreadyExists.illumination = illumination;
		await deviceAlreadyExists.save();
		// send response
		return res.status(StatusCodes.OK).json({
			msg: "Success",
		});
	}
	// if not, then we log data
	await Automation.create({
		illumination,
		device,
	});
	// send response
	res.status(StatusCodes.CREATED).json({
		msg: "Success",
	});
};

const getStatus = async (req, res) => {
	const { device } = req.query;
	const status = await Automation.findOne({ device: device || "iot-001" });
	return res.status(StatusCodes.OK).json(status);
};

module.exports = {
	register,
	getStatus,
};
