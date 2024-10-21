import { forwardRef, Module } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import { AppRepository } from 'src/app.repository';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { PetService } from './pet.service';
import { PetController } from './pet.controller';
import { Pet } from './entities/pet.entity';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [FirebaseModule, forwardRef(() => UserModule)],
  controllers: [PetController],
  providers: [
    PetService,
    ResponseStrategy,
    {
      provide: 'PET_COLLECTION',
      useValue: 'Pet',
    },
    {
      provide: 'PET_REPOSITORY',
      useFactory: (firebaseService: FirebaseService, collection: string) => {
        return new AppRepository<Pet>(firebaseService, collection);
      },
      inject: [FirebaseService, 'PET_COLLECTION'],
    },
  ],
  exports: [PetService],
})
export class PetModule {}
