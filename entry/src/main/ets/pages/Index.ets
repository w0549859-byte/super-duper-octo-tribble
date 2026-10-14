import { Nav } from '../common/Nav';
import { NoteStore } from '../common/NoteStore';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State account: string = '';
  @State password: string = '';
  @State error: string = '';
  @State storageReady: boolean = false;

  aboutToAppear(): void {
    try {
      NoteStore.init((getContext(this) as common.UIAbilityContext).filesDir);
      this.storageReady = true;
    } catch { this.error = '存储初始化失败，请重新启动应用'; }
  }

  login(): void {
    if (!this.storageReady) { this.error = '存储初始化失败，请重新启动应用'; return; }
    if (this.account.trim() === 'admin' && this.password === '123456') {
      this.error = '';
      Nav.replace('pages/Home', true);
    } else {
      this.error = '请输入演示账号 admin，密码 123456';
    }
  }

  build() {
    Scroll() {
      Column({ space: 18 }) {
        Text('简记').fontSize(40).fontWeight(FontWeight.Bold).fontColor('#147D73')
        Text('记下日常的小事').fontSize(16).fontColor('#657572')
        Text('用户登录').fontSize(23).fontWeight(FontWeight.Medium).margin({ top: 32 })
        TextInput({ placeholder: '用户名', text: this.account })
          .height(50).maxLength(30).onChange((value: string) => { this.account = value; this.error = ''; })
        TextInput({ placeholder: '密码', text: this.password }).type(InputType.Password)
          .height(50).maxLength(30).onChange((value: string) => { this.password = value; this.error = ''; })
        Text(this.error).fontSize(14).fontColor('#B83A3A').width('100%')
        Button('登录').width('100%').height(48).backgroundColor('#147D73').onClick(() => this.login())
        Text('演示账号：admin  /  密码：123456').fontSize(13).fontColor('#657572')
        Text('本地课程演示，不连接账号服务器').fontSize(12).fontColor('#87938F')
      }.width('100%').padding(26).margin({ top: 48 })
    }.width('100%').height('100%').backgroundColor('#F4F8F7')
  }
}
