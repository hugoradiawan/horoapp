import {
  Controller,
  Get,
  Param,
  UploadedFile,
  UseInterceptors,
  Res,
  Req,
  Put,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { GridfsService } from './gridfs.service';
import { Response } from 'express';

@Controller('api')
export class GridfsController {
  constructor(private readonly gridfsService: GridfsService) {}

  @Put('upload')
  @UseInterceptors(FileInterceptor('file'))
  async uploadFile(
    @UploadedFile() file: Express.Multer.File,
    @Req() req: Request,
  ) {
    console.log(req);
    console.log(file);
    await this.gridfsService.saveFile(file);
  }

  @Get('file/:filename')
  async getFile(@Param('filename') filename: string, @Res() res: Response) {
    const readStream = await this.gridfsService.getFile(filename);
    readStream.pipe<Response>(res);
  }
}
