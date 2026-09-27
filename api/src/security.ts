import jwt from 'jsonwebtoken';
import type {Request,Response,NextFunction} from 'express';
export type Role='RIDER'|'MECHANIC'|'ADMIN';
export type Principal={id:string;role:Role};
declare global {namespace Express {interface Request {principal?:Principal}}}
export function issueToken(user:Principal){if(!process.env.JWT_SECRET||process.env.JWT_SECRET.length<32)throw new Error('JWT_SECRET must be at least 32 characters');return jwt.sign(user,process.env.JWT_SECRET,{expiresIn:'12h',issuer:'bike-rescue'});}
export function requireAuth(...roles:Role[]){return (req:Request,res:Response,next:NextFunction)=>{try{const token=req.headers.authorization?.replace(/^Bearer /,'');if(!token||!process.env.JWT_SECRET) return res.status(401).json({error:'Authentication required'});const payload=jwt.verify(token,process.env.JWT_SECRET,{issuer:'bike-rescue'}) as jwt.JwtPayload;if(typeof payload.id!=='string'||!['RIDER','MECHANIC','ADMIN'].includes(payload.role))return res.status(401).json({error:'Invalid token'});req.principal={id:payload.id,role:payload.role};if(roles.length&&!roles.includes(req.principal.role))return res.status(403).json({error:'Forbidden'});next();}catch{return res.status(401).json({error:'Invalid token'});}}}
