class Parser

	attr_accessor :file ,:invoice_num, :str , :lines , :str_count

  DIGITS = { "010202212" => 0 , "000002002" => 1 , "010012210" => 2 , "010012012" => 3, "000212002" => 4, "010210012" => 5,
  "010210212" => 6 , "010002002" => 7, "010212212" => 8, "010212012" => 9 }

  def initialize(lines)
    @lines = lines
    @invoice_num = ""
    @str_count = 0
    @str = ""
  end

 def dig(x,y)
    lines.take(3).each do |l|  #last line contains one next line character   
          l.chars[x,y].each do |ch|
            if ch == " "
              str << "0"
            elsif ch == "_" 
              str << "1"
            else ch == "|"
              str << "2"
            end  
          end 
    end #loop end   
    self.str_count = str_count + 3 
    if DIGITS[str] 
        invoice_num << DIGITS[str].to_s
    else
      invoice_num << "?" 
    end
  
    if str_count < 27 #27 characters in one line 
      @str = ""   #empty string for next digit of invoice
      dig(x+3,3)  
    end 
  end #dig end

  def self.parse(di)
    uploaded_file = di.raw.current_path
    processed_file =  Rails.root.join('tmp', "processed_#{di.raw_identifier}")
    count = IO.readlines(di.raw.current_path).size  
    puts "total lines is #{count}"
    invoice_count = count/4
    puts "total number of invoices are: #{invoice_count}" 

    File.open(uploaded_file ,'r') do |f|
        invoice_count.times do   
          lines = 4.times.map { f.gets }
          invoice = new(lines)
          invoice.dig(0,3)
     #write each invoice number in processed file
          File.open(processed_file, 'a') do |f|         
            if invoice.invoice_num.include?("?")
              f.write("#{invoice.invoice_num} ------- ILLEGAL" )
            else
              f.write(invoice.invoice_num)
            end
            f.write("\n")
          end
        end
    end

    File.open(processed_file) do |f|
      di.processed = f
      di.save!
    end

  end

end