# TODO: Adjust the CV to the space automatically (for example, section jump to next page)
gem 'deep_merge', '~>1.2' # gem install deep_merge if not found

require 'deep_merge'
require 'yaml'

# Scape all characters that LaTeX doesn't like
def scape(string)
  string && string.to_s.gsub(/[%_&$#{}~^]/) { |c| "\\#{c}" }
end

def projects_to_s(projects_array)
  projects_array.map{ |project| "\\href{#{ url_for_project(project.to_a[1]) }}{#{ project['title'] }}" }.join(', ')
end

def url_for_project(project_url_hash)
  url_type = project_url_hash[0]
  project_for_url = project_url_hash[1]
  case url_type
  when 'commits-url'
    "https://github.com/#{project_for_url}//commits?author=Ana06"
  when 'prs-url'
    "https://github.com/#{project_for_url}/pulls?utf8=%E2%9C%93&q=is%3Apr+author%3AAna06+"
  when 'project-url'
    "https://github.com/#{project_for_url}"
  else
    project_for_url
  end
end

def sort_by_date(array)
  array.sort {|a,b| (b['date'] || '0') <=> (a['date'] || '0') }
end

def add_links(text, activities)
  text_with_links = link_urls(text)
  activities.each { |activity, activity_url| link_activity(text_with_links, activity, activity_url) }
  text_with_links
end

def link_urls(text)
  text.gsub(/http(s|):\/\/[^\)\s]+/) { |url| "\\url{#{url}}" }
end

def link_activity(text, activity, activity_url)
  text.gsub!(activity,"\\href{#{ activity_url}}{#{activity}}") if activity_url
end

def file_content(contact, cv)
file_content = <<-'HEADING'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This CV is based on the template from Trey Hunner (http://www.treyhunner.com),
% downloaded from http://www.LaTeXTemplates.com and licensed under Creative
% Commons CC BY 4.0
%
% Important note:
% The resume.cls file is required to be in the same directory as the .tex file.
% It provides the resume style used for structuring the document.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\documentclass{cv} % Use cv.cls style

\usepackage[left=0.54in,top=0.59in,right=0.50in,bottom=0.4in]{geometry} % Document margins
\usepackage[spanish,activeacute]{babel}
\usepackage[utf8]{inputenc}
\usepackage[hidelinks]{hyperref}
\usepackage{color}
\definecolor{Blue}{RGB}{0,11,169}
\usepackage{fontawesome}
\usepackage{enumitem}
\tolerance=1
\emergencystretch=\maxdimen
\hyphenpenalty=10000
\hbadness=10000

\renewcommand{\familydefault}{\rmdefault}
\renewcommand*\rmdefault{cmr}

HEADING

email = scape(contact['email'])
website = scape(contact['website'])
twitter = scape(contact['twitter_url'])
github = scape(contact['github_url'])
stackoverflow = scape(contact['stackoverflow_url'])
stackoverflow_short = scape(contact['stackoverflow_url_short'] || contact['stackoverflow_url'])
linkedin = scape(contact['linkedin_url'])
linkedin_short = scape(contact['linkedin_url_short'] || contact['linkedin_url'])
opensuse_wiki = scape(contact['opensuse_wiki_url'])
phone = scape(contact['phone'])

file_content += <<CONTACT_DATA
\\name{\\href{#{ website }}{Ana Maria Martinez Gomez}}

\\headingLine{
  \\href{#{ website }}{\\faUser $ $ #{ website }} \\
  \\href{#{ linkedin }}{\\faLinkedinSquare $ $ #{ linkedin_short }}
}
\\headingLine{
  \\href{#{ github }}{\\faGithub $ $ #{ github }} \\
  \\href{#{ stackoverflow }}{\\faStackOverflow $ $ #{ stackoverflow_short }}
}
CONTACT_DATA

file_content += if phone
<<PHONE
\\headingLine{
  \\href{#{ email }}{\\faEnvelope $ $ #{ email }} \\
  \\href{#{ twitter }}{\\faTwitter $ $ #{ twitter }} \\
  \\faPhoneSquare $ $ #{ phone }
}

PHONE
else
<<NO_PHONE
\\headingLine{
  \\href{#{ email }}{\\faEnvelope $ $ #{ email }} \\
  \\href{#{ twitter }}{\\faTwitter $ $ #{ twitter }}
}

NO_PHONE
end

file_content += "\n\\begin{document}\n\n"


cv.each do |section_title, section_elements|
  next if ['other_talks', 'Certificates', 'languages'].include? section_title # This is not important in the resume
  title = scape(section_title.gsub('_', ' '))
  file_content += <<SECTION_TITLE
%----------------------------------------------------------------------------------------
%  #{ title } section
%----------------------------------------------------------------------------------------

\\begin{rSection}{#{ title }}

SECTION_TITLE

  case section_title
  when 'personal'
    file_content << "#{ scape(add_links(section_elements['text'], section_elements['activities'])) }\n"
  when 'contributions'
    projects_string = projects_to_s(section_elements['projects'])

    file_content += "\\rSubsectionShort{Contributed to various Open Source projects including:}{#{ scape(projects_string) }}\n\n"

    section_elements['general'].each { |contribution| file_content += "\\rSubsectionShort{#{ scape(contribution) }}{}\n\n" }
  when 'languages'
    section_elements.each_with_index do |language, index|
      file_content << "\\textbf{#{ scape(language['name']) }} (#{ scape(language['level']) })"
      file_content << (index == section_elements.size - 1 ? "\n" : ', ')
    end
  when 'latest_invited_talks'
    featured_elements = section_elements.select{ |element| element['featured'] && element['date'] <= Time.now.strftime("%Y-%m-%d") }
    sort_by_date(featured_elements).each do |element|
      file_content += "\\rSubsectionTalk{#{ scape(element['title']) }}{#{ scape(element['short-url'] || element['url']) }}{#{ scape(element['conference']) }}{#{ scape(element['location']) }}{#{ scape(element['attendees']) }}\n\n"
    end
  else
    featured_elements = section_elements.select{ |element| element['featured'] }
    sort_by_date(featured_elements).each do |element|
      details = element['details'] || []
      file_content += "\\rSubsection{#{ scape(element['title']) }}{#{ scape(element['term']) }}{#{ scape(element['company']) }}{#{ scape(element['location']) }}{#{ scape(element['score']) }}{#{ scape(details[0]) }}{#{ scape(details[1]) }}{#{ scape(details[2]) }}\n\n"
    end
  end

  file_content += "\\end{rSection}\n\n"
end

file_content += '\end{document}'
end

def generate_tex_pdf(file_name, file_content)
  IO.write("#{ file_name }.tex", file_content)
  puts "#{ file_name}.tex sucessfully generated!"

  if system("pdflatex #{ file_name }.tex > /dev/null")
    puts "#{ file_name }.pdf sucessfully generated!"
  else
    puts "ERROR: pdf was not generated. Check #{ file_name }.log for details"
  end
end

file_name = "resume-AnaMariaMartinez"
file_name2 = "ana" # compatibility reasons, they are the same

puts "CV is being generated..."

cv = YAML.load_file('../_data/cv.yml')
cv_private = YAML.load_file('../_data/cv_private.yml')
contact = YAML.load_file('../_data/contact.yml')
contact_private = YAML.load_file('../_data/contact_private.yml')

file_content = file_content(contact, cv)
generate_tex_pdf(file_name, file_content)

file_content_private = file_content(contact.deep_merge(contact_private), cv.deep_merge(cv_private))
generate_tex_pdf("#{file_name}_private", file_content_private)

system("cp #{ file_name }.pdf ../")
system("cp #{ file_name }.pdf ../#{ file_name2 }.pdf")

