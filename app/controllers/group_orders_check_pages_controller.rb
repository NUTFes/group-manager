class GroupOrdersCheckPagesController < ApplicationController

  def preview_pdf_page(template_name, output_file_name)
    respond_to do |format|
      format.pdf do
        # 詳細画面のHTMLを取得
        html = render_to_string template: "group_orders_check_pages/#{template_name}"

        # PDFKitを作成
        pdf = PDFKit.new(html, encoding: "UTF-8")

        # 画面にPDFを表示する
        # to_pdfメソッドでPDFファイルに変換する
        # 他には、to_fileメソッドでPDFファイルを作成できる
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.to_pdf,
          filename:    "物品・電力割当確認書類_#{output_file_name}.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def for_groups
    this_year = FesYear.this_year
    @groups = Group.where(fes_year:this_year.id)
    # @power_orders = (this_year.id)
    # @place_orders = FoodProduct.cooking_products(this_year.id)
    # @fes_dates = this_year.fes_date.all()

    preview_pdf_page("for_groups", "参加団体向け")
  end

  def for_maintainers
    this_year = FesYear.this_year
    @groups = Group.where(fes_year:this_year.id)

    preview_pdf_page("for_maintainers", "電気担当者向け")
  end

end
