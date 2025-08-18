//= require active_admin/base
//= require arctic_admin/base

// Custom JavaScript for Active Admin
document.addEventListener("DOMContentLoaded", function () {
  console.log("🚀 Active Admin JavaScript loaded");

  // Auto-apply CKEditor 5 ONLY to fields with class 'ckeditor-apply'
  function initCKEditor() {
    console.log("🔍 Looking for fields with class 'ckeditor-apply'...");

    // Find ALL textareas with class 'ckeditor-apply'
    const ckeditorFields = document.querySelectorAll("textarea.ckeditor-apply");

    if (ckeditorFields.length > 0) {
      console.log(
        `✅ Found ${ckeditorFields.length} field(s) with class 'ckeditor-apply':`,
        ckeditorFields
      );

      // Apply CKEditor 5 to each field
      ckeditorFields.forEach(function (field) {
        console.log(`🎯 Applying CKEditor 5 to field:`, field);

        // Check if CKEditor 5 Super Build is already loaded
        if (typeof CKEDITOR !== "undefined" && CKEDITOR.ClassicEditor) {
          console.log("✅ CKEditor 5 Super Build is available, applying...");
          applyCKEditor5(field);
        } else {
          console.log("📥 Loading CKEditor 5 Super Build from CDN...");
          loadCKEditor5FromCDN(field);
        }
      });
    } else {
      console.log(
        "❌ No fields with class 'ckeditor-apply' found, retrying..."
      );
      // Retry after a short delay
      setTimeout(initCKEditor, 500);
    }
  }

  function loadCKEditor5FromCDN(field) {
    // Load CKEditor 5 CSS - Use SUPER BUILD for image resize features
    if (!document.querySelector('link[href*="ckeditor5"]')) {
      const link = document.createElement("link");
      link.rel = "stylesheet";
      link.href =
        "https://cdn.ckeditor.com/ckeditor5/40.1.0/super-build/ckeditor.css";
      document.head.appendChild(link);
    }

    // Load CKEditor 5 JS - Use SUPER BUILD for image resize features
    if (!document.querySelector('script[src*="ckeditor5"]')) {
      const script = document.createElement("script");
      script.src =
        "https://cdn.ckeditor.com/ckeditor5/40.1.0/super-build/ckeditor.js";
      script.onload = function () {
        console.log("✅ CKEditor 5 SUPER BUILD loaded from CDN, applying...");
        // Wait a bit for CKEDITOR global to be ready
        setTimeout(() => {
          if (typeof CKEDITOR !== "undefined" && CKEDITOR.ClassicEditor) {
            applyCKEditor5(field);
          } else {
            console.error(
              "❌ CKEDITOR.ClassicEditor still not available after loading"
            );
          }
        }, 100);
      };
      script.onerror = function () {
        console.error("❌ Failed to load CKEditor 5 SUPER BUILD from CDN");
      };
      document.head.appendChild(script);
    } else {
      // CKEditor 5 already loaded
      setTimeout(() => {
        if (typeof CKEDITOR !== "undefined" && CKEDITOR.ClassicEditor) {
          applyCKEditor5(field);
        } else {
          console.error(
            "❌ CKEDITOR.ClassicEditor not available in already loaded script"
          );
        }
      }, 100);
    }
  }

  function applyCKEditor5(field) {
    try {
      console.log(
        "🎯 Applying CKEditor 5 to field with class 'ckeditor-apply'..."
      );

      // Check if CKEditor 5 Super Build is available
      if (typeof CKEDITOR === "undefined" || !CKEDITOR.ClassicEditor) {
        console.error(
          "❌ CKEditor 5 Super Build (CKEDITOR.ClassicEditor) not available"
        );
        return;
      }

      // Create CKEditor 5 with PROFESSIONAL ARTICLE EDITING configuration
      CKEDITOR.ClassicEditor.create(field, {
        // PROFESSIONAL TOOLBAR for Article Content Creation
        toolbar: {
          items: [
            // Document Structure
            "heading",
            "|",

            // Text Formatting
            "bold",
            "italic",
            "underline",
            "strikethrough",
            "subscript",
            "superscript",
            "|",

            // Text Alignment & Layout
            "alignment",
            "indent",
            "outdent",
            "|",

            // Lists & Structure
            "bulletedList",
            "numberedList",
            "todoList",
            "|",

            // Links & Media
            "link",
            "blockQuote",
            "insertTable",
            "imageUpload",
            "imageStyle:full",
            "imageStyle:side",
            "imageStyle:alignLeft",
            "imageStyle:alignCenter",
            "imageStyle:alignRight",
            "mediaEmbed",
            "|",

            // Advanced Text Features
            "fontSize",
            "fontFamily",
            "fontColor",
            "fontBackgroundColor",
            "highlight",
            "|",

            // Special Elements
            "horizontalLine",
            "pageBreak",
            "specialCharacters",
            "|",

            // Code & Technical
            "code",
            "codeBlock",
            "|",

            // Document Operations
            "undo",
            "redo",
            "|",

            // Cleanup
            "removeFormat",
            "|",

            // Advanced Features
            "findAndReplace",
            "selectAll",
          ],
          shouldNotGroupWhenFull: true,
        },

        // Enhanced Heading Options for Articles
        heading: {
          options: [
            {
              model: "paragraph",
              title: "Paragraph",
              class: "ck-heading_paragraph",
            },
            {
              model: "heading1",
              view: "h1",
              title: "Heading 1 - Main Title",
              class: "ck-heading_heading1",
            },
            {
              model: "heading2",
              view: "h2",
              title: "Heading 2 - Section Title",
              class: "ck-heading_heading2",
            },
            {
              model: "heading3",
              view: "h3",
              title: "Heading 3 - Subsection",
              class: "ck-heading_heading3",
            },
            {
              model: "heading4",
              view: "h4",
              title: "Heading 4 - Sub-subsection",
              class: "ck-heading_heading4",
            },
            {
              model: "heading5",
              view: "h5",
              title: "Heading 5",
              class: "ck-heading_heading5",
            },
            {
              model: "heading6",
              view: "h6",
              title: "Heading 6",
              class: "ck-heading_heading6",
            },
          ],
        },

        // Professional Table Configuration
        table: {
          contentToolbar: [
            "tableColumn",
            "tableRow",
            "mergeTableCells",
            "tableProperties",
            "tableCellProperties",
            "toggleTableCaption",
          ],
          defaultProperties: {
            borderWidth: "1px",
            borderColor: "#ccc",
            backgroundColor: "#f9f9f9",
          },
        },

        // Advanced Link Configuration
        link: {
          addTargetToExternalLinks: true,
          defaultProtocol: "https://",
          decorators: {
            openInNewTab: {
              mode: "manual",
              label: "Open in new tab",
              attributes: {
                target: "_blank",
                rel: "noopener noreferrer",
              },
            },
            downloadable: {
              mode: "manual",
              label: "Downloadable",
              attributes: {
                download: "download",
              },
            },
          },
        },

        // Comprehensive Font Configuration
        fontSize: {
          options: [
            8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
            25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
            42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58,
            59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72,
          ],
        },

        fontFamily: {
          options: [
            "default",
            "Arial, Helvetica, sans-serif",
            "Arial Black, Gadget, sans-serif",
            "Bookman Old Style, serif",
            "Comic Sans MS, cursive, sans-serif",
            "Courier New, Courier, monospace",
            "Georgia, serif",
            "Helvetica, Arial, sans-serif",
            "Impact, Charcoal, sans-serif",
            "Lucida Console, Monaco, monospace",
            "Lucida Sans Unicode, Lucida Grande, sans-serif",
            "MS Sans Serif, Geneva, sans-serif",
            "MS Serif, New York, serif",
            "Palatino Linotype, Book Antiqua, Palatino, serif",
            "Tahoma, Geneva, sans-serif",
            "Times New Roman, Times, serif",
            "Trebuchet MS, Geneva, sans-serif",
            "Verdana, Geneva, sans-serif",
          ],
        },

        // Professional Color Palette
        fontColor: {
          colors: [
            // Basic Colors
            { color: "hsl(0, 0%, 0%)", label: "Black" },
            { color: "hsl(0, 0%, 30%)", label: "Dark Gray" },
            { color: "hsl(0, 0%, 60%)", label: "Gray" },
            { color: "hsl(0, 0%, 90%)", label: "Light Gray" },
            { color: "hsl(0, 0%, 100%)", label: "White", hasBorder: true },

            // Primary Colors
            { color: "hsl(0, 100%, 50%)", label: "Red" },
            { color: "hsl(60, 100%, 50%)", label: "Yellow" },
            { color: "hsl(120, 100%, 50%)", label: "Green" },
            { color: "hsl(240, 100%, 50%)", label: "Blue" },
            { color: "hsl(25, 75%, 47%)", label: "Orange" },
            { color: "hsl(330, 75%, 47%)", label: "Pink" },

            // Professional Colors
            { color: "hsl(210, 100%, 50%)", label: "Professional Blue" },
            { color: "hsl(120, 60%, 40%)", label: "Forest Green" },
            { color: "hsl(30, 80%, 50%)", label: "Warm Orange" },
            { color: "hsl(280, 60%, 50%)", label: "Purple" },
            { color: "hsl(0, 60%, 50%)", label: "Brick Red" },
            { color: "hsl(45, 100%, 50%)", label: "Gold" },
          ],
        },

        fontBackgroundColor: {
          colors: [
            // Highlight Colors
            { color: "hsl(60, 100%, 90%)", label: "Light Yellow Highlight" },
            { color: "hsl(120, 100%, 90%)", label: "Light Green Highlight" },
            { color: "hsl(210, 100%, 90%)", label: "Light Blue Highlight" },
            { color: "hsl(330, 100%, 90%)", label: "Light Pink Highlight" },

            // Background Colors
            { color: "hsl(0, 75%, 60%)", label: "Red Background" },
            { color: "hsl(30, 75%, 60%)", label: "Orange Background" },
            { color: "hsl(60, 75%, 60%)", label: "Yellow Background" },
            { color: "hsl(90, 75%, 60%)", label: "Light Green Background" },
            { color: "hsl(120, 75%, 60%)", label: "Green Background" },
            { color: "hsl(150, 75%, 60%)", label: "Cyan Background" },
            { color: "hsl(180, 75%, 60%)", label: "Blue Background" },
            { color: "hsl(210, 75%, 60%)", label: "Light Blue Background" },
            { color: "hsl(240, 75%, 60%)", label: "Purple Background" },
            { color: "hsl(270, 75%, 60%)", label: "Pink Background" },
            { color: "hsl(300, 75%, 60%)", label: "Light Pink Background" },
            { color: "hsl(330, 75%, 60%)", label: "Light Red Background" },
            { color: "hsl(0, 0%, 100%)", label: "White Background" },
            { color: "hsl(0, 0%, 0%)", label: "Black Background" },
          ],
        },

        // Enhanced UI Configuration
        ui: {
          viewportOffset: {
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          },
        },

        // Advanced Paste Handling
        clipboard: {
          handleImages: true,
          handleFiles: true,
        },

        // Professional Image Handling with Custom Upload and FULL Resize Support
        image: {
          upload: {
            types: ["jpeg", "png", "gif", "bmp", "webp", "tiff", "svg"],
            allowMultipleFiles: true,
          },
          resizeOptions: [
            {
              name: "imageResize:original",
              value: null,
              label: "Original",
            },
            {
              name: "imageResize:25",
              value: "25",
              label: "25%",
            },
            {
              name: "imageResize:50",
              value: "50",
              label: "50%",
            },
            {
              name: "imageResize:75",
              value: "75",
              label: "75%",
            },
          ],
          styles: [
            "alignLeft",
            "alignCenter",
            "alignRight",
            "alignBlockLeft",
            "alignBlockRight",
          ],
          // Enable FULL image resize functionality
          resizeUnit: "%",
          // Enable resize handles on all corners
          resizeOptions: [
            {
              name: "imageResize:original",
              value: null,
              label: "Original",
            },
            {
              name: "imageResize:25",
              value: "25",
              label: "25%",
            },
            {
              name: "imageResize:50",
              value: "50",
              label: "50%",
            },
            {
              name: "imageResize:75",
              value: "75",
              label: "75%",
            },
          ],
        },

        // Image Styles for Better Control
        imageStyle: {
          options: [
            "inline",
            "block",
            "side",
            "alignLeft",
            "alignCenter",
            "alignRight",
          ],
        },

        // Media Embed Configuration
        mediaEmbed: {
          previewsInData: true,
          providers: [
            {
              name: "youtube",
              url: [
                /^(?:m\.)?youtube\.com\/watch\?v=([\w-]+)/,
                /^(?:m\.)?youtube\.com\/v\/([\w-]+)/,
                /^youtube\.com\/embed\/([\w-]+)/,
                /^youtu\.be\/([\w-]+)/,
              ],
              html: '<iframe src="https://www.youtube.com/embed/{id}?wmode=transparent" width="480" height="270" frameborder="0" allowfullscreen></iframe>',
            },
            {
              name: "vimeo",
              url: [
                /^vimeo\.com\/(\d+)/,
                /^vimeo\.com\/video\/(\d+)/,
                /^vimeo\.com\/groups\/[\w-]+\/videos\/(\d+)/,
                /^vimeo\.com\/channels\/[\w-]+\/(\d+)/,
              ],
              html: '<iframe src="https://player.vimeo.com/video/{id}" width="480" height="270" frameborder="0" allowfullscreen></iframe>',
            },
          ],
        },

        // Code Block Configuration
        codeBlock: {
          languages: [
            { language: "plaintext", label: "Plain text" },
            { language: "c", label: "C" },
            { language: "cpp", label: "C++" },
            { language: "csharp", label: "C#" },
            { language: "css", label: "CSS" },
            { language: "html", label: "HTML" },
            { language: "java", label: "Java" },
            { language: "javascript", label: "JavaScript" },
            { language: "json", label: "JSON" },
            { language: "php", label: "PHP" },
            { language: "python", label: "Python" },
            { language: "ruby", label: "Ruby" },
            { language: "sql", label: "SQL" },
            { language: "typescript", label: "TypeScript" },
            { language: "xml", label: "XML" },
          ],
        },

        // Find and Replace Configuration
        findAndReplace: {
          find: {
            options: {
              matchCase: false,
              matchWholeWords: false,
              matchDiacritics: false,
            },
          },
        },

        // Language Configuration
        language: "en",

        // Disable collaboration/premium plugins to avoid cloud config errors
        removePlugins: [
          "AIAssistant",
          "CKBox",
          "CKFinder",
          "EasyImage",
          "RealTimeCollaborativeComments",
          "RealTimeCollaborativeTrackChanges",
          "RealTimeCollaborativeRevisionHistory",
          "PresenceList",
          "Comments",
          "TrackChanges",
          "TrackChangesData",
          "RevisionHistory",
          "Pagination",
          "WProofreader",
          "MathType",
          "SlashCommand",
          "Template",
          "DocumentOutline",
          "FormatPainter",
          "TableOfContents",
          "PasteFromOfficeEnhanced",
          "CaseChange",
          "ExportPdf",
          "ExportWord",
          "CloudServices",
          "Title",
        ],
      })
        .then((editor) => {
          console.log(
            "✅ CKEditor 5 applied successfully with PROFESSIONAL ARTICLE EDITING features!"
          );

          // Store reference to editor
          field.ckeditor5 = editor;

          // Add professional event handlers
          editor.model.document.on("change:data", () => {
            console.log("📝 Content changed in CKEditor 5 - Article Editor");
          });

          // Enhanced auto-resize functionality for articles
          editor.ui.view.element.style.minHeight = "400px";
          editor.ui.view.element.style.maxHeight = "800px";

          // Add professional styling
          editor.ui.view.element.style.borderRadius = "8px";
          editor.ui.view.element.style.boxShadow =
            "0 4px 12px rgba(0, 0, 0, 0.1)";

          // Configure custom image upload adapter
          editor.plugins.get("FileRepository").createUploadAdapter = (
            loader
          ) => {
            return new CustomUploadAdapter(loader);
          };

          console.log(
            "🎨 Professional Article Editor ready with enhanced features and custom upload!"
          );
        })
        .catch((error) => {
          console.error("❌ Error creating CKEditor 5:", error);
        });
    } catch (error) {
      console.error("❌ Error applying CKEditor 5:", error);
    }
  }

  // Custom Upload Adapter for CKEditor 5
  class CustomUploadAdapter {
    constructor(loader) {
      this.loader = loader;
      this.url = "/ckeditor/upload";
    }

    upload() {
      return this.loader.file.then((file) => {
        const formData = new FormData();
        formData.append("upload", file);

        return fetch(this.url, {
          method: "POST",
          body: formData,
          headers: {
            "X-CSRF-Token":
              document
                .querySelector('meta[name="csrf-token"]')
                ?.getAttribute("content") || "",
          },
        })
          .then((response) => {
            if (!response.ok) {
              throw new Error(`Upload failed: ${response.statusText}`);
            }
            return response.json();
          })
          .then((result) => {
            if (result.error) {
              throw new Error(result.error.message);
            }
            return {
              default: result.url,
            };
          });
      });
    }

    abort() {
      // Abort upload if needed
    }
  }

  // Initialize CKEditor 5
  initCKEditor();

  // Also try to initialize when navigating between pages
  document.addEventListener("turbolinks:load", initCKEditor);
  document.addEventListener("page:load", initCKEditor);
});
