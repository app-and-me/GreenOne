import { PartialType } from '@nestjs/mapped-types';
import { CreateUserDto } from './create-user.dto';
import { IsDate, ValidateIf } from 'class-validator';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @IsDate()
  @ValidateIf((_object, value) => value !== null)
  lastPostDate: Date | null;
}
