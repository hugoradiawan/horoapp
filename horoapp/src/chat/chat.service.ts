import { Injectable } from '@nestjs/common';
import { RabbitMQService } from 'src/rabbitmq/rabbitmq.service';

@Injectable()
export class ChatService {
  constructor(private readonly rabbitMQService: RabbitMQService) {}

  async sendMessage(queue: string, message: string): Promise<void> {
    await this.rabbitMQService.send(queue, message);
  }

  async receiveMessage(queue: string): Promise<string> {
    const message = await this.rabbitMQService.receive(queue);
    return message;
  }
}
