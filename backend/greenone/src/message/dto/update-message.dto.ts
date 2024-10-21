import { PartialType } from '@nestjs/mapped-types';
import { CreateMessageDto } from './create-message.dto';
import { IsString } from 'class-validator';

export class UpdateMessageDto extends PartialType(CreateMessageDto) {
  @IsString()
  userId: string;

  @IsString()
  content: string;
}
