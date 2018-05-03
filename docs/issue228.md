#issue228
***
ステージエリアの統一

##変更点
db/fixtures/place.rb---
ステージエリアをメインステージエリアに変更
```diff
{ id: 1 , name_ja: '事務棟エリア'    } ,
{ id: 2 , name_ja: '図書館エリア'    } ,
{ id: 3 , name_ja: '福利棟エリア'    } ,
-  { id: 4 , name_ja: 'ステージエリア'  } ,
+  { id: 4 , name_ja: 'メインステージエリア'  } ,
{ id: 5 , name_ja: '体育館エリア'    } ,
{ id: 6  , name_ja: 'セコムホール'   } ,
{ id: 7  , name_ja: '電気棟204'      } ,
```
