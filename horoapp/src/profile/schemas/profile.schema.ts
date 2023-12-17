import { Schema } from 'mongoose';

export const ProfileSchema = new Schema({
  userId: String,
  name: String,
  birthday: String,
  height: Number,
  weight: Number,
  horoscope: String,
  zodiac: String,
  interest: [String],
});
