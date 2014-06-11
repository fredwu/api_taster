module ApiTaster
  class FormBuilder < AbstractController::Base
    include AbstractController::Rendering
    include ActionView::Layouts
    include ActionView::Context
    include ActionView::Helpers::CaptureHelper

    self.view_paths = ApiTaster::Engine.root.join('app/views')

    def initialize(params)
      flush_output_buffer
      @_buffer = ''
      add_to_buffer(params)
    end

    def html
      "<legend class=\"hero-legend\"></legend>#{@_buffer}"
    end

    private

    def add_to_buffer(params, parent_labels = [])
      params.each do |label, value|
        if parent_labels.present?
          label = "[#{label}]"
        end

        new_parent_labels = parent_labels.clone << label

        case value
        when Hash
          add_legend_to_buffer(parent_labels, label)
          add_to_buffer(value, new_parent_labels)
        when Array
          value.each do |v|
            case v
            when Hash
              add_legend_to_buffer(parent_labels, label)
              add_to_buffer(v, parent_labels.clone << "#{label}[]")
            else
              add_element_to_buffer(parent_labels, "#{label}[]", v)
            end
          end
        else
          add_element_to_buffer(parent_labels, label, value)
        end
      end
    end

    def add_element_to_buffer(parent_labels, label, value)
      @_buffer += render(
        :template => 'api_taster/routes/_param_form_element',
        :locals  => {
          :label      => "#{print_labels(parent_labels)}#{label}",
          :label_text => label,
          :value      => value
        }
      )
    end

    def add_legend_to_buffer(parent_labels, label)
      @_buffer += render(
        :template => 'api_taster/routes/_param_form_legend',
        :locals  => { :label => print_labels(parent_labels.clone << label) }
      )
    end

    def print_labels(parent_labels)
      "#{parent_labels * ''}"
    end
  end
end
