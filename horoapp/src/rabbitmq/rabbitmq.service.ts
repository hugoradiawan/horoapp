import { Injectable, OnModuleInit } from '@nestjs/common';
import * as amqp from 'amqplib';

@Injectable()
export class RabbitMQService implements OnModuleInit {
  private connection?: amqp.Connection;
  private channel?: amqp.Channel;
  private readonly url = 'amqp://localhost';

  async onModuleInit() {
    await this.connect();
  }

  async connect() {
    this.connection = await amqp.connect(this.url);
    this.channel = await this.connection.createChannel();
    const queue = 'rpc_queue';
    await channel.assertQueue(queue, { durable: false });
  }

  async sendToQueue(queue: string, message: string) {
    if (!this.channel) {
      await this.connect();
    }
    return this.channel?.sendToQueue(queue, Buffer.from(message));
  }

  async consume(
    queue: string,
    callback: (msg: amqp.ConsumeMessage | null) => void,
  ) {
    if (!this.channel) {
      await this.connect();
    }
    return this.channel?.consume(queue, callback, { noAck: true });
  }
}
