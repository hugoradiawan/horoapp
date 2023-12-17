import { Schema } from 'mongoose';

export const ProfileSchema = new Schema({
  userId: String,
  name: String,
  birthday: String,
  gender: String,
  heightInCm: Number,
  weightInKg: Number,
  horoscope: String,
  zodiac: String,
  interest: [String],
});
