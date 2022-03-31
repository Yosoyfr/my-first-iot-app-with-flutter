const mongoose = require("mongoose");

const AutomationSchema = new mongoose.Schema(
	{
		illumination: { type: Boolean, default: false },
		device: { type: String, default: "iot-001", lowercase: true, unique: true },
	},
	{ timestamps: true, versionKey: false }
);

AutomationSchema.method("toJSON", function () {
	const { __v, _id, createdAt, updatedAt, device, ...object } = this.toObject();
	object.date = createdAt;
	return object;
});

module.exports = mongoose.model("Automation", AutomationSchema);
