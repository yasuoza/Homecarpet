require 'redcarpet'
require 'pygments'

class HomecarpetHTML < Redcarpet::Render::HTML
  def block_code(code, language)
    if Pygments::Lexer.find(language)
      Pygments.highlight(code, :lexer => language, :options => {:encoding => 'utf-8'})
    else
      Pygments.highlight(code, :options => {:encoding => 'utf-8'})
    end
  end
end

renderer = Redcarpet::Markdown.new(HomecarpetHTML,
                                   with_toc_data: true,
                                   no_intra_emphasis: true,
                                   tables: true,
                                   fenced_code_blocks: true,
                                   autolink: true,
                                   strikethrough: true,
                                   lax_html_blocks: true,
                                   space_after_headers: true,
                                   superscript: true
                                  )


HEADER = <<-HTML
<html>
<head>
  <link href="#{File.expand_path('../', __FILE__)}/css/code.css" media="screen" rel="stylesheet" type="text/css" />
  <link href="#{File.expand_path('../', __FILE__)}/css/code2.css" media="screen" rel="stylesheet" type="text/css" />
</head>
HTML

HTML = <<-HTML
  <body>
    <div id="markdown" style="width:700px;margin:auto;margin-top:50px;padding-bottom:50px">
       <div class="markdown-body">
          <%= BODY %>
        </div>
    </div>
  </body>
  </html>
HTML

data = File.read(ARGV[0])

open("#{File.expand_path('../', ARGV[0])}/#{File.basename(ARGV[0], ".*")}.html", 'w') do |dest|
  dest.write("#{HEADER}#{HTML.sub(/<%= BODY %>/, renderer.render(data))}")
end
