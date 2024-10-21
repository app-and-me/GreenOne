import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { PetService } from './pet.service';
import { CreatePetDto } from './dto/create-pet.dto';
import { UpdatePetDto } from './dto/update-pet.dto';

@Controller('api/pet')
export class PetController {
  constructor(private readonly PetService: PetService) {}

  @Post()
  create(@Body() createPetDto: CreatePetDto) {
    return this.PetService.create(createPetDto);
  }

  @Get()
  findAll() {
    return this.PetService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.PetService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updatePetDto: UpdatePetDto) {
    return this.PetService.update(id, updatePetDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.PetService.remove(id);
  }
}
