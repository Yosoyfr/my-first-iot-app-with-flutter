import dotenv from "dotenv";

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
export const NODE_ENV = process.env.NODE_ENV || "production";
export const IP_LOCAL = process.env.IP_LOCAL;
export const IP_API = process.env.IP_API;
