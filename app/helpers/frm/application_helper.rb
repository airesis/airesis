module Frm
  module ApplicationHelper
    include FormattingHelper
    # processes text with installed markup formatter
    def forem_format(text, *_options)
      text
    end

    def forem_quote(text)
      as_quoted_text(text)
    end

    def forem_pages_widget(collection)
      if collection.num_pages > 1
        content_tag :div, class: 'pages' do
          (t('frm.common.pages') + ':' + forem_paginate(collection)).html_safe
        end
      end
    end

    def forem_paginate(collection, options = {})
      paginate collection, options
    end
  end
end
