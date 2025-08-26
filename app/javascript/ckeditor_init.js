// CKEditor initialization for Active Admin
document.addEventListener('DOMContentLoaded', function() {
  // Initialize CKEditor for all textareas with ckeditor class
  const ckeditorTextareas = document.querySelectorAll('textarea.ckeditor');
  
  ckeditorTextareas.forEach(function(textarea) {
    if (typeof CKEDITOR !== 'undefined') {
      CKEDITOR.replace(textarea, {
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
      });
    }
  });
});

// Also initialize when Turbo navigates (for Active Admin)
document.addEventListener('turbo:load', function() {
  const ckeditorTextareas = document.querySelectorAll('textarea.ckeditor');
  
  ckeditorTextareas.forEach(function(textarea) {
    if (typeof CKEDITOR !== 'undefined') {
      CKEDITOR.replace(textarea, {
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
      });
    }
  });
});
