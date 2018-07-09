module ActiveAdmin
  class CSVBuilder
    def encode(content, options)
      if options[:encoding]
        content.to_s.sjisable.encode("Windows-31J","UTF-8",invalid: :replace, undef: :replace).encode("UTF-8", "Windows-31J").encode("Windows-31J","UTF-8")
      else
        content
      end
    end
  end
end
