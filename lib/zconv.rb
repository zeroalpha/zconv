require "zconv/version"
require "yaml"

module Zconv
  class CharacterMapNotFound < ArgumentError ; end
  class NonNumericCCSIDE < ArgumentError ; end
  class UnknownRecordFormat < ArgumentError; end

  class Dataset
    attr_reader :content,:format,:ccsid,:bytemap
    def initialize(content, ccsid=37, format_options = {:recfm=>'FB', :lrecl=>80})
      if (ccsid = ccsid.to_s[/\d+/].to_i) == 0
        raise NonNumericCCSIDError, "The CCSID needs to be an Integer or a String containing the number"
      end
      @content = content
      @ccsid = ccsid
      @format = format_options
      @bytemap = load_map(@ccsid)
    end

    def convert
      case @format[:recfm]
      when 'FB'
        convert_fix_blocksize
      when 'VB'
        convert_varibale_blocksize
      else
        raise UnknownRecordFormat, "Unrecognized record formar: #{@format[:recfm]}"
      end
    end

    private
    def convert_fix_blocksize
      @content.bytes
          .map{ |b| @bytemap[b] }
          .each_slice(@format[:lrecl])
          .to_a.map{ |line| line.pack('U*') }
          .join("\n")
    end

    def load_map(ccsid)
      file_name = File.join(File.dirname(__FILE__),'..','maps',"ibm-%04i.yml"%[ccsid])
      begin
        YAML.load(File.read(file_name))
      rescue => e
        raise CharacterMapNotFound, "Failed to find the map file #{map_filename}" if e.is_a? Errno::ENOENT
        raise e
      end
    end
  end
end
  # class Converter
  #   private
  #   def convert_fb(input,record_length)
  #     #binding.pry
  #     input
  #       .bytes
  #       .map{|b| map[b]}
  #       .each_slice(format_options[:lrecl])
  #       .to_a.map{|line| line.pack('U*')}
  #       .join("\n")
  #   end

  #   def convert_vb(input)
  #     bytes = input.bytes
  #     ret = ""
  #     while bytes.size > 0
  #       #FIXME Add dualbyte lengths
  #       line_size = bytes[1] # Bytes 0..4 are the RDW. RDW[0..1] holds the record length and RDW[2..3] are OS reserved (and usually 0)
  #       line = bytes.slice!(0,line_size)
  #       line.slice!(0,4) # Discard the RDW
  #       ret << line.map{|b| @map[b]}.pack("U*") << "\n"
  #     end
  #     ret.chomp!
  #     ret
  #   end
  # end

