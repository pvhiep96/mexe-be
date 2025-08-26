class CkeditorInput < Formtastic::Inputs::TextInput
  def input_html_options
    super.merge(
      class: 'ckeditor',
      data: {
        'ckeditor-config': 'default'
      }
    )
  end

  def to_html
    input_wrapping do
      label_html <<
      builder.text_area(method, input_html_options) <<
      ckeditor_script
    end
  end

  private

  def ckeditor_script
    template.content_tag(:script, type: 'text/javascript') do
      "CKEDITOR.replace('#{dom_id}', {
        height: 300,
        removePlugins: 'elementspath,resize',
        toolbar: [
          { name: 'document', items: ['Source', '-', 'Save', 'NewPage', 'Preview', 'Print', '-', 'Templates'] },
          { name: 'clipboard', items: ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo'] },
          { name: 'editing', items: ['Find', 'Replace', '-', 'SelectAll', '-', 'SpellChecker', 'Scayt'] },
          { name: 'forms', items: ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'] },
          '/',
          { name: 'basicstyles', items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'CopyFormatting', 'RemoveFormat'] },
          { name: 'paragraph', items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl'] },
          { name: 'links', items: ['Link', 'Unlink', 'Anchor'] },
          { name: 'insert', items: ['Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe'] },
          '/',
          { name: 'styles', items: ['Styles', 'Format', 'Font', 'FontSize'] },
          { name: 'colors', items: ['TextColor', 'BGColor'] },
          { name: 'tools', items: ['Maximize', 'ShowBlocks'] }
        ]
      });".html_safe
    end
  end
end
