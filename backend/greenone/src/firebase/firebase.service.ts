import { Injectable, OnModuleInit } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { ConfigService } from '@nestjs/config';
import * as path from 'path';

@Injectable()
export class FirebaseService implements OnModuleInit {
  private defaultApp: admin.app.App;

  constructor(private configService: ConfigService) {}

  onModuleInit() {
    const serviceAccountPath = this.configService.get<string>(
      'FIREBASE_SERVICE_ACCOUNT_PATH',
    );

    if (!serviceAccountPath) {
      throw new Error(
        'FIREBASE_SERVICE_ACCOUNT_PATH is not defined in the configuration.',
      );
    }

    const resolvedPath = path.resolve(__dirname, '../../', serviceAccountPath);

    this.defaultApp = admin.initializeApp({
      credential: admin.credential.cert(resolvedPath),
      storageBucket: 'greenone-720b2.appspot.com',
    });
  }

  getFirestore() {
    return this.defaultApp.firestore();
  }
}
