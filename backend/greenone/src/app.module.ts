import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { UserModule } from './user/user.module';
import { PetModule } from './pet/pet.module';
import { PostModule } from './post/post.module';
import { MessageModule } from './message/message.module';
import { PostdateModule } from './postdate/postdate.module';
import { PostDateModule } from './post-date/post-date.module';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true }), UserModule, PetModule, PostModule, MessageModule, PostdateModule, PostDateModule],
})
export class AppModule {}
