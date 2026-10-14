import { Nav } from '../common/Nav';

@Entry
@Component
struct Settings {
  logout(): void {
    AlertDialog.show({
      title: '退出登录', message: '退出后备忘录仍保存在本机。',
      primaryButton: { value: '取消', action: () => {} },
      secondaryButton: { value: '退出', action: () => { Nav.replace('pages/Index', true); } }
    });
  }

  build() {
    Scroll() {
      Column({ space: 22 }) {
        Row({ space: 12 }) {
          Button('返回').backgroundColor('#E2EFEB').fontColor('#147D73').onClick(() => Nav.back())
          Text('设置与关于').fontSize(23).fontWeight(FontWeight.Bold)
        }.width('100%')
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
          Text('数据保存在当前设备。卸载应用或清除应用数据会移除记录。演示登录不提供账号隔离或隐私保护，请勿保存敏感信息。')
            .fontSize(13).fontColor('#657572').lineHeight(22)
          Text('课程作品作者：王彦鑫').fontSize(13).fontColor('#657572')
        }.alignItems(HorizontalAlign.Start).padding(20).width('100%').backgroundColor(Color.White).borderRadius(14)
        Button('退出登录').width('100%').height(48).backgroundColor('#147D73').onClick(() => this.logout())
      }.padding(20).width('100%')
    }.width('100%').height('100%').backgroundColor('#F4F8F7')
  }
}
