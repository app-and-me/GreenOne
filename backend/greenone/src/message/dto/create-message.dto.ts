import { IsString } from 'class-validator';

export class CreateMessageDto {
  @IsString()
  userId: string;

  @IsString()
  content: string;
}
