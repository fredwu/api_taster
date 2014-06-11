require 'redcarpet'

module ApiTaster
  module ApplicationHelper
    def markdown(text)
      markdown_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown_renderer.render(text).html_safe
    end

    def headers_js_callback
      render partial: "api_taster/routes/headers.js", locals: {headers: ApiTaster.global_headers}
    end
  end
end
