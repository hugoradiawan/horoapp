import {
  Controller,
  Post,
  Body,
  Get,
  Put,
  Res,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ProfileService } from './profile.service';
import { CreateProfileDto } from './dto/create-profile.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { ServerResponse } from 'src/shared/dto/server-response.dto';
import { AuthGuard } from 'src/auth/auth.guard';
import { AuthRequest } from 'src/shared/types/auth-request.type';
import { Response } from 'express';
import { Profile, ProfileDocument } from './interfaces/profile.interface';
import { HoroscopeZodiac } from './interfaces/horoscope-zodiac.interface';

@Controller('api')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Post('createProfile')
  @UseGuards(AuthGuard)
  async create(
    @Req() req: AuthRequest,
    @Res() res: Response,
    @Body() createProfileDto: CreateProfileDto,
  ): Promise<Response> {
    const jwtPayload = req.payload;
    if (!createProfileDto.birthday) {
      return res.status(400).json({
        isOk: false,
        errorCode: 1001,
        message: 'Birthday is required',
      });
    }
    if (!/^\d{4}-\d{2}-\d{2}$/.exec(createProfileDto.birthday)) {
      return res.status(400).json({
        isOk: false,
        errorCode: 1002,
        message: 'Birthday is not in the format of YYYY-MM-DD',
      });
    }
    const [horoscope, zodiac] = await Promise.all([
      this.profileService.getHoroscope(createProfileDto.birthday),
      this.profileService.getZodiac(createProfileDto.birthday),
    ]);
    const tosave = {
      ...createProfileDto,
      horoscope,
      zodiac,
    } satisfies Profile;
    const isOk = await this.profileService.create(jwtPayload.sub, tosave);
    return res.status(isOk ? 201 : 400).send();
  }

  @Get('getProfile')
  @UseGuards(AuthGuard)
  async findOne(
    @Req() req: AuthRequest,
    @Res() res: Response,
  ): Promise<Response> {
    const jwtPayload = req.payload;
    const result = await this.profileService.findOne(jwtPayload.sub);
    const response: ServerResponse<Profile> = {
      isOk: result !== null,
      ...(result === null
        ? {
            errorCode: 1000,
            message: `Profile with id ${jwtPayload.sub} not found`,
          }
        : { data: this.sanitizeData(result) }),
    };
    return res.status(result === null ? 404 : 201).json(response);
  }

  @Put('updateProfile')
  @UseGuards(AuthGuard)
  async update(
    @Req() req: AuthRequest,
    @Res() res: Response,
    @Body() updateProfileDto: UpdateProfileDto,
  ): Promise<Response> {
    const jwtPayload = req.payload;
    let toupdate: UpdateProfileDto & HoroscopeZodiac = updateProfileDto;
    if (Object.keys(toupdate).length === 0) return res.status(200).send();
    if (updateProfileDto.birthday) {
      if (!/^\d{4}-\d{2}-\d{2}$/.exec(updateProfileDto.birthday)) {
        return res.status(400).json({
          isOk: false,
          errorCode: 1003,
          message: 'Birthday is not in the format of YYYY-MM-DD',
        });
      }
      const [horoscope, zodiac] = await Promise.all([
        this.profileService.getHoroscope(updateProfileDto.birthday),
        this.profileService.getZodiac(updateProfileDto.birthday),
      ]);
      toupdate = {
        ...updateProfileDto,
        horoscope,
        zodiac,
      };
    }
    const isOk = await this.profileService.update(jwtPayload.sub, toupdate);
    return res.status(isOk ? 200 : 400).send();
  }

  @Post('askHoroscopeZodiac')
  async askHoroscopeZodiac(
    @Res() res: Response,
    @Body() body: { birthday: string },
  ): Promise<Response> {
    if (!body.birthday) {
      return res.status(400).json({
        isOk: false,
        errorCode: 1004,
        message: 'Birthday is required',
      });
    }
    if (!/^\d{4}-\d{2}-\d{2}$/.exec(body.birthday)) {
      return res.status(400).json({
        isOk: false,
        errorCode: 1005,
        message: 'Birthday is not in the format of YYYY-MM-DD',
      });
    }
    const [horoscope, zodiac] = await Promise.all([
      this.profileService.getHoroscope(body.birthday),
      this.profileService.getZodiac(body.birthday),
    ]);
    if (!horoscope || !zodiac) {
      return res.status(500).json({
        isOk: false,
        errorCode: 1006,
        message: 'Failed to get horoscope and zodiac',
      });
    }
    const response: ServerResponse<{ horoscope: string; zodiac: string }> = {
      isOk: true,
      data: {
        horoscope,
        zodiac,
      },
    };
    return res.status(200).json(response);
  }

  private sanitizeData(data: ProfileDocument): Profile {
    const {
      name,
      birthday,
      heightInCm,
      weightInKg,
      gender,
      interests,
      zodiac,
      horoscope,
    } = data;
    return {
      name,
      birthday,
      heightInCm,
      weightInKg,
      gender,
      interests,
      zodiac,
      horoscope,
    };
  }
}
