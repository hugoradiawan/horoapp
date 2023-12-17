import { Controller, Post, Body } from '@nestjs/common';
import { ChatService } from './chat.service';

@Controller('api')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Post('sendChat')
  async sendMessage(@Body('message') message: string) {
    return this.chatService.sendMessage(message);
  }
}
