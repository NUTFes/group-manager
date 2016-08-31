class GroupInformationPagesController < ApplicationController
  def preview_pdf_page(template_name, output_file_name)
    respond_to do |format|
      format.pdf do
        # 詳細画面のHTMLを取得
        html = render_to_string template: "group_information_pages/#{template_name}"

        # PDFKitを作成
        pdf = PDFKit.new(html, encoding: "UTF-8")

        # 画面にPDFを表示する
        # to_pdfメソッドでPDFファイルに変換する
        # 他には、to_fileメソッドでPDFファイルを作成できる
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.to_pdf,
          filename:    "参加団体情報書類_#{output_file_name}.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def group_information_sheet
    this_year = FesYear.this_year

    @groups = Group.year(this_year).order(:group_category_id, :name)
    @fes_date = FesDate.where(fes_year_id: this_year)
    @rentables = RentableItem.year(this_year)
    @assignment_items = AssignRentalItem.year(this_year)

    preview_pdf_page('group_information_sheet', "参加団体情報管理表")
  end
end
