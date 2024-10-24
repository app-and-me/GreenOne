import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';
import OpenAI from 'openai';
import * as fs from 'fs';

@Injectable()
@Injectable()
export class ChatGptService {
  static verifyImage() {
    throw new Error('Method not implemented.');
  }
  async createMessage() {
    const openai = new OpenAI({
      apiKey: process.env.CHAT_GPT_AI_KEY,
    });

    const stream = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: `You are a climate and environmental expert with deep knowledge of current global climate issues and practical solutions.

                    Your task is to:
                    1. Identify ONE pressing climate issue from today's perspective
                    2. Provide ONE simple, practical action that individuals can take to address this issue
                    3. Format your response in Korean using the following structure:
                      - 오늘의 기후 이슈: [현재 이슈 설명 (50자 이내)]
                      - 오늘의 기후 이슈와 관련된 실천 가능한 작은 행동: [일상적으로 할 수 있는 사소한 행동을 구체적으로 제안 (사진으로 인증할 수 있는 행동이어야 함) (10자 이내)]
                    
                    Keep your response concise and actionable. Focus on realistic, everyday actions that anyone can implement.`,
        },
        {
          role: 'user',
          content:
            '오늘의 중요한 기후 이슈와 그에 대한 실천 가능한 작은 행동을 알려주세요. 명령문으로 작성해주세요. (뭐뭐 하기) 8자 이내로 알려주세요.',
        },
      ],
      temperature: 0.7,
      max_tokens: 200,
      stream: true,
      presence_penalty: 0.1,
      frequency_penalty: 0.1,
    });

    const result = [];
    for await (const part of stream) {
      result.push(part.choices[0].delta.content);
    }
    return result.join('');
  }

  async verifyImage(imageUrl: string, todo: string): Promise<boolean> {
    const openai = new OpenAI({
      apiKey: process.env.CHAT_GPT_AI_KEY,
    });

    const storage = admin.storage();
    const fileName = imageUrl.split('/').pop();
    if (!fileName) {
      throw new Error('Invalid URL format');
    }

    const downloadUrl = await storage.bucket().file(fileName).getSignedUrl({
      action: 'read',
      expires: '03-01-2025',
    });

    const url = downloadUrl[0];

    const stream = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: `당신은 환경 보호 활동을 검증하는 전문가입니다. 
                    다음과 같은 기준으로 이미지를 분석해주세요:

                    1. 이미지가 실제 환경 관련 활동을 보여주는지 확인
                    2. 이미지가 명확하고 식별 가능한지 확인
                    3. 이미지가 제시된 환경 활동과 일치하는지 검증
                    4. 위조나 조작의 흔적이 있는지 확인

                    응답은 오직 true 또는 false로만 해주세요:
                    - true: 이미지가 모든 기준을 충족하고 진정성이 확인됨
                    - false: 이미지가 기준을 충족하지 못하거나 의심스러운 요소가 있음`,
        },
        {
          role: 'user',
          content: JSON.stringify([
            {
              type: 'text',
              text: `제시된 이미지가 "${todo}" 활동을 정확하게 보여주고 있는지 위의 기준에 따라 검증해주세요.`,
            },
            { type: 'image_url', image_url: url },
          ]),
        },
      ],
      stream: true,
    });

    const result = [];
    for await (const part of stream) {
      result.push(part.choices[0].delta.content);
    }
    return result.join('').toLowerCase().includes('true');
  }

  encodeImageToBase64(imagePath: string): Promise<string> {
    return new Promise((resolve, reject) => {
      fs.readFile(imagePath, (err, data) => {
        if (err) {
          reject(err);
        } else {
          const base64Image = data.toString('base64');
          resolve(base64Image);
        }
      });
    });
  }
}
