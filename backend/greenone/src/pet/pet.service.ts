import { Inject, Injectable } from '@nestjs/common';
import { ResponseStrategy } from '../shared/strategies/response.strategy';
import { AppRepository } from 'src/app.repository';
import { Pet } from './entities/pet.entity';
import { CreatePetDto } from './dto/create-pet.dto';
import { UpdatePetDto } from './dto/update-pet.dto';
import { UserService } from '../user/user.service';

@Injectable()
export class PetService {
  constructor(
    @Inject('PET_REPOSITORY')
    private PetRepository: AppRepository<Pet>,
    private responseStrategy: ResponseStrategy,
    private readonly userService: UserService,
  ) {}

  async create(createPetDto: CreatePetDto) {
    try {
      const user = await this.userService.findOne(createPetDto.masterId);
      if (user.status === 404) {
        return this.responseStrategy.notFound('User not found');
      }

      const Pet: Pet = {
        age: 1,
      };

      const id = await this.PetRepository.createById(
        Pet,
        createPetDto.masterId,
      );
      return this.responseStrategy.success('Pet created successfully', {
        id,
        ...Pet,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to create Pet', error);
    }
  }

  async findAll() {
    try {
      const Pets = await this.PetRepository.findAll();
      return Pets.length === 0
        ? this.responseStrategy.noContent('No Pets found')
        : this.responseStrategy.success('Pets retrieved successfully', Pets);
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve Pets', error);
    }
  }

  async findOne(id: string) {
    try {
      const Pet = await this.PetRepository.findOne(id);
      return Pet
        ? this.responseStrategy.success('Pet retrieved successfully', Pet)
        : this.responseStrategy.notFound('Pet not found');
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve Pet', error);
    }
  }

  async update(id: string, updatePetDto: UpdatePetDto) {
    try {
      const existingPet = await this.PetRepository.findOne(id);
      if (!existingPet) {
        return this.responseStrategy.notFound('Pet not found');
      }
      const updatedPet: Partial<Pet> = {
        ...updatePetDto,
      };
      await this.PetRepository.update(id, updatedPet);
      return this.responseStrategy.success('Pet updated successfully', {
        id,
        ...existingPet,
        ...updatedPet,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to update Pet', error);
    }
  }

  async remove(id: string) {
    try {
      const existingPet = await this.PetRepository.findOne(id);
      if (!existingPet) {
        return this.responseStrategy.notFound('Pet not found');
      }
      await this.PetRepository.remove(id);
      return this.responseStrategy.success('Pet deleted successfully');
    } catch (error) {
      return this.responseStrategy.error('Failed to delete Pet', error);
    }
  }
}
