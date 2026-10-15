import { Nav } from '../common/Nav';
import { Note, NoteModel } from '../common/NoteModel';
import { NoteStore } from '../common/NoteStore';

@Entry
@Component
struct Edit {
  @State title: string = '';
  @State content: string = '';
  @State category: string = '生活';
  @State error: string = '';
  @State available: boolean = true;
  @State saving: boolean = false;
  private noteId: string = '';

  aboutToAppear(): void {
    this.noteId = Nav.id();
    try {
      const note: Note | undefined = NoteStore.get(this.noteId);
      if (note === undefined) { this.error = '记录不存在，请返回'; this.available = false; return; }
      this.title = note.title;
      this.content = note.content;
      this.category = note.category;
    } catch { this.error = '读取失败，请返回后重试'; this.available = false; }
  }

  save(): void {
    if (this.saving || !this.available) { return; }
    this.error = NoteModel.validate(this.title, this.content);
    if (this.error.length > 0) { return; }
    this.saving = true;
    try {
      NoteStore.save(this.noteId, this.title, this.content, this.category);
      Nav.back();
    } catch { this.error = '保存失败，请返回后重试'; this.saving = false; }
  }

  build() {
    Scroll() {
      Column({ space: 18 }) {
        Row({ space: 12 }) {
          Button('返回').backgroundColor('#E2EFEB').fontColor('#147D73').onClick(() => Nav.back())
          Text('编辑备忘录').fontSize(23).fontWeight(FontWeight.Bold)
        }.width('100%')
        Text('标题').fontSize(15).fontColor('#657572').width('100%')
        TextInput({ placeholder: '写一个简短的标题（最多40字）', text: this.title })
          .maxLength(40).height(50).onChange((value: string) => { this.title = value; this.error = ''; })
        Text('分类').fontSize(15).fontColor('#657572').width('100%')
        Row({ space: 12 }) {
          ForEach(NoteModel.categories, (item: string) => {
            Button(item).layoutWeight(1)
              .backgroundColor(this.category === item ? '#147D73' : '#E2EFEB')
              .fontColor(this.category === item ? '#FFFFFF' : '#147D73')
              .onClick(() => { this.category = item; })
          }, (item: string) => item)
        }.width('100%')
        Text('内容').fontSize(15).fontColor('#657572').width('100%')
        TextArea({ placeholder: '想记下什么？', text: this.content })
          .height(240).maxLength(2000).onChange((value: string) => { this.content = value; })
        Text(`${this.content.length} / 2000`).fontSize(12).fontColor('#87938F').width('100%').textAlign(TextAlign.End)
        Text(this.error).fontColor('#B83A3A').fontSize(14).width('100%')
        Button('保存').width('100%').height(48).backgroundColor('#147D73')
          .enabled(this.available && !this.saving).onClick(() => this.save())
        Text('返回将放弃本次尚未保存的修改').fontSize(12).fontColor('#87938F')
      }.padding(20).width('100%')
    }.width('100%').height('100%').backgroundColor('#F4F8F7')
  }
}
