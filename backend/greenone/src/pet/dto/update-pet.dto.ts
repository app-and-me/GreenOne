import { PartialType } from '@nestjs/mapped-types';
import { CreatePetDto } from './create-pet.dto';
import { IsNumber } from 'class-validator';

export class UpdatePetDto extends PartialType(CreatePetDto) {
  @IsNumber()
  age: number;

  @IsNumber()
  percent: number;
}
