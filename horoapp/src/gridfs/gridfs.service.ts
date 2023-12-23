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
    });

    readStream.pipe(uploadStream);
  }

  async deleteFile(filename: string): Promise<void> {
    await this.gfs.delete(new mongoose.Types.ObjectId(filename));
  }

  async getFile(filename: string): Promise<Readable | undefined> {
    try {
      const file = await this.gfs.find({ filename }).toArray();
      if (!file || file.length === 0) {
        return undefined;
      }
      return this.gfs.openDownloadStreamByName(filename);
    } catch (error) {
      return undefined;
    }
  }
}
