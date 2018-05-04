class RepresentativeContactPagesController < ApplicationController
  def preview_pdf_page(template_name, output_file_name)
    respond_to do |format|
      format.pdf do
        html = render_to_string template: "representative_contact_pages/#{template_name}"

        pdf = PDFKit.new(html, encoding: "UTF-8")
        
        send_data pdf.to_pdf,
          filename:    "参加団体連絡先_#{output_file_name}.pdf",
          type:        "application/pdf",
          disposition: "inline"
       end
    end
  end

  def representative_contact_sheet
    this_year = FesYear.this_year

    @groups = Group.year(this_year)
    
    preview_pdf_page('representative_contact_sheet', "代表者連絡先一覧")
  end
end
