import { Injectable, OnModuleInit } from '@nestjs/common';
import { RabbitMQService } from 'src/rabbitmq/rabbitmq.service';
import { CreateChatMessageDto } from './dto/create-chat-message.dto';

@Injectable()
export class ChatService implements OnModuleInit {
  constructor(private readonly rabbitMQService: RabbitMQService) {}

  onModuleInit() {
    this.rabbitMQService.connect();
  }

  async sendMessage(createChatMessageDto: CreateChatMessageDto): Promise<void> {
    await this.rabbitMQService.sendToQueue(createChatMessageDto);
  }

  async receiveMessage(queue: string): Promise<boolean> {
    const message = await this.rabbitMQService.consume(queue, async (msg) => {
      console.log('Message received: ', msg?.content.toString());
    });
    console.log('Message: ', message);
    return true;
  }
}
