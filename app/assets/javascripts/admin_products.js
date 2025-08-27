// Admin Products JavaScript Enhancements

document.addEventListener('DOMContentLoaded', function() {
  
  // Enhanced file input preview
  function setupFilePreview() {
    const fileInput = document.querySelector('input[type="file"][multiple]');
    if (fileInput) {
      fileInput.addEventListener('change', function(e) {
        const files = e.target.files;
        let preview = document.getElementById('files-preview');
        
        if (!preview) {
          preview = document.createElement('div');
          preview.id = 'files-preview';
          preview.className = 'files-preview-container';
          fileInput.parentNode.appendChild(preview);
        }
        
        if (files.length > 0) {
          let html = '<div class="files-header"><strong>✅ Đã chọn ' + files.length + ' ảnh:</strong></div>';
          html += '<div class="files-list">';
          
          for (let i = 0; i < files.length; i++) {
            const file = files[i];
            const sizeInMB = (file.size / 1024 / 1024).toFixed(2);
            const sizeClass = sizeInMB > 5 ? 'size-warning' : 'size-ok';
            
            html += `
              <div class="file-item">
                <span class="file-icon">📁</span>
                <span class="file-name">${file.name}</span>
                <span class="file-size ${sizeClass}">(${sizeInMB} MB)</span>
              </div>
            `;
          }
          
          html += '</div>';
          preview.innerHTML = html;
        } else {
          preview.innerHTML = '';
        }
      });
    }
  }

  // Form section toggle animation
  function setupSectionAnimations() {
    const sections = document.querySelectorAll('.admin-form-section');
    
    sections.forEach(function(section, index) {
      // Add loading class initially
      section.style.opacity = '0';
      section.style.transform = 'translateY(20px)';
      
      // Animate in with delay
      setTimeout(function() {
        section.style.transition = 'all 0.5s ease';
        section.style.opacity = '1';
        section.style.transform = 'translateY(0)';
      }, index * 150);
    });
  }

  // Enhanced image hover effects
  function setupImageHoverEffects() {
    const imageCards = document.querySelectorAll('.image-summary-card, .gallery-item');
    
    imageCards.forEach(function(card) {
      card.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-5px) scale(1.02)';
      });
      
      card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0) scale(1)';
      });
    });
  }

  // Form validation enhancements
  function setupFormValidation() {
    const form = document.querySelector('.admin-product-form');
    if (form) {
      const requiredFields = form.querySelectorAll('input[required], select[required]');
      
      requiredFields.forEach(function(field) {
        field.addEventListener('blur', function() {
          if (this.value.trim() === '') {
            this.style.borderColor = '#e74c3c';
            this.style.boxShadow = '0 0 0 3px rgba(231, 76, 60, 0.1)';
          } else {
            this.style.borderColor = '#27ae60';
            this.style.boxShadow = '0 0 0 3px rgba(39, 174, 96, 0.1)';
          }
        });
      });
    }
  }

  // Smooth scroll to first error
  function setupErrorScrolling() {
    const errorField = document.querySelector('.field_with_errors input, .field_with_errors select');
    if (errorField) {
      errorField.scrollIntoView({ 
        behavior: 'smooth', 
        block: 'center' 
      });
      errorField.focus();
    }
  }

  // Initialize all enhancements
  setupFilePreview();
  setupSectionAnimations();
  setupImageHoverEffects();
  setupFormValidation();
  setupErrorScrolling();

  // Re-initialize on AJAX updates (for dynamic content)
  $(document).on('has_many_add:after', function() {
    setupImageHoverEffects();
    setupFormValidation();
  });

});

// Additional CSS via JavaScript for dynamic elements
const dynamicStyles = `
  .files-preview-container {
    margin-top: 10px;
    padding: 12px;
    background: rgba(255,255,255,0.1);
    border-radius: 6px;
    border: 1px solid rgba(255,255,255,0.3);
  }

  .files-header {
    color: rgba(255,255,255,0.9);
    font-weight: bold;
    margin-bottom: 8px;
    font-size: 14px;
  }

  .files-list {
    max-height: 150px;
    overflow-y: auto;
  }

  .file-item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 4px 0;
    font-size: 13px;
    color: rgba(255,255,255,0.8);
  }

  .file-icon {
    font-size: 14px;
  }

  .file-name {
    flex: 1;
    word-break: break-word;
  }

  .file-size {
    font-weight: bold;
    font-size: 11px;
  }

  .size-ok {
    color: #90EE90;
  }

  .size-warning {
    color: #FFB84D;
  }

  /* Transition for all interactive elements */
  .admin-form-section,
  .image-summary-card,
  .gallery-item,
  input,
  select,
  textarea {
    transition: all 0.3s ease;
  }
`;

// Inject dynamic styles
if (document.head) {
  const styleSheet = document.createElement('style');
  styleSheet.textContent = dynamicStyles;
  document.head.appendChild(styleSheet);
}
