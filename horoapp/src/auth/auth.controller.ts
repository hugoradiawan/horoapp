import { Controller, Post, Body, Res } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginUserDto } from 'src/user/dto/login-user.dto';
import { Response } from 'express';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import { UserService } from 'src/user/user.service';
import { ServerResponse } from 'src/shared/dto/server-response.dto';
import { Jwt } from './interfaces/jwt.dto';
import { ProfileService } from 'src/profile/profile.service';

@Controller('api')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly userService: UserService,
    private readonly profileService: ProfileService,
  ) {}

  @Post('login')
  async login(
    @Res() res: Response,
    @Body() loginUserDto: LoginUserDto,
  ): Promise<Response> {
    const jwt = await this.authService.login(loginUserDto);
    return res.status(!jwt ? 401 : 200).json({
      isOk: jwt !== undefined,
      message: !jwt ? 'Invalid username, email or password' : undefined,
      errorCode: !jwt ? 2004 : undefined,
      data: jwt,
    } satisfies ServerResponse<Jwt>);
  }

  @Post('register')
  async register(
    @Res() res: Response,
    @Body() createUserDto: CreateUserDto,
  ): Promise<Response> {
    const users = await Promise.all([
      this.userService.findOneByEmail(createUserDto.email),
      this.userService.findOneByUsername(createUserDto.username),
    ]);
    const isPasswordNumberic = /^\d+$/.test(createUserDto.password);
    if (!isPasswordNumberic) {
      return this.buildErrorReponse(res, 2005, 'Password must be numeric');
    } else if (users[0] != null) {
      return this.buildErrorReponse(res, 2001, 'Email already exists');
    } else if (users[1] != null) {
      return this.buildErrorReponse(res, 2002, 'Username already exists');
    } else {
      const userId = await this.userService.create(createUserDto);
      if (!userId) {
        return this.buildErrorReponse(res, 2005, 'User creation failed');
      }
      this.profileService.create(userId, {});
      if (userId) {
        return res.status(201).send();
      } else {
        return this.buildErrorReponse(res, 2003, 'User creation failed');
      }
    }
  }

  private buildErrorReponse(
    res: Response,
    errorCode: number,
    message: string,
  ): Response {
    return res.status(500).json({
      isOk: false,
      errorCode,
      message,
    } satisfies ServerResponse<unknown>);
  }
}
