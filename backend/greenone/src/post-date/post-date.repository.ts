import { Injectable } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import { FieldValue } from 'firebase-admin/firestore';

@Injectable()
export class PostDateRepository {
  constructor(private firebaseService: FirebaseService) {}

  async setDate(userId: string, date: string, value: boolean): Promise<void> {
    const postDatesCollection = this.firebaseService
      .getFirestore()
      .collection('PostDate');
    await postDatesCollection
      .doc(userId)
      .set({ [date]: value }, { merge: true });
  }

  async getDate(userId: string, date: string): Promise<boolean | undefined> {
    const postDatesCollection = this.firebaseService
      .getFirestore()
      .collection('PostDate');
    const doc = await postDatesCollection.doc(userId).get();
    const data = doc.data();
    return data ? data[date] : undefined;
  }

  async getAllDates(
    userId: string,
  ): Promise<{ [date: string]: boolean } | undefined> {
    const postDatesCollection = this.firebaseService
      .getFirestore()
      .collection('PostDate');
    const doc = await postDatesCollection.doc(userId).get();
    return doc.data() as { [date: string]: boolean } | undefined;
  }

  async deleteDate(userId: string, date: string): Promise<void> {
    const postDatesCollection = this.firebaseService
      .getFirestore()
      .collection('PostDate');
    await postDatesCollection.doc(userId).update({
      [date]: FieldValue.delete(),
    });
  }
}
