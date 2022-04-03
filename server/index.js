import fetch from "node-fetch";

// Config
import { IP_API, IP_LOCAL } from "./config.js";

// Obtencion de temperatura
setInterval(async () => {
	try {
		const get_ = await fetch(IP_LOCAL + "/");
		const body = await get_.json();
		body.device = "iot-001";
		const post_ = await fetch(IP_API + "/magnitudes", {
			method: "post",
			body: JSON.stringify(body),
			headers: { "Content-Type": "application/json" },
		});
		const data = await post_.json();
		console.log(body, data);
	} catch (error) {}
}, 30000);

// Obtencion de la automatizacion
setInterval(async () => {
	try {
		const get_ = await fetch(IP_API + "/automation");
		const data = await get_.json();
		await fetch(IP_LOCAL + (data.illumination ? "/H" : "/L"));
	} catch (error) {}
}, 7000);
