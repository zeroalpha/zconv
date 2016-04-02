$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'zconv'
module TestData
  #TestData::TARGET
  lorem_ipsum = %q{
Lorem ipsum dolor sit amet, mei ad exerci possim omnium, id vis amet interpretaris. Vel eius aeque accusata no. Eu dico consulatu vim, scripta feugiat admodum mel ne, ius te enim exerci delenit. Prima omittam eum te, probo ubique veritus in cum. Et hinc fuisset volutpat quo.

Mundi corpora an vim. Erant vitae sit ut, mazim epicurei ut eum, ex putant feugait reprimique nec. Inani feugait repudiare at sit, ut mundi ridens vis. Vim ornatus mandamus petentium et, cu eos agam necessitatibus. Quo eu atqui putent fastidii.
}

  targets = {}
  targets[:fb80] = lorem_ipsum.lines.map do |line|
    line.chomp!
    ret = line.slice!(0,80) << "\n"
    ret << line.slice!(0,80) << "\n" until line.empty?
    ret
  end.join("\n")

  const_set 'TARGET', targets

  #TestData::SOURCE
  data_dir = File.join File.dirname(__FILE__),'data'
  sources = {
    fb80: File.binread(File.join(data_dir,'EBCDIC.TESTDATA.FB80'))
  }

  const_set 'SOURCE', sources

end

require 'minitest/autorun'