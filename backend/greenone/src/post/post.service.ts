import { Inject, Injectable } from '@nestjs/common';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { Post } from './entities/post.entity';
import { ResponseStrategy } from '../shared/strategies/response.strategy';
import { AppRepository } from 'src/app.repository';
import { UserService } from 'src/user/user.service';
import * as admin from 'firebase-admin';
import { ChatGptService } from 'src/chat-gpt/chat-gpt.service';
import { PetService } from 'src/pet/pet.service';

@Injectable()
export class PostService {
  constructor(
    @Inject('POST_REPOSITORY')
    private postRepository: AppRepository<Post>,
    private responseStrategy: ResponseStrategy,
    private readonly userService: UserService,
    private readonly gptService: ChatGptService,
    private readonly petService: PetService,
  ) {}

  async uploadImage(file: Express.Multer.File): Promise<string> {
    const bucket = admin.storage().bucket();
    const fileName = Date.now() + '-' + file.originalname;
    const fileUpload = bucket.file(fileName);
    await fileUpload.save(file.buffer, {
      metadata: { contentType: file.mimetype },
    });
    return `https://storage.googleapis.com/${bucket.name}/${fileName}`;
  }

  async create(imageUrl: string, createPostDto: CreatePostDto) {
    try {
      const user = await this.userService.findOne(createPostDto.authorId);
      if (user.status === 404) {
        return this.responseStrategy.notFound('User not found');
      }
      const post: Post = {
        ...createPostDto,
        imageUrl,
        createdAt: new Date(),
      };
      const id = await this.postRepository.create(post);
      const verified = await this.gptService.verifyImage(
        imageUrl,
        createPostDto.title,
      );

      const pet = await this.petService.findOne(createPostDto.authorId);

      if (pet['data']['percent'] + (verified ? 14 : 10) >= 100) {
        this.petService.update(createPostDto.authorId, {
          age: pet['data']['age'] + 1,
          percent: 0,
        });
      } else {
        this.petService.update(createPostDto.authorId, {
          age: pet['data']['age'],
          percent: pet['data']['percent'] + (verified ? 14 : 10),
        });
      }

      this.userService.update(createPostDto.authorId, {
        lastPostDate: post.createdAt,
        umbrage: user['data']['umbrage'] + (verified ? 7 : 5),
      });

      return this.responseStrategy.success('Post created successfully', {
        id,
        ...post,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to create post', error);
    }
  }

  async findAll() {
    try {
      const posts = await this.postRepository.findAll();
      return posts.length === 0
        ? this.responseStrategy.noContent('No posts found')
        : this.responseStrategy.success('Posts retrieved successfully', posts);
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve posts', error);
    }
  }

  async findOne(id: string) {
    try {
      const post = await this.postRepository.findOne(id);
      return post
        ? this.responseStrategy.success('Post retrieved successfully', post)
        : this.responseStrategy.notFound('Post not found');
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve post', error);
    }
  }

  async findByUserId(postId: string) {
    const post = await this.postRepository.findByUserId(postId, 'authorId');
    return post.length > 0
      ? this.responseStrategy.success('Post retrieved successfully', post)
      : this.responseStrategy.notFound('Post not found');
  }

  async update(id: string, updatePostDto: UpdatePostDto) {
    try {
      const existingPost = await this.postRepository.findOne(id);
      if (!existingPost) {
        return this.responseStrategy.notFound('Post not found');
      }
      const updatedPost: Partial<Post> = {
        ...updatePostDto,
      };
      await this.postRepository.update(id, updatedPost);
      return this.responseStrategy.success('Post updated successfully', {
        id,
        ...existingPost,
        ...updatedPost,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to update post', error);
    }
  }

  async remove(id: string) {
    try {
      const existingPost = await this.postRepository.findOne(id);
      if (!existingPost) {
        return this.responseStrategy.notFound('Post not found');
      }
      await this.postRepository.remove(id);
      return this.responseStrategy.success('Post deleted successfully');
    } catch (error) {
      return this.responseStrategy.error('Failed to delete post', error);
    }
  }
}
