import { MiddlewareConsumer, Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { UserModule } from './user/user.module';
import { PetModule } from './pet/pet.module';
import { PostModule } from './post/post.module';
import { PostDateModule } from './post-date/post-date.module';
import { AuthMiddleware } from './auth.middleware';
import { ChatGptModule } from './chat-gpt/chat-gpt.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    UserModule,
    PetModule,
    PostModule,
    PostDateModule,
    ChatGptModule,
  ],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(AuthMiddleware).forRoutes('*');
  }
}
