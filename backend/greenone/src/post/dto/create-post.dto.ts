import { IsString } from 'class-validator';

export class CreatePostDto {
  @IsString()
  authorId: string;

  @IsString()
  content: string;

  @IsString()
  imageUrl: string;
}
