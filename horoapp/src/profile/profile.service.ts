import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateProfileDto } from './dto/create-profile.dto';
import { Profile, ProfileDocument } from './interfaces/profile.interface';
import { UpdateProfileDto } from './dto/update-profile.dto';
import {
  HOROSCOPE,
  HOROSCOPE_START_DATES,
  Horoscope,
} from './enums/horoscope.enum';
import { zodiacList } from './enums/zodiac.enum';
import { zodiacEndList } from './constants/zodiac-end-init.constant';
import { ZodiacEndDocument } from './interfaces/zodiac-end.interface';

@Injectable()
export class ProfileService {
  constructor(
    @InjectModel('Profile')
    private readonly profileModel: Model<ProfileDocument>,
    @InjectModel('ZodiacEnd')
    private readonly zodiacEndModel: Model<ZodiacEndDocument>,
  ) {}

  async create(
    userId: string,
    createProfileDto: CreateProfileDto,
  ): Promise<boolean> {
    const profile = {
      userId,
      ...createProfileDto,
    } satisfies Profile;
    const createdProfile = new this.profileModel(profile);
    const result = await createdProfile.save();
    return result !== null;
  }

  async findOne(userId: string): Promise<ProfileDocument | null> {
    return this.profileModel.findOne({ userId });
  }

  async update(
    userId: string,
    updateProfileDto: UpdateProfileDto,
  ): Promise<boolean> {
    const result = await this.profileModel.updateOne(
      { userId },
      updateProfileDto,
    );
    return result.modifiedCount === 1;
  }

  async getHoroscope(dob: string): Promise<Horoscope> {
    const [year, month, day] = dob.split('-').map(Number);
    const isLeapYear = year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
    const adjustedDay = month * 100 + day + (isLeapYear && month > 2 ? 1 : 0);
    const startDates = Object.keys(HOROSCOPE_START_DATES);
    for (let i = 0; i < startDates.length; i++) {
      const startDate = startDates[i];
      if (
        adjustedDay >= parseInt(startDate) &&
        adjustedDay < parseInt(startDates[i + 1])
      ) {
        return HOROSCOPE_START_DATES[startDate];
      }
    }
    return HOROSCOPE.Capricorn;
  }

  async getZodiac(data: string): Promise<string | undefined> {
    const dob = new Date(data);
    const startDate = new Date('1912-02-18');
    let dbList = await this.zodiacEndModel.find();
    if (dbList.length === 0) {
      const zodiacEnd = new this.zodiacEndModel({ data: zodiacEndList });
      await zodiacEnd.save();
    }
    dbList = await this.zodiacEndModel.find();
    const endDateList = dbList[0].data;
    let deltaYear = dob.getFullYear() - startDate.getFullYear();
    const endDate = new Date(endDateList[endDateList.length - deltaYear]);
    const offset = dob.getTime() < endDate.getTime() ? 0 : 1;
    deltaYear += offset;
    const zodiacIndex = deltaYear % 12;
    const result = zodiacList.at(zodiacIndex);
    if (!result) return '';
    return result;
  }
}
