import { BadRequestException, Injectable } from '@nestjs/common';
import { ResponseStrategy } from '../shared/strategies/response.strategy';
import { PostDateRepository } from './post-date.repository';
import { UserService } from 'src/user/user.service';

@Injectable()
export class PostDateService {
  constructor(
    private readonly postDateRepository: PostDateRepository,
    private readonly responseStrategy: ResponseStrategy,
    private readonly userService: UserService,
  ) {}

  async setDate(userId: string, date: string, value: boolean) {
    try {
      const user = await this.userService.findOne(userId);
      if (user.status === 404) {
        return this.responseStrategy.notFound('User not found');
      }

      if (!this.isValidDate(date)) {
        return this.responseStrategy.error(
          'Invalid date format',
          new BadRequestException('Invalid date format'),
        );
      }

      await this.postDateRepository.setDate(userId, date, value);
      return this.responseStrategy.success('Post date set successfully', {
        userId,
        date,
        value,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to set post date', error);
    }
  }

  private isValidDate(dateString: string): boolean {
    const regex = /^\d{4}-\d{2}-\d{2}$/;
    if (!regex.test(dateString)) return false;

    const date = new Date(dateString);
    return date instanceof Date && !isNaN(date.getTime());
  }

  async getDate(userId: string, date: string) {
    try {
      const isDateSet = await this.postDateRepository.getDate(userId, date);
      if (typeof isDateSet === 'undefined') {
        return this.responseStrategy.notFound(
          'Post date information not found',
        );
      }
      return this.responseStrategy.success('Post date retrieved successfully', {
        userId,
        date,
        value: isDateSet,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to get post date', error);
    }
  }

  async getAllDates(userId: string) {
    try {
      const dates = await this.postDateRepository.getAllDates(userId);
      return dates
        ? this.responseStrategy.success(
            'All post dates retrieved successfully',
            dates,
          )
        : this.responseStrategy.noContent('No post dates found for this user');
    } catch (error) {
      return this.responseStrategy.error(
        'Failed to retrieve all post dates',
        error,
      );
    }
  }

  async deleteDate(userId: string, date: string) {
    try {
      await this.postDateRepository.deleteDate(userId, date);
      return this.responseStrategy.success('Post date deleted successfully', {
        userId,
        date,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to delete post date', error);
    }
  }
}
