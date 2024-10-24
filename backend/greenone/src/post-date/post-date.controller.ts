import { Controller, Param, Body, Put, Get, Delete, Req } from '@nestjs/common';
import { PostDateService } from './post-date.service';

@Controller('api/post-date/')
export class PostDateController {
  constructor(private readonly postDateService: PostDateService) {}

  @Put(':date')
  async setDate(
    @Req() req: Request,
    @Param('date') date: string,
    @Body('value') value: boolean,
  ) {
    const user = req['user'];
    return this.postDateService.setDate(user.user_id, date, value);
  }

  @Get(':date')
  async getDate(@Req() req: Request, @Param('date') date: string) {
    const user = req['user'];
    return this.postDateService.getDate(user.user_id, date);
  }

  @Get()
  async getAllDates(@Req() req: Request) {
    const user = req['user'];
    return this.postDateService.getAllDates(user.user_id);
  }

  @Delete(':date')
  async deleteDate(@Req() req: Request, @Param('date') date: string) {
    const user = req['user'];
    return this.postDateService.deleteDate(user.user_id, date);
  }
}
