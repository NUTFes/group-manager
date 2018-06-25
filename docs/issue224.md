# issue224

# フィルタのデフォルトの値を設定する方法

参考 https://stackoverflow.com/questions/13807625/activeadmin-filter-with-default-value

`fes_year` のフィルタのデフォルト値を今年にする場合

```ruby
  controller do
    before_filter only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? # ユーザによってすでにフィルタが設定されている場合は無効
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end
```

ただし，いずれかのフィルタが設定される・変更されていなければ，からなず今年に設定されるため，すべてのレコードを表示するために`fes_year`を任意に変えても，1ページ目から別のページに切り替えると勝手に今年に設定される．

この問題を回避するためには`params[:page].blank?`をチェックしてやればよい．ここにはページ番号が入るため，ユーザの入力有無を取得できる．

```ruby
  controller do
    before_filter only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank? # ユーザによってすでにフィルタが設定されている場合は無効
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end
```

