import { Injectable, OnModuleInit } from '@nestjs/common';
import { Connection, Channel, connect, ConsumeMessage } from 'amqplib';
import { CreateChatMessageDto } from 'src/chat/dto/create-chat-message.dto';

@Injectable()
export class RabbitMQService implements OnModuleInit {
  private connection?: Connection;
  private channel?: Channel;
  private readonly url = 'amqp://localhost';

  async onModuleInit() {
    await this.connect();
  }

  async connect() {
    this.connection = await connect(this.url);
    this.channel = await this.connection.createChannel();
    const queue = 'rpc_queue';
    await this.channel?.assertQueue(queue, { durable: false });
  }

  async sendToQueue(createChatMessageDto: CreateChatMessageDto) {
    if (!this.channel) {
      await this.connect();
    }
    return this.channel?.sendToQueue(
      createChatMessageDto.queue,
      Buffer.from(createChatMessageDto.message),
    );
  }

  async consume(queue: string, callback: (msg: ConsumeMessage | null) => void) {
    if (!this.channel) {
      await this.connect();
    }
    return this.channel?.consume(queue, callback, { noAck: true });
  }
}
