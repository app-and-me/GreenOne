import { PartialType } from '@nestjs/mapped-types';
import { CreatePostDto } from './create-post.dto';
import { IsString } from 'class-validator';

export class UpdatePostDto extends PartialType(CreatePostDto) {
  @IsString()
  authorId: string;

  @IsString()
  content: string;

  @IsString()
  imageUrl: string;

  @IsString()
  title: string;
}
