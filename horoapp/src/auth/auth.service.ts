import { Injectable } from '@nestjs/common';
import { User } from 'src/user/interfaces/user.interface';
import { UserService } from 'src/user/user.service';
import * as bcrypt from 'bcrypt';
import { LoginUserDto } from 'src/user/dto/login-user.dto';
import { JwtService } from '@nestjs/jwt';
import { Jwt, JwtPayload } from './interfaces/jwt.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  private async validateUser(
    emailOrUsername: string,
    password: string,
  ): Promise<User | null> {
    const user =
      await this.userService.findOneByEmailOrByUsername(emailOrUsername);
    if (user === null) return null;
    const isPasswordMatched = await bcrypt.compare(password, user.password);
    return isPasswordMatched ? user : null;
  }

  /**
   *
   * @param loginUserDto
   * @returns {Promise<Jwt | null>} null if user not found or password not matched
   * @memberof AuthService
   * @description
   * This method is used to validate user and return a JWT token
   * if user is valid.
   * If user is not valid, null is returned.
   * @example
   * const jwt = await this.authService.login(loginUserDto);
   * if (jwt === null) {
   *  // user not found or password not matched
   * } else {
   * // user is valid
   * }
   */
  async login(loginUserDto: LoginUserDto): Promise<Jwt | undefined> {
    const user = await this.validateUser(
      loginUserDto.usernameOrEmail,
      loginUserDto.password,
    );
    if (user === null) return undefined;
    const payload = { sub: user._id } satisfies JwtPayload;
    return { accessToken: this.jwtService.sign(payload) } satisfies Jwt;
  }
}
