import { Module } from '@nestjs/common';
import { PostDateService } from './post-date.service';
import { PostDateController } from './post-date.controller';
import { PostDateRepository } from './post-date.repository';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [FirebaseModule, UserModule],
  providers: [PostDateService, PostDateRepository, ResponseStrategy],
  controllers: [PostDateController],
})
export class PostDateModule {}
