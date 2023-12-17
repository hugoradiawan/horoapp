import { Document } from 'mongoose';

export interface Profile {
  userId?: string;
  readonly name?: string;
  readonly horoscope?: string;
  readonly zodiac?: string;
  readonly birthday?: string;
  readonly height?: number;
  readonly weight?: number;
  readonly interests?: string[];
}

export interface ProfileDocument extends Document, Profile {}
