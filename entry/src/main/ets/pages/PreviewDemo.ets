import { Note, NoteModel } from '../common/NoteModel';

// 仅用于 DevEco Studio Previewer 的课堂交互演示。
// 不调用 router / 文件系统；原有六个真正的鸿蒙应用页面保持不变。
@Entry
@Component
struct PreviewDemo {
  // 0 登录；1 列表；2 新建；3 详情；4 编辑；5 设置
  @State private screen: number = 0;
  @State private account: string = 'admin';
  @State private password: string = '';
  @State private query: string = '';
  @State private notes: Note[] = [];
  @State private selectedId: string = '';
  @State private selectedNote: Note = new Note();
  @State private titleText: string = '';
  @State private contentText: string = '';
  @State private category: string = '生活';
  @State private message: string = '';
  @State private askDelete: boolean = false;

  aboutToAppear(): void {
    // 预先提供一条示例记录，进入列表后无需保存也能打开「详情 / 编辑」。
    if (this.notes.length === 0) {
      this.notes = NoteModel.save([], '', '示例：课程作业', '这是预览器中的示例备忘录。可以新建、查看、编辑、搜索和删除。', '学习', Date.now());
    }
  }

  login(): void {
    if (this.account.trim() === 'admin' && this.password === '123456') {
      this.message = '';
      this.screen = 1;
    } else {
      this.message = '演示账号 admin，密码 123456';
    }
  }

  startAdd(): void {
    this.titleText = '';
    this.contentText = '';
    this.category = '生活';
    this.message = '';
    this.screen = 2;
  }

  openDetail(note: Note): void {
    this.selectedId = note.id;
    this.selectedNote = note;
    this.askDelete = false;
    this.message = '';
    this.screen = 3;
  }

  startEdit(): void {
    this.titleText = this.selectedNote.title;
    this.contentText = this.selectedNote.content;
    this.category = this.selectedNote.category;
    this.message = '';
    this.screen = 4;
  }

  saveNote(isEdit: boolean): void {
    const problem: string = NoteModel.validate(this.titleText, this.contentText);
    if (problem.length > 0) {
      this.message = problem;
      return;
    }
    try {
      const noteId: string = isEdit ? this.selectedId : '';
      this.notes = NoteModel.save(this.notes, noteId,
        this.titleText, this.contentText, this.category, Date.now());
      if (isEdit) {
        this.selectedNote = this.notes[0];
        this.screen = 3;
      } else {
        this.screen = 1;
      }
      this.message = '';
      this.query = '';
    } catch (e) {
      this.message = '保存失败，请重试';
    }
  }

  deleteNote(): void {
    this.notes = NoteModel.remove(this.notes, this.selectedId);
    this.askDelete = false;
    this.message = '';
    this.screen = 1;
  }

  @Builder
  header(label: string, target: number) {
    Row({ space: 12 }) {
      Button('返回')
        .fontSize(14).backgroundColor('#E2EFEB').fontColor('#147D73')
        .onClick(() => {
          this.message = '';
          this.askDelete = false;
          this.screen = target;
        })
      Text(label).fontSize(23).fontWeight(FontWeight.Bold).fontColor('#173E38')
    }.width('100%')
  }

  @Builder
  loginView() {
    Scroll() {
      Column({ space: 18 }) {
        Text('简记').fontSize(40).fontWeight(FontWeight.Bold).fontColor('#147D73')
        Text('记下日常的小事').fontSize(16).fontColor('#657572')
        Text('用户登录').fontSize(23).fontWeight(FontWeight.Medium).margin({ top: 28 })
        TextInput({ placeholder: '用户名', text: this.account })
          .height(50).onChange((value: string) => { this.account = value; this.message = ''; })
        TextInput({ placeholder: '密码', text: this.password }).type(InputType.Password)
          .height(50).onChange((value: string) => { this.password = value; this.message = ''; })
        if (this.message.length > 0) {
          Text(this.message).fontSize(14).fontColor('#B83A3A').width('100%')
        }
        Button('登录').width('100%').height(48).backgroundColor('#147D73')
          .onClick(() => this.login())
        Text('账号 admin / 密码 123456').fontSize(13).fontColor('#657572')
      }.padding(26).width('100%').margin({ top: 45 })
    }.layoutWeight(1).width('100%')
  }

  @Builder
  homeView() {
    Column({ space: 16 }) {
      Row() {
        Column({ space: 4 }) {
          Text('我的备忘录').fontSize(27).fontWeight(FontWeight.Bold).fontColor('#173E38')
          Text('共 ' + this.notes.length + ' 条记录').fontSize(13).fontColor('#657572')
        }.alignItems(HorizontalAlign.Start).layoutWeight(1)
        Button('设置').backgroundColor('#E2EFEB').fontColor('#147D73')
          .onClick(() => { this.message = ''; this.screen = 5; })
      }.width('100%')
      TextInput({ placeholder: '搜索标题或内容', text: this.query }).height(46)
        .onChange((value: string) => { this.query = value; })
      Button('＋ 新建备忘录').width('100%').height(46).backgroundColor('#147D73')
        .onClick(() => this.startAdd())
      if (NoteModel.filter(this.notes, this.query).length === 0) {
        Column({ space: 12 }) {
          Text(this.query.length > 0 ? '没有找到匹配记录' : '还没有备忘录')
            .fontSize(19).fontColor('#173E38')
          Text('点击上方按钮新建记录').fontSize(14).fontColor('#657572')
        }.layoutWeight(1).justifyContent(FlexAlign.Center).width('100%')
      } else {
        List({ space: 12 }) {
          ForEach(NoteModel.filter(this.notes, this.query), (note: Note) => {
            ListItem() {
              Column({ space: 9 }) {
                Row() {
                  Text(note.title).fontSize(19).fontWeight(FontWeight.Medium)
                    .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
                  Text(note.category).fontSize(12).fontColor('#147D73')
                }.width('100%')
                Text(note.content.length > 0 ? note.content : '暂无正文')
                  .fontSize(14).fontColor('#657572').maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(NoteModel.time(note.updatedAt)).fontSize(12).fontColor('#87938F')
              }.alignItems(HorizontalAlign.Start).padding(18).width('100%')
                .backgroundColor(Color.White).borderRadius(14)
            }.onClick(() => this.openDetail(note))
          }, (note: Note) => note.id)
        }.layoutWeight(1).width('100%')
      }
    }.padding(20).layoutWeight(1).width('100%')
  }

  @Builder
  formView(isEdit: boolean) {
    Scroll() {
      Column({ space: 18 }) {
        this.header(isEdit ? '编辑备忘录' : '新建备忘录', isEdit ? 3 : 1)
        Text('标题').fontSize(15).fontColor('#657572').width('100%')
        TextInput({ placeholder: '写一个简短的标题（最多40字）', text: this.titleText })
          .maxLength(40).height(50).onChange((value: string) => {
            this.titleText = value;
            this.message = '';
          })
        Text('分类').fontSize(15).fontColor('#657572').width('100%')
        Row({ space: 8 }) {
          ForEach(NoteModel.categories, (item: string) => {
            Button(item).layoutWeight(1)
              .backgroundColor(this.category === item ? '#147D73' : '#E2EFEB')
              .fontColor(this.category === item ? '#FFFFFF' : '#147D73')
              .onClick(() => { this.category = item; })
          }, (item: string) => item)
        }.width('100%')
        Text('内容').fontSize(15).fontColor('#657572').width('100%')
        TextArea({ placeholder: '想记下什么？', text: this.contentText }).height(220)
          .maxLength(2000).onChange((value: string) => { this.contentText = value; })
        Text(this.contentText.length + ' / 2000').fontSize(12)
          .fontColor('#87938F').width('100%').textAlign(TextAlign.End)
        if (this.message.length > 0) {
          Text(this.message).fontSize(14).fontColor('#B83A3A').width('100%')
        }
        Button('保存').width('100%').height(48).backgroundColor('#147D73')
          .onClick(() => this.saveNote(isEdit))
      }.padding(20).width('100%')
    }.layoutWeight(1).width('100%')
  }

  @Builder
  detailView() {
    Column({ space: 18 }) {
      this.header('备忘录详情', 1)
      Scroll() {
        Column({ space: 16 }) {
          Text(this.selectedNote.title).fontSize(26).fontWeight(FontWeight.Bold).fontColor('#173E38')
          Text(this.selectedNote.category).fontSize(14).fontColor('#147D73')
          Text('创建：' + NoteModel.time(this.selectedNote.createdAt)).fontSize(12).fontColor('#87938F')
          Text('修改：' + NoteModel.time(this.selectedNote.updatedAt)).fontSize(12).fontColor('#87938F')
          Divider()
          Text(this.selectedNote.content.length > 0 ? this.selectedNote.content : '暂无正文')
            .fontSize(17).lineHeight(28).fontColor('#304B45').width('100%')
        }.alignItems(HorizontalAlign.Start).padding(18).width('100%')
      }.layoutWeight(1).width('100%').backgroundColor(Color.White).borderRadius(14)
      if (this.askDelete) {
        Column({ space: 10 }) {
          Text('确定删除这条备忘录吗？').fontColor('#B83A3A')
          Row({ space: 10 }) {
            Button('取消').layoutWeight(1).backgroundColor('#E2EFEB').fontColor('#147D73')
              .onClick(() => { this.askDelete = false; })
            Button('确认删除').layoutWeight(1).backgroundColor('#B83A3A')
              .onClick(() => this.deleteNote())
          }
        }.width('100%')
      } else {
        Row({ space: 14 }) {
          Button('编辑').layoutWeight(1).height(46).backgroundColor('#147D73')
            .onClick(() => this.startEdit())
          Button('删除').layoutWeight(1).height(46)
            .backgroundColor('#F9E6E3').fontColor('#B83A3A')
            .onClick(() => { this.askDelete = true; })
        }.width('100%')
      }
    }.padding(20).layoutWeight(1).width('100%')
  }

  @Builder
  settingsView() {
    Scroll() {
      Column({ space: 22 }) {
        this.header('设置与关于', 1)
        Column({ space: 12 }) {
          Text('简记').fontSize(34).fontWeight(FontWeight.Bold).fontColor('#147D73')
          Text('日常备忘录 · 1.0').fontSize(16)
          Text('记录生活、学习和工作中的小事。').fontColor('#657572').fontSize(14)
        }.padding(24).width('100%').backgroundColor(Color.White).borderRadius(14)
        Column({ space: 16 }) {
          Text('使用方法').fontSize(19).fontWeight(FontWeight.Medium)
          Text('1. 在首页新建备忘录。\n2. 填写标题、分类和内容后保存。\n3. 点击记录查看详情、编辑或删除。\n4. 在首页搜索标题或内容。')
            .fontSize(15).lineHeight(28)
          Divider()
          Text('本页面使用内存演示数据，关闭或刷新预览器后会重置。')
            .fontSize(13).fontColor('#657572')
          Text('课程作品作者：王彦鑫').fontSize(13).fontColor('#657572')
        }.alignItems(HorizontalAlign.Start).padding(20).width('100%')
          .backgroundColor(Color.White).borderRadius(14)
        Button('退出登录').width('100%').height(48).backgroundColor('#147D73')
          .onClick(() => { this.password = ''; this.message = ''; this.screen = 0; })
      }.padding(20).width('100%')
    }.layoutWeight(1).width('100%')
  }

  build() {
    Column({ space: 0 }) {
      Row() {
        Text('ARKUI 预览演示模式').fontSize(12).fontWeight(FontWeight.Medium).fontColor('#147D73')
        Blank()
        Text('仅内存数据').fontSize(11).fontColor('#657572')
      }.padding({ left: 15, right: 15, top: 9, bottom: 9 })
        .width('100%').backgroundColor('#DCEDE8')
      if (this.screen === 0) {
        this.loginView()
      } else if (this.screen === 1) {
        this.homeView()
      } else if (this.screen === 2) {
        this.formView(false)
      } else if (this.screen === 3) {
        this.detailView()
      } else if (this.screen === 4) {
        this.formView(true)
      } else {
        this.settingsView()
      }
    }.width('100%').height('100%').backgroundColor('#F4F8F7')
  }
}
