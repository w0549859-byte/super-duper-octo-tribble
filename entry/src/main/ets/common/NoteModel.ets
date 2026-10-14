// 数据处理与界面分离；不依赖网络或第三方库。
export class Note {
  id: string = '';
  title: string = '';
  content: string = '';
  category: string = '生活';
  createdAt: number = 0;
  updatedAt: number = 0;
}

export class NoteModel {
  static categories: string[] = ['生活', '学习', '工作'];

  static validate(title: string, content: string): string {
    if (title.trim().length === 0) { return '请填写标题'; }
    if (title.trim().length > 40) { return '标题最多40字'; }
    if (content.length > 2000) { return '内容最多2000字'; }
    return '';
  }

  static filter(notes: Note[], query: string): Note[] {
    const word: string = query.trim().toLowerCase();
    return notes.filter((note: Note) =>
      note.title.toLowerCase().includes(word) || note.content.toLowerCase().includes(word)
    ).sort((a: Note, b: Note) => b.updatedAt - a.updatedAt);
  }

  static save(notes: Note[], id: string, title: string, content: string,
    category: string, now: number): Note[] {
    const error: string = NoteModel.validate(title, content);
    if (error.length > 0) { throw new Error(error); }
    if (!NoteModel.categories.includes(category)) { throw new Error('分类无效'); }
    const old: Note | undefined = notes.find((item: Note) => item.id === id);
    if (id.length > 0 && old === undefined) { throw new Error('记录已不存在'); }
    const note: Note = new Note();
    note.id = old !== undefined ? old.id : now.toString() + '_' + Math.random().toString(36).slice(2, 10);
    note.title = title.trim();
    note.content = content;
    note.category = category;
    note.createdAt = old !== undefined ? old.createdAt : now;
    note.updatedAt = now;
    return [note].concat(notes.filter((item: Note) => item.id !== note.id));
  }

  static remove(notes: Note[], id: string): Note[] {
    return notes.filter((note: Note) => note.id !== id);
  }

  static time(value: number): string {
    const date: Date = new Date(value);
    const month: string = (date.getMonth() + 1).toString().padStart(2, '0');
    const day: string = date.getDate().toString().padStart(2, '0');
    const hour: string = date.getHours().toString().padStart(2, '0');
    const minute: string = date.getMinutes().toString().padStart(2, '0');
    return `${date.getFullYear()}-${month}-${day} ${hour}:${minute}`;
  }
}
