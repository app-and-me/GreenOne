import { IsString } from 'class-validator';

export class CreatePetDto {
  @IsString()
  masterId: string;
}
