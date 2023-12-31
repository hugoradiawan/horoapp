import { Document } from 'mongoose';

export interface User extends Document {
  readonly email: string;
  readonly username: string;
  password: string;
}
