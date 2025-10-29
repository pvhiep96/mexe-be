// Dynamic Nested Forms for Administrate
document.addEventListener('DOMContentLoaded', function() {
  
  // Initialize CKEditor for existing textareas
  initializeCKEditor();
  
  // Add event listeners for add/remove buttons
  setupNestedFormHandlers();
  
  // Initialize bulk image upload
  initializeBulkImageUpload();
});

function initializeCKEditor() {
  if (typeof CKEDITOR !== 'undefined') {
    var textareas = document.querySelectorAll('textarea.ckeditor');
    textareas.forEach(function(textarea) {
      if (!CKEDITOR.instances[textarea.id]) {
        CKEDITOR.replace(textarea.id, {
          height: 400,
          language: 'vi',
          toolbar: [
            { name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },
            { name: 'clipboard', items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
            { name: 'editing', items: [ 'Find', 'Replace', '-', 'SelectAll' ] },
            '/',
            { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
            { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
            { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
            '/',
            { name: 'insert', items: [ 'Image', 'Table', 'HorizontalRule', 'SpecialChar' ] },
            { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
            { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
            { name: 'tools', items: [ 'Maximize' ] }
          ],
          filebrowserBrowseUrl: '/ckeditor/attachment_files',
          filebrowserImageBrowseUrl: '/ckeditor/pictures',
          filebrowserImageUploadUrl: '/ckeditor/pictures',
          filebrowserUploadUrl: '/ckeditor/attachment_files'
        });
      }
    });
  }
}

function setupNestedFormHandlers() {
  // Add image button handler
  var addImageBtn = document.getElementById('add-product-image');
  if (addImageBtn) {
    addImageBtn.addEventListener('click', function(e) {
      e.preventDefault();
      addProductImage();
    });
  }
  
  // Add description button handler  
  var addDescBtn = document.getElementById('add-product-description');
  if (addDescBtn) {
    addDescBtn.addEventListener('click', function(e) {
      e.preventDefault();
      addProductDescription();
    });
  }
  
  // Add specification button handler
  var addSpecBtn = document.getElementById('add-product-specification');
  if (addSpecBtn) {
    addSpecBtn.addEventListener('click', function(e) {
      e.preventDefault();
      addProductSpecification();
    });
  }
  
  // Add video button handler
  var addVideoBtn = document.getElementById('add-product-video');
  if (addVideoBtn) {
    addVideoBtn.addEventListener('click', function(e) {
      e.preventDefault();
      addProductVideo();
    });
  }

  // Add variant button handler
  var addVariantBtn = document.getElementById('add-product-variant');
  if (addVariantBtn) {
    addVariantBtn.addEventListener('click', function(e) {
      e.preventDefault();
      addProductVariant();
    });
  }

  // Remove button handlers
  document.addEventListener('click', function(e) {
    if (e.target.classList.contains('remove-nested-field')) {
      e.preventDefault();
      removeNestedField(e.target);
    }
  });
}

function addProductImage() {
  var container = document.getElementById('product-images-container');
  var template = document.getElementById('product-image-template');
  
  if (container && template) {
    var newIndex = Date.now(); // Use timestamp as unique index
    var newField = template.innerHTML.replace(/NEW_RECORD/g, newIndex);
    
    var wrapper = document.createElement('div');
    wrapper.innerHTML = newField;
    wrapper.className = 'nested-field-wrapper';
    
    container.appendChild(wrapper);
    
    // Initialize image preview for new field
    var newFileInput = wrapper.querySelector('.image-upload');
    if (newFileInput) {
      newFileInput.addEventListener('change', function(e) {
        handleImagePreview(e.target);
      });
    }
    
    // Initialize preview removal for new field
    var removePreviewBtn = wrapper.querySelector('.remove-preview');
    if (removePreviewBtn) {
      removePreviewBtn.addEventListener('click', function(e) {
        removeImagePreview(e.target);
      });
    }
  }
}

function handleImagePreview(fileInput) {
  const file = fileInput.files[0];
  const previewTarget = fileInput.getAttribute('data-preview-target');
  const previewContainer = document.getElementById(previewTarget);
  
  if (!file || !previewContainer) return;
  
  // Validate file type
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
  if (!validTypes.includes(file.type)) {
    alert('Chỉ chấp nhận các định dạng: JPG, PNG, WebP');
    fileInput.value = '';
    return;
  }
  
  // Validate file size (max 5MB)
  const maxSize = 5 * 1024 * 1024;
  if (file.size > maxSize) {
    alert('Kích thước file không được vượt quá 5MB');
    fileInput.value = '';
    return;
  }
  
  // Create preview
  const reader = new FileReader();
  reader.onload = function(e) {
    const previewImage = previewContainer.querySelector('.preview-image');
    previewImage.src = e.target.result;
    previewContainer.style.display = 'block';
  };
  reader.readAsDataURL(file);
}

function removeImagePreview(button) {
  const previewContainer = button.closest('.image-preview');
  const fieldWrapper = button.closest('.nested-field-wrapper');
  const fileInput = fieldWrapper.querySelector('.image-upload');
  
  previewContainer.style.display = 'none';
  fileInput.value = '';
}

function addProductDescription() {
  var container = document.getElementById('product-descriptions-container');
  var template = document.getElementById('product-description-template');
  
  if (container && template) {
    var newIndex = Date.now(); // Use timestamp as unique index
    var newField = template.innerHTML.replace(/NEW_RECORD/g, newIndex);
    
    var wrapper = document.createElement('div');
    wrapper.innerHTML = newField;
    wrapper.className = 'nested-field-wrapper';
    
    container.appendChild(wrapper);
    
    // Initialize CKEditor for the new textarea
    setTimeout(function() {
      var newTextarea = wrapper.querySelector('textarea.ckeditor');
      if (newTextarea && typeof CKEDITOR !== 'undefined') {
        CKEDITOR.replace(newTextarea.id, {
          height: 400,
          width: '100%',
          language: 'vi',
          toolbar: [
            { name: 'document', items: [ 'Source', '-', 'Preview', '-', 'Templates' ] },
            { name: 'clipboard', items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
            { name: 'editing', items: [ 'Find', 'Replace', '-', 'SelectAll' ] },
            '/',
            { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
            { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
            { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
            '/',
            { name: 'insert', items: [ 'Image', 'Table', 'HorizontalRule', 'SpecialChar' ] },
            { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
            { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
            { name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] }
          ],
          removeDialogTabs: 'image:advanced;link:advanced'
        });
      }
    }, 200);
    
    if (typeof reinitializeCKEditor === 'function') {
      reinitializeCKEditor();
    }
  }
}

function addProductSpecification() {
  var container = document.getElementById('product-specifications-container');
  var template = document.getElementById('product-specification-template');
  
  if (container && template) {
    var newIndex = Date.now(); // Use timestamp as unique index
    var newField = template.innerHTML.replace(/NEW_RECORD/g, newIndex);
    
    var wrapper = document.createElement('div');
    wrapper.innerHTML = newField;
    wrapper.className = 'nested-field-wrapper';
    
    container.appendChild(wrapper);
  }
}

function addProductVideo() {
  var container = document.getElementById('product-videos-container');
  var template = document.getElementById('product-video-template');

  if (container && template) {
    var newIndex = Date.now(); // Use timestamp as unique index
    var newField = template.innerHTML.replace(/NEW_RECORD/g, newIndex);

    var wrapper = document.createElement('div');
    wrapper.innerHTML = newField;
    wrapper.className = 'nested-field-wrapper';

    container.appendChild(wrapper);
  }
}

function addProductVariant() {
  var container = document.getElementById('product-variants-container');
  var template = document.getElementById('product-variant-template');

  if (container && template) {
    var newIndex = Date.now(); // Use timestamp as unique index
    var newField = template.innerHTML.replace(/NEW_RECORD/g, newIndex);

    var wrapper = document.createElement('div');
    wrapper.innerHTML = newField;
    wrapper.className = 'nested-field-wrapper';

    container.appendChild(wrapper);
  }
}

function removeNestedField(button) {
  var fieldWrapper = button.closest('.nested-field-wrapper');
  var destroyField = fieldWrapper.querySelector('input[name*="[_destroy]"]');
  
  if (destroyField) {
    // Mark for destruction
    destroyField.value = '1';
    fieldWrapper.style.display = 'none';
  } else {
    // Remove from DOM (new record)
    var ckeditorTextarea = fieldWrapper.querySelector('textarea.ckeditor');
    if (ckeditorTextarea && CKEDITOR.instances[ckeditorTextarea.id]) {
      CKEDITOR.instances[ckeditorTextarea.id].destroy();
    }
    fieldWrapper.remove();
  }
}

function initializeBulkImageUpload() {
  const bulkUpload = document.getElementById('bulk-image-upload');
  if (!bulkUpload) return;
  
  // Add drag and drop functionality
  const bulkSection = document.querySelector('.bulk-upload-section');
  if (bulkSection) {
    bulkSection.addEventListener('dragover', function(e) {
      e.preventDefault();
      e.stopPropagation();
      bulkSection.style.borderColor = '#28a745';
      bulkSection.style.background = '#d4edda';
    });
    
    bulkSection.addEventListener('dragleave', function(e) {
      e.preventDefault();
      e.stopPropagation();
      bulkSection.style.borderColor = '#007bff';
      bulkSection.style.background = '#f8f9fa';
    });
    
    bulkSection.addEventListener('drop', function(e) {
      e.preventDefault();
      e.stopPropagation();
      bulkSection.style.borderColor = '#007bff';
      bulkSection.style.background = '#f8f9fa';
      
      const files = e.dataTransfer.files;
      if (files.length > 0) {
        // Create a new FileList and assign to input
        const dataTransfer = new DataTransfer();
        Array.from(files).forEach(file => {
          if (file.type.startsWith('image/')) {
            dataTransfer.items.add(file);
          }
        });
        bulkUpload.files = dataTransfer.files;
        
        // Trigger change event
        const event = new Event('change', { bubbles: true });
        bulkUpload.dispatchEvent(event);
      }
    });
  }
}