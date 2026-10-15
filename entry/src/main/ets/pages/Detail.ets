import { Nav } from '../common/Nav';
import { Note, NoteModel } from '../common/NoteModel';
import { NoteStore } from '../common/NoteStore';

@Entry
@Component
struct Detail {
  @State note: Note = new Note();
  @State found: boolean = false;
  @State error: string = '';
  private noteId: string = '';

  aboutToAppear(): void { this.noteId = Nav.id(); this.refresh(); }
  onPageShow(): void { this.refresh(); }
  refresh(): void {
    try {
      const current: Note | undefined = NoteStore.get(this.noteId);
      this.found = current !== undefined;
      if (current !== undefined) { this.note = current; }
      this.error = '';
    } catch { this.error = '读取失败，请返回后重试'; this.found = false; }
  }

  confirmDelete(): void {
    AlertDialog.show({
      title: '删除备忘录', message: '确定删除这条记录吗？删除后无法恢复。',
      primaryButton: { value: '取消', action: () => {} },
      secondaryButton: { value: '删除', action: () => {
        try { NoteStore.remove(this.noteId); Nav.back(); }
        catch { this.error = '删除失败，请稍后重试'; }
      } }
    });
  }

  build() {
    Column({ space: 18 }) {
      Row({ space: 12 }) {
        Button('返回').backgroundColor('#E2EFEB').fontColor('#147D73').onClick(() => Nav.back())
        Text('备忘录详情').fontSize(23).fontWeight(FontWeight.Bold)
      }.width('100%')
      if (this.found) {
        Scroll() {
          Column({ space: 16 }) {
            Text(this.note.title).fontSize(26).fontWeight(FontWeight.Bold).fontColor('#173E38')
            Text(this.note.category).fontSize(14).fontColor('#147D73')
            Text('创建：' + NoteModel.time(this.note.createdAt)).fontSize(12).fontColor('#87938F')
            Text('修改：' + NoteModel.time(this.note.updatedAt)).fontSize(12).fontColor('#87938F')
            Divider()
            Text(this.note.content.length > 0 ? this.note.content : '暂无正文')
              .fontSize(17).lineHeight(28).fontColor('#304B45').width('100%')
          }.alignItems(HorizontalAlign.Start).width('100%').padding(18)
        }.layoutWeight(1).backgroundColor(Color.White).borderRadius(14).width('100%')
        Row({ space: 14 }) {
          Button('编辑').layoutWeight(1).height(46).backgroundColor('#147D73')
            .onClick(() => Nav.open('pages/Edit', this.noteId))
          Button('删除').layoutWeight(1).height(46).backgroundColor('#F9E6E3').fontColor('#B83A3A')
            .onClick(() => this.confirmDelete())
        }.width('100%')
      } else {
        Text('记录不存在，请返回列表').layoutWeight(1)
      }
      Text(this.error).fontSize(14).fontColor('#B83A3A')
    }.padding(20).width('100%').height('100%').backgroundColor('#F4F8F7')
  }
}
