module ActiveAdmin
  module Globalize
    module FilterEmptyTranslations
      private
      # Activeadmin-globalize3 renders inputs for all translations,
      # resulting in many empty translations being created by globalize.
      #
      # For instance, given the available locales L1, L2 and L2, the
      # following params would be submitted on 'create':
      #
      # {
      #   :
      #   MODEL => {
      #     "translations_attributes" => {
      #       "0" => {
      #         "locale"=>"L1", "id" => "", ATTR1 => "", ATTR2 => "", ...
      #       }
      #       "1" => {
      #         "locale"=>"L2", "id" => "", ATTR1 => "", ATTR2 => "", ...
      #       }
      #       "2" => {
      #         "locale"=>"L3", "id" => "", ATTR1 => "", ATTR2 => "", ...
      #       }
      #     }
      #   }
      #   :
      # }
      #
      # Given these parameters, globalize3 would create a record for every
      # possible translation - even empty ones.
      #
      # This filter removes all empty and unsaved translations from params
      # and marks empty and saved translation for deletion.
      def filter_empty_translations
        model = controller_name.singularize.to_sym
        if params.has_key?(model)
          if params.has_key?(:translations_attributes)
            params[model][:translations_attributes].each do |t|
              num = - 1
              num = num - 1 if t.last[:id].present?
              num = num - 1 if t.last[:_destroy].present?
              num = num - 1 if t.last[:seo_meta_attributes].present? 
              if !(t.last.map { |_, v| v.empty? ? true : false }[2..num]).include?(false)
                if t.last[:id].empty?
                  params[model][:translations_attributes].delete(t.first)
                else
                  params[model][:translations_attributes][t.first]['_destroy'] = '1'
                end
              end
            end
          end
        end
      end
    end
  end
end
