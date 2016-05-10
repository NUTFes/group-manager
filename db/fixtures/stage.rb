Stage.seed( :id,
  # 晴天時に使用可能
  { id: 1 , name_ja: 'メインステージ'         , is_sunny: true , enable:true  } ,
  { id: 2 , name_ja: 'サブステージ'           , is_sunny: true , enable:true  } ,
  { id: 3 , name_ja: '体育館'                 , is_sunny: true , enable:true  } ,
  { id: 4 , name_ja: 'マルチメディアセンター' , is_sunny: true , enable:true  } ,
  # 雨天時に使用可能
  { id: 5 , name_ja: '体育館'                 , is_sunny: false, enable:true  } ,
  { id: 6 , name_ja: 'マルチメディアセンター' , is_sunny: false, enable:true  } ,
  { id: 7 , name_ja: '武道館'                 , is_sunny: false, enable:true  } ,
  # 晴天時に使用可能
  { id: 8 , name_ja: '武道館'                 , is_sunny: true , enable:true  } ,
)
