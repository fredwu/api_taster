module ApiTaster
  class FormBuilder < AbstractController::Base
    include AbstractController::Rendering
    include ActionView::Context
    include ActionView::Helpers::CaptureHelper

    self.view_paths = ApiTaster::Engine.root.join('app/views')

    def initialize(params)
      flush_output_buffer
      @_buffer = ''
      add_to_buffer(params)
    end

    def html
      @_buffer
    end

    private

    def add_to_buffer(params, parent_labels = [])
      params.each do |label, value|
        if value.is_a?(Hash)
          parent_labels << label

          @_buffer += render(
            :partial => 'api_taster/routes/param_form_legend',
            :locals  => { :label => print_labels(parent_labels) }
          )

          add_to_buffer(value, parent_labels)
        else
          @_buffer += render(
            :partial => 'api_taster/routes/param_form_element',
            :locals  => {
              :label      => "#{print_labels(parent_labels)}#{label}",
              :label_text => label,
              :value      => value.to_s
            }
          )
        end
      end
    end

    def print_labels(parent_labels)
      "[#{parent_labels * ']['}]"
    end
  end
end
