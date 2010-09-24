mailer_views = []

namespace :mailer do
  namespace :views do
    FileList['app/views/application_mailer/_*.md.erb'].each do |src|
      partial_name = File.basename(src)
      partial_name.slice!(0)
      partial_name.chomp!(".erb")
      partial_path = File.join( File.dirname(src), partial_name )
      dest_text = partial_path.chomp(".md").concat(".text.plain.erb")
      mailer_views << dest_text
      file dest_text => src do
        open(dest_text, 'w') do |f|
          f.puts "<%= render :partial => \"#{partial_name}\" %>"
        end
        puts "Created #{dest_text}"
      end
      dest_html = partial_path.chomp(".md").concat(".text.html.erb")
      mailer_views << dest_html
      file dest_html => dest_text do
        open(dest_html, 'w') do |f|
          f.puts "<% content = render :partial => \"#{partial_name}\" %>"
          f.puts "<%= Maruku.new(content).to_html_document %>"
        end
        puts "Created #{dest_html}"
      end
    end
  end

  desc "Build the HTML views for mailer using markdown"
  task :views => mailer_views

  desc "Clean generated HTML views"
  task :clean do
    rm mailer_views, :force => true, :verbose => true
  end
end
