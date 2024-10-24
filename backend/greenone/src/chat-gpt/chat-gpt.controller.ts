import { Controller, Get } from '@nestjs/common';
import { ChatGptService } from './chat-gpt.service';

@Controller('api/chat-gpt')
export class ChatGptController {
  constructor(private readonly chatGptService: ChatGptService) {}

  @Get()
  createMessage() {
    return this.chatGptService.createMessage();
  }
}
