

# first let up split these into chunks
@chunks = []
@buf = []
File.foreach('assets/processed_courses.txt').with_index do |l, i|
  def line_is_sep?(str); str.include?('__'); end

  def flushbuf!; @chunks << @buf.join; @buf = []; end
  def clearbuf!; @buf = []; end

  # if it is all whitespaces & also no buffer
  if l.delete(" ").empty? && @buf.empty?
  else
    if line_is_sep?(l)
      unless @buf.empty?
        flushbuf!
      else
        clearbuf!
      end
    else
      @buf << l unless @buf.empty? && l == "\n"
    end
  end
end

class Array
  def rest
    return self[1..(size - 1)]
  end
end

# strToCourse :: String -> Course
def str_to_course str
  lines = str.split("\n")
  subject, catalog_nbr, section, class_nbr, title, component, units, topics, session = *lines[0].split(/[\s]{2,}/).rest
  ln = lines.find_index {|it| it.include? "Bldg: "}
  bldg, room, days, time = *lines[ln].split(/[\s]{2,}/).rest.map{ |it|
    r = it.split(':')[1]
    if r
      r.chars.rest.join
    else
      r
    end
  }

  ln = lines.find_index {|it| it.include? "Rank: "}
  rank, load, instructor = *lines[ln].split(/[\s]{2,}/).rest.map{ |it|
    r = it.split(':')[1]
    if r
      r.chars.rest.join
    else
      r
    end
  }
  r_attr = /([A-Z]+)/
  ln = lines.find_index {|it| it.include? "Attributes: "}
  attrs = nil
  if ln.nil?
  else
    attrs = r_attr.match(lines[ln].split(':').last.chars.rest.join).to_a.rest
  end
  enrl_cap = gen_field_lambda('Class Enrl Cap')[str]
  enrl_tot = gen_field_lambda('Class Enrl Tot')[str]
  wait_cap = gen_field_lambda('Class Wait Cap')[str]
  wait_tot = gen_field_lambda('Class Wait Tot')[str]

  r_prereq = /PREREQUISITES:[\s]{0,}([\w\-\d\.\;\, ]+)[\s]{2,}/
  r_course = /([A-Z]+ \d+)/

  prereqs_ = r_prereq.match(str)
  prereqs = prereqs_ ? prereqs_[1] : nil

  return {
    subject: subject,
    catalog_nbr: catalog_nbr.to_i,
    section: section.to_i,
    class_nbr: class_nbr.to_i,
    title: title,
    component: component,
    units: units.to_i,
    bldg: bldg,
    room: room,
    days: days,
    time: time,
    instructor: instructor,
    load: load,
    rank: rank,
    attributes: attrs,
    enrl_cap: enrl_cap,
    enrl_tot: enrl_tot,
    wait_cap: wait_cap,
    wait_tot: wait_tot,
    prereqs: prereqs
  }
end


# genFieldRegex :: String -> Regex
def gen_field_regex str
  Regexp.new str + ':(\d+)'
end

# genFieldLambda :: String -> (String -> Maybe[Number])
def gen_field_lambda str
  r = gen_field_regex(str)
  return lambda do |str|
    m = r.match str
    if m
      m[1].to_i
    else
      m
    end
  end
end

# FIXME: ugly naming
def gen_string_lambda str
  r = Regexp.new str + ':()'
end

require 'json'

puts @chunks.map{|it| str_to_course(it)}.to_json
