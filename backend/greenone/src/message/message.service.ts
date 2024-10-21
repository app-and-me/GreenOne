import { Inject, Injectable } from '@nestjs/common';
import { CreateMessageDto } from './dto/create-message.dto';
import { UpdateMessageDto } from './dto/update-message.dto';
import { Message } from './entities/message.entity';
import { ResponseStrategy } from '../shared/strategies/response.strategy';
import { AppRepository } from 'src/app.repository';
import { UserService } from 'src/user/user.service';

@Injectable()
export class MessageService {
  constructor(
    @Inject('MESSAGE_REPOSITORY')
    private messageRepository: AppRepository<Message>,
    private responseStrategy: ResponseStrategy,
    private readonly userService: UserService,
  ) {}

  async create(createMessageDto: CreateMessageDto) {
    try {
      const user = await this.userService.findOne(createMessageDto.userId);
      if (user.status === 404) {
        return this.responseStrategy.notFound('User not found');
      }
      const message: Message = {
        ...createMessageDto,
        createdAt: new Date(),
      };
      const id = await this.messageRepository.create(message);
      return this.responseStrategy.success('Message created successfully', {
        id,
        ...message,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to create message', error);
    }
  }

  async findAll() {
    try {
      const messages = await this.messageRepository.findAll();
      return messages.length === 0
        ? this.responseStrategy.noContent('No messages found')
        : this.responseStrategy.success(
            'Messages retrieved successfully',
            messages,
          );
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve messages', error);
    }
  }

  async findOne(id: string) {
    try {
      const message = await this.messageRepository.findOne(id);
      return message
        ? this.responseStrategy.success(
            'Message retrieved successfully',
            message,
          )
        : this.responseStrategy.notFound('Message not found');
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve message', error);
    }
  }

  async findByUserId(messageId: string) {
    const message = await this.messageRepository.findByUserId(
      messageId,
      'userId',
    );
    return message.length > 0
      ? this.responseStrategy.success('Message retrieved successfully', message)
      : this.responseStrategy.notFound('Message not found');
  }

  async update(id: string, updateMessageDto: UpdateMessageDto) {
    try {
      const existingMessage = await this.messageRepository.findOne(id);
      if (!existingMessage) {
        return this.responseStrategy.notFound('Message not found');
      }
      const updatedMessage: Partial<Message> = {
        ...updateMessageDto,
      };
      await this.messageRepository.update(id, updatedMessage);
      return this.responseStrategy.success('Message updated successfully', {
        id,
        ...existingMessage,
        ...updatedMessage,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to update message', error);
    }
  }

  async remove(id: string) {
    try {
      const existingMessage = await this.messageRepository.findOne(id);
      if (!existingMessage) {
        return this.responseStrategy.notFound('Message not found');
      }
      await this.messageRepository.remove(id);
      return this.responseStrategy.success('Message deleted successfully');
    } catch (error) {
      return this.responseStrategy.error('Failed to delete message', error);
    }
  }
}
