const mongoose = require("mongoose");

const MagnitudeSchema = new mongoose.Schema(
	{
		temperature: { type: Number, default: 0 },
		device: { type: String, default: "iot-001", lowercase: true },
	},
	{ timestamps: true, versionKey: false }
);

MagnitudeSchema.method("toJSON", function () {
	const { __v, _id, createdAt, updatedAt, device, ...object } = this.toObject();
	object.date = createdAt;
	return object;
});

module.exports = mongoose.model("Magnitude", MagnitudeSchema);
