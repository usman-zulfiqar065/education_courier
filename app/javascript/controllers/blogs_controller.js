import { Controller } from "@hotwired/stimulus"
import 'quill'
export default class extends Controller {
 static targets = ["quillEditor"]

  connect() {
    this.quill = new Quill(this.quillEditorTarget, {
      modules: { toolbar: this.get_tollbar_btns() },
      placeholder: 'Compose an epic...',
      theme: 'snow'
    });
    var input_field = document.getElementById("blog_content")
    this.quill.container.firstChild.innerHTML = input_field.value;
    this.quill.on('text-change', (delta, oldDelta, source) => {
      document.getElementById("blog_content").value = this.quill.container.firstChild.innerHTML;
    });
  }

  get_tollbar_btns() {
    return [
      [{ 'font': [] }],
      ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
      ['blockquote', 'code-block'],
  
      [{ 'header': 1 }, { 'header': 2 }],               // custom button values
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      [{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript
      [{ 'indent': '-1'}, { 'indent': '+1' }],          // outdent/indent
      [{ 'direction': 'rtl' }],                         // text direction
  
      [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown
      [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
  
      [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
      [{ 'align': [] }],
      ['link'],
        
      ['clean']    
    ]
  }

  disconnect() { if (this.quill) this.quill = null; }
}