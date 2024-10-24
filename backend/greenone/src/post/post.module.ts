import { Module } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import { AppRepository } from 'src/app.repository';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { Post } from './entities/post.entity';
import { PostService } from './post.service';
import { PostController } from './post.controller';
import { UserModule } from 'src/user/user.module';
import { PetService } from 'src/pet/pet.service';
import { ChatGptService } from 'src/chat-gpt/chat-gpt.service';

@Module({
  imports: [FirebaseModule, UserModule],
  controllers: [PostController],
  providers: [
    PostService,
    PetService,
    ChatGptService,
    ResponseStrategy,
    {
      provide: 'POST_COLLECTION',
      useValue: 'Post',
    },
    {
      provide: 'PET_REPOSITORY',
      useFactory: (firebaseService: FirebaseService) => {
        return new AppRepository<any>(firebaseService, 'Pet');
      },
      inject: [FirebaseService],
    },
    {
      provide: 'POST_REPOSITORY',
      useFactory: (firebaseService: FirebaseService, collection: string) => {
        return new AppRepository<Post>(firebaseService, collection);
      },
      inject: [FirebaseService, 'POST_COLLECTION'],
    },
  ],
  exports: [PostService],
})
export class PostModule {}
