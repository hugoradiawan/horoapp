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
import { UserService } from 'src/user/user.service';
import { GridfsService } from 'src/gridfs/gridfs.service';

@Controller('api')
export class ProfileController {
  constructor(
    private readonly profileService: ProfileService,
    private readonly userService: UserService,
    private readonly gridfsService: GridfsService,
  ) {}

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
    } as Profile;
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
    const [profile, user] = await Promise.all([
      this.profileService.findOne(jwtPayload.sub),
      this.userService.findOneById(jwtPayload.sub),
    ]);
    const response: ServerResponse<Profile> = {
      isOk: profile !== null && user !== null,
      ...(profile === null || user === null
        ? {
            errorCode: 1000,
            message: `Profile not found`,
          }
        : { data: this.sanitizeData(profile, user?.username) }),
    };
    return res.status(profile === null ? 404 : 201).json(response);
  }

  @Get('resetProfile')
  @UseGuards(AuthGuard)
  async reset(@Req() req: AuthRequest): Promise<boolean> {
    const jwtPayload = req.payload;
    await this.profileService.reset(jwtPayload.sub);
    const profile = await this.profileService.findOne(jwtPayload.sub);
    console.log(profile?._id);
    if (profile) {
      await this.gridfsService.deleteFile(profile._id.toString());
    }
    return true;
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
    console.log(toupdate);
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

  private sanitizeData(data: ProfileDocument, username: string): Profile {
    const {
      _id,
      name,
      birthday,
      heightInCm,
      weightInKg,
      gender,
      interests,
      zodiac,
      horoscope,
    } = data;
    const tempdata = {
      pId: _id,
      name,
      birthday,
      username,
      heightInCm,
      weightInKg,
      gender,
      interests,
      zodiac,
      horoscope,
    };
    if (tempdata.interests?.length === 0) delete tempdata.interests;
    return tempdata;
  }
}
