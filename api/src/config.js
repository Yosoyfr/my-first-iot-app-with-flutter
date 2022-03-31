const dotenv = require("dotenv");

/**
 * lectura del archivo .env
 */
dotenv.config();

/**
 * Variables de entorno
 * NODE_ENV: Entorno de trabajo
 * HOST: Host donde se aloja el servidor
 * PORT: Puerto del HOST donde se aloja el servidor
 * MONGODB_URI: Ruta para realizar la conexion con MongoDB
 */
module.exports = {
	NODE_ENV: process.env.NODE_ENV || "production",
	HOST: process.env.HOST || "127.0.0.1",
	PORT: process.env.PORT || 3000,
	MONGODB_URI: process.env.MONGODB_URI || "mongodb://localhost/apiv1",
};
