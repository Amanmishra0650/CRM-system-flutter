import 'dotenv/config';
import {app} from './app.js';
if(!process.env.DATABASE_URL||!process.env.JWT_SECRET||process.env.JWT_SECRET.length<32)throw Error('Configure DATABASE_URL and a JWT_SECRET of at least 32 characters');
const port=Number(process.env.API_PORT??4000);
app.listen(port,()=>console.info(`Bike Rescue API listening on ${port}`));
