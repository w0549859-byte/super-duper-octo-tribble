import { Nav } from '../common/Nav';
import { Note, NoteModel } from '../common/NoteModel';
import { NoteStore } from '../common/NoteStore';

@Entry
@Component
struct Home {
  @State notes: Note[] = [];
  @State query: string = '';
  @State error: string = '';

  aboutToAppear(): void { this.refresh(); }
  onPageShow(): void { this.refresh(); }
  refresh(): void {
    try { this.notes = NoteStore.all(); this.error = ''; }
    catch { this.error = '读取失败，请重启应用后重试'; }
  }

  build() {
    Column({ space: 16 }) {
      Row() {
        Column({ space: 4 }) {
          Text('我的备忘录').fontSize(27).fontWeight(FontWeight.Bold).fontColor('#173E38')
          Text(`共 ${this.notes.length} 条记录`).fontSize(13).fontColor('#657572')
        }.alignItems(HorizontalAlign.Start).layoutWeight(1)
        Button('设置').backgroundColor('#E2EFEB').fontColor('#147D73')
          .onClick(() => Nav.open('pages/Settings'))
      }.width('100%')
      TextInput({ placeholder: '搜索标题或内容', text: this.query })
        .height(46).onChange((value: string) => { this.query = value; })
      Button('＋ 新建备忘录').width('100%').height(46).backgroundColor('#147D73')
        .onClick(() => Nav.open('pages/Add'))
      if (this.error.length > 0) {
        Text(this.error).fontColor('#B83A3A')
      }
      if (NoteModel.filter(this.notes, this.query).length === 0) {
        Column({ space: 12 }) {
          Text(this.query.trim().length > 0 ? '没有找到匹配记录' : '还没有备忘录').fontSize(19)
          Text('点击上方按钮，记录第一件小事').fontSize(14).fontColor('#657572')
        }.layoutWeight(1).justifyContent(FlexAlign.Center).width('100%')
      } else {
        List({ space: 12 }) {
          ForEach(NoteModel.filter(this.notes, this.query), (note: Note) => {
            ListItem() {
              Column({ space: 9 }) {
                Row() {
                  Text(note.title).fontSize(19).fontWeight(FontWeight.Medium)
                    .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
                  Text(note.category).fontSize(12).fontColor('#147D73').margin({ left: 10 })
                }.width('100%')
                Text(note.content.length > 0 ? note.content : '暂无正文')
                  .fontSize(14).fontColor('#657572').maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(NoteModel.time(note.updatedAt)).fontSize(12).fontColor('#87938F')
              }.alignItems(HorizontalAlign.Start).padding(18).width('100%')
                .backgroundColor(Color.White).borderRadius(14)
            }.onClick(() => Nav.open('pages/Detail', note.id))
          }, (note: Note) => note.id)
        }.layoutWeight(1).width('100%')
      }
    }.padding(20).width('100%').height('100%').backgroundColor('#F4F8F7')
  }
}
