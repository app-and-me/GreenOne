import { Controller, Param, Body, Put, Get, Delete } from '@nestjs/common';
import { PostDateService } from './post-date.service';

@Controller('api/post-date/:userId')
export class PostDateController {
  constructor(private readonly postDateService: PostDateService) {}

  @Put(':date')
  async setDate(
    @Param('userId') userId: string,
    @Param('date') date: string,
    @Body('value') value: boolean,
  ) {
    return this.postDateService.setDate(userId, date, value);
  }

  @Get(':date')
  async getDate(@Param('userId') userId: string, @Param('date') date: string) {
    return this.postDateService.getDate(userId, date);
  }

  @Get()
  async getAllDates(@Param('userId') userId: string) {
    return this.postDateService.getAllDates(userId);
  }

  @Delete(':date')
  async deleteDate(
    @Param('userId') userId: string,
    @Param('date') date: string,
  ) {
    return this.postDateService.deleteDate(userId, date);
  }
}
