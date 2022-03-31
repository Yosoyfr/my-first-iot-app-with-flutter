const mongoose = require("mongoose");

const connectDB = async (url) => {
	const db = await mongoose.connect(url);
	console.log("Database is connected to:", db.connection.name);
	return db;
};

module.exports = connectDB;
