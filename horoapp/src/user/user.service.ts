import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './interfaces/user.interface';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(@InjectModel('User') private readonly userModel: Model<User>) {}

  async create(createUserDto: CreateUserDto): Promise<string | undefined> {
    const createdUser = new this.userModel(createUserDto);
    createdUser.password = await bcrypt.hash(createdUser.password, 10);
    const result = await createdUser.save();
    return result._id.toString();
  }

  async findOneByEmailOrByUsername(
    emailOrUsername: string,
  ): Promise<User | null> {
    return this.userModel
      .findOne({
        $or: [{ email: emailOrUsername }, { username: emailOrUsername }],
      })
      .exec();
  }

  async findOneByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async findOneByUsername(username: string): Promise<User | null> {
    return this.userModel.findOne({ username }).exec();
  }
}
