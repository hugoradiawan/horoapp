import { Module } from '@nestjs/common';
import { ProfileController } from './profile.controller';
import { ProfileService } from './profile.service';
import { MongooseModule } from '@nestjs/mongoose';
import { ProfileSchema } from './schemas/profile.schema';
import { ZodiacEnd } from './schemas/zodiac.schema';
import { UserModule } from 'src/user/user.module';
import { GridfsModule } from 'src/gridfs/gridfs.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Profile', schema: ProfileSchema }]),
    MongooseModule.forFeature([{ name: 'ZodiacEnd', schema: ZodiacEnd }]),
    UserModule,
    GridfsModule,
  ],
  controllers: [ProfileController],
  providers: [ProfileService],
  exports: [ProfileService],
})
export class ProfileModule {}
