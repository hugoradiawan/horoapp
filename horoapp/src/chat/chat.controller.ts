import { Controller, Post, Body } from '@nestjs/common';
import { ChatService } from './chat.service';
import { CreateChatMessageDto } from './dto/create-chat-message.dto';

@Controller('api')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Post('sendChat')
  async sendMessage(@Body() createChatMessageDto: CreateChatMessageDto) {
    return this.chatService.sendMessage(createChatMessageDto);
  }
}
