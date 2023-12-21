import { Module } from '@nestjs/common';
import { GridfsService } from './gridfs.service';
import { GridfsController } from './gridfs.controller';

@Module({
  providers: [GridfsService],
  controllers: [GridfsController],
  exports: [GridfsService],
})
export class GridfsModule {}
