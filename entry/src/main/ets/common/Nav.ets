import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

export class NoteParams {
  id: string = '';
}

export class Nav {
  static open(url: string, id: string = ''): void {
    const params: NoteParams = new NoteParams();
    params.id = id;
    router.pushUrl({ url: url, params: params }).catch(() => {
      promptAction.showToast({ message: '无法打开页面，请检查 main_pages.json' });
    });
  }

  static replace(url: string, clear: boolean = false): void {
    router.replaceUrl({ url: url }).then(() => {
      if (clear) { router.clear(); }
    }).catch(() => {
      promptAction.showToast({ message: '页面跳转失败' });
    });
  }

  static id(): string {
    const params: NoteParams = router.getParams() as NoteParams;
    return params ? params.id || '' : '';
  }

  static back(): void { router.back(); }
}
