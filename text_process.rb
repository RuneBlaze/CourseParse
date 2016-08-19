require 'pdf-reader'

reader = PDF::Reader.new('assets/courses.pdf')
reader.pages.each do |page|
  t = page.text
  t.each_line do |l|
    do_print = true
    do_print = false if l.include?('Report ID')
    do_print = false if l.include?(' - Subject')
    do_print = false if l.include?('Semester Section Book')
    do_print = false if l.include?('Run Time')
    puts l if do_print
  end
end
