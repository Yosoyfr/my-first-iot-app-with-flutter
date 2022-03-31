// Config
const { PORT, MONGODB_URI } = require("./config");
// Errors
require("express-async-errors");

// Express
const express = require("express");
const app = express();

// Rest of the packages
const morgan = require("morgan");
const rateLimiter = require("express-rate-limit");
const helmet = require("helmet");
const xss = require("xss-clean");
const cors = require("cors");
const mongoSanitize = require("express-mongo-sanitize");
const path = require("path");

// Database
const connectDB = require("./db/connect");

//  Routers
const magnitudesRouter = require("./routes/magnitude.routes");
const automationRouter = require("./routes/automation.routes");

/**
 * Middlewares
 * CORS
 * HELMET
 * MORGAN
 * EXPRESS.JSON
 * EXPRESS.URLENCONDED
 */
const notFoundMiddleware = require("./middleware/not-found");
const errorHandlerMiddleware = require("./middleware/error-handler");
app.set("trust proxy", 1);
app.use(rateLimiter({ windowMs: 15 * 60 * 1000, max: 60 }));
app.use(cors({ origin: true, optionsSuccessStatus: 200 }));
app.use(helmet());
app.use(morgan("dev"));
app.use(xss());
app.use(mongoSanitize());
app.use(express.json());
app.use(express.static("./public"));

/**
 * Routes
 */
app.get("/", (req, res) => {
	return res.json({ message: "Backend funcionando" });
});
app.use("/magnitudes", magnitudesRouter);
app.use("/automation", automationRouter);

/**
 * Errors
 */
app.use(notFoundMiddleware);
app.use(errorHandlerMiddleware);

/**
 * Static build and public files location
 */
app.use(express.static(path.join(__dirname, "dist")));
app.use(express.static("./public"));

const start = async () => {
	try {
		await connectDB(MONGODB_URI);
		app.listen(PORT, () =>
			console.log(`Server is listening on port ${PORT}...`)
		);
	} catch (error) {
		console.log(error);
	}
};

start();
