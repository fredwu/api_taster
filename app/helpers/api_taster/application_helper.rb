require 'redcarpet'

module ApiTaster
  module ApplicationHelper
    def markdown(text)
      markdown_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown_renderer.render(text).html_safe
    end
  end
end
