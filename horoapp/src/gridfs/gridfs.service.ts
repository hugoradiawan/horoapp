import { Injectable } from '@nestjs/common';
import * as mongoose from 'mongoose';
import { GridFSBucket } from 'mongodb';
import { Readable } from 'stream';
import { InjectConnection } from '@nestjs/mongoose';

@Injectable()
export class GridfsService {
  private gfs!: GridFSBucket;

  constructor(
    @InjectConnection() private readonly connection: mongoose.Connection,
  ) {
    this.gfs = new mongoose.mongo.GridFSBucket(this.connection.db, {
      bucketName: 'uploads',
    });
  }

  async saveFile(file: Express.Multer.File): Promise<void> {
    const readStream = new Readable();
    readStream._read = () => {};
    readStream.push(file.buffer);
    readStream.push(null);

    const uploadStream = this.gfs.openUploadStream(file.originalname, {
      contentType: file.mimetype,
      metadata: file,
    });

    readStream.pipe(uploadStream);
  }

  async getFile(filename: string): Promise<Readable> {
    const downloadStream = this.gfs.openDownloadStreamByName(filename);
    return downloadStream;
  }
}
