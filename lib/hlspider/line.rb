module HLSpider
  module Line
    def strip_query_params(line)
      line.sub(/[?].{1,}/, '')
    end
      
    def get_filename(line)
     line.slice(/\w{1,}(.ts)/)
    end

    def strip_all_but_file(line)
     line.slice(/\w{1,}(.ts)/)
    end
  
    def strip_file(line)
      line.sub(/\/\w{1,}(.)\w{1,}$/, "")
    end  
  
    def relative_path?(line)
     true if !line.match('http://')
    end

    def absolute_path?(line)
     true if line.match('http://')
    end
  end
end