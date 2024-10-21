import { Module } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import { AppRepository } from 'src/app.repository';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { Message } from './entities/message.entity';
import { MessageService } from './message.service';
import { MessageController } from './message.controller';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [FirebaseModule, UserModule],
  controllers: [MessageController],
  providers: [
    MessageService,
    ResponseStrategy,
    {
      provide: 'MESSAGE_COLLECTION',
      useValue: 'Message',
    },
    {
      provide: 'MESSAGE_REPOSITORY',
      useFactory: (firebaseService: FirebaseService, collection: string) => {
        return new AppRepository<Message>(firebaseService, collection);
      },
      inject: [FirebaseService, 'MESSAGE_COLLECTION'],
    },
  ],
  exports: [MessageService],
})
export class MessageModule {}
