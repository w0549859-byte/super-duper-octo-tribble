import { fileIo as fs } from '@kit.CoreFileKit';
import { Note, NoteModel } from './NoteModel';

export class NoteStore {
  private static path: string = '';
  private static notes: Note[] = [];

  static init(filesDir: string): void {
    const path: string = filesDir + '/simple_memo_notes_v1.json';
    let notes: Note[] = [];
    if (fs.accessSync(path)) {
      // 读取异常时保留原文件，不用空记录覆盖已有内容。
      notes = JSON.parse(fs.readTextSync(path)) as Note[];
      notes = NoteModel.filter(notes, '');
    }
    NoteStore.notes = notes;
    NoteStore.path = path;
  }

  static all(): Note[] {
    if (NoteStore.path.length === 0) { throw new Error('存储尚未初始化'); }
    return NoteModel.filter(NoteStore.notes, '');
  }

  static get(id: string): Note | undefined {
    return NoteStore.all().find((note: Note) => note.id === id);
  }

  private static commit(next: Note[]): void {
    if (NoteStore.path.length === 0) { throw new Error('存储尚未初始化'); }
    const text: string = JSON.stringify(next);
    const temp: string = NoteStore.path + '.tmp';
    const file = fs.openSync(temp, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
    try { fs.writeSync(file.fd, text); }
    finally { fs.closeSync(file); }
    if (fs.readTextSync(temp) !== text) { throw new Error('文件写入不完整'); }
    // 临时文件完整写入后再替换；失败时不更新内存中的记录。
    fs.renameSync(temp, NoteStore.path);
    NoteStore.notes = next;
  }

  static save(id: string, title: string, content: string, category: string): void {
    NoteStore.commit(NoteModel.save(NoteStore.all(), id, title, content, category, Date.now()));
  }

  static remove(id: string): void {
    NoteStore.commit(NoteModel.remove(NoteStore.all(), id));
  }
}
