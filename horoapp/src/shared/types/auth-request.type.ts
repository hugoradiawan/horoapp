import { Request } from 'express';
import { JwtPayload } from 'src/auth/interfaces/jwt.dto';

export type AuthRequest = Request & { payload: JwtPayload };
