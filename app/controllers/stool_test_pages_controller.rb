class StoolTestPagesController < ApplicationController
  def preview_pdf_page(template_name, output_file_name)
    respond_to do |format|
      format.pdf do
        # 詳細画面のHTMLを取得
        html = render_to_string template: "stool_test_pages/#{template_name}"

        # PDFKitを作成
        pdf = PDFKit.new(html, encoding: "UTF-8")

        # 画面にPDFを表示する
        # to_pdfメソッドでPDFファイルに変換する
        # 他には、to_fileメソッドでPDFファイルを作成できる
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.to_pdf,
          filename:    "検便用書類_#{output_file_name}.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def check_sheet
    this_year = FesYear.where(fes_year: Time.now.year).first()

    @employees = Employee.joins(
      :food_products).where(
        groups: {fes_year_id: 1}).where(
          food_products: {is_cooking: true}).uniq

    # employees_uniq = @employees.sort_by{|e| [e.group.id, e.student_id]}.uniq{|e| e.student_id}
    # employees_dup = @employees.reject{|e| @employees_uniq.any?{|eu| eu.id == e.id}}

    preview_pdf_page("check_sheet", "総務確認用資料")
  end
end